import 'dart:convert';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_type.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';


abstract class IDataPoint<T> {

}


class DsDataPoint<T> implements IDataPoint {
  late DsDataType _type;
  late String _path;
  late String _name;
  late T _value;
  late DsStatus _status;
  late int _history;
  late int _alarm;
  late String _timestamp;
  ///
  /// Represent a data received from SocketDataServer
  /// wich contains map in json like:
  ///   type: S7DataType
  ///   name: 'part.subpart1.sabpart...'
  ///   value: current value of type depending on S7DataType
  DsDataPoint({
    required DsDataType type,
    required String path,
    required String name,
    required T value,
    int history = 0,
    int alarm = 0,
    required DsStatus status,
    required String timestamp,
  }):
    _type = type,
    _path = path,
    _name = name,
    _value = value,
    _status = status,
    _history = history,
    _alarm = alarm,
    _timestamp = timestamp;
  ///
  DsDataPoint.fromRow(Map<String, dynamic> row) {
    // log(true, '[$DataPoint.fromRow] row: $row');
    int history = 0;
    int alarm = 0;
    if (row.containsKey('history')) history = row['history'] as int;
    if (row.containsKey('alarm')) alarm = row['alarm'] as int;
    try {
      _type = DsDataType.fromString('${row['type']}');
      _path = '${row['path']}';
      _name = '${row['name']}';
      _value = '${row['value']}' as T;
      _status = DsStatus.fromString('${row['status']}');
      _history = history;
      _alarm = alarm;
      _timestamp = '${row['timestamp']}';
    } catch (error) {
      log(true, '[$DsDataPoint.fromRow] error: $error\nrow: $row');
      // log(ug, '[$DataPoint.fromJson] dataPoint: $dataPoint');
      // throw Failure.convertion(
      //   message: 'Ошибка в методе $runtimeType.parse() $error',
      //   stackTrace: StackTrace.current,
      // );
    }
    // print('event: $decoded');
  }
  ///
  factory DsDataPoint.fromJson(String json) {
    // log(true, '[$DataPoint.fromJson] json: $json');
    try {
      final row = const JsonCodec().decode(json) as Map<String, dynamic>;
      return DsDataPoint<T>.fromRow(row);
    } catch (error) {
      log(true, '[$DsDataPoint.fromJson] error: $error\njson: $json');
      return DsDataPoint<T>.fromRow({});
    }
  }
  ///
  String toJson() {
    return json.encode({
      'type': _type.name,
      'path': _path,
      'name': _name,
      'value': _value,
      'status': _status,
      'history': _history,
      'alarm': _alarm,
      'timestamp': _timestamp,
    });
  }
  ///
  DsDataType get type => _type;
  ///
  String get path => _path;
  ///
  String get name => _name;
  ///
  T get value => _value;
  ///
  DsStatus get status => _status;
  ///
  int get history => _history;
  ///
  int get alarm => _alarm;
  ///
  String get timestamp => _timestamp;
  ///
  String get valueStr => '$_value';
  ///
  @override
  String toString() {
    return 'DataPoint {type: $_type, name: $_name, value: $_value, status: $_status, history: $_history, alarm: $_alarm}';
  }
}
