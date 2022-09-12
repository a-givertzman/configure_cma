import 'dart:convert';
import 'package:configure_cma/domain/core/entities/ds_data_class.dart';
import 'package:configure_cma/domain/core/entities/ds_data_type.dart';
import 'package:configure_cma/domain/core/entities/ds_status.dart';
import 'package:configure_cma/domain/core/entities/ds_timestamp.dart';
import 'package:configure_cma/domain/core/log/log.dart';

///
/// Команда управления передаваемая в DataServer
class DsCommand<T> {
  late DsDataClass _dsClass;
  late DsDataType _type;
  late String _path;
  late String _name;
  late T _value;
  late DsStatus _status;
  late DsTimeStamp _timestamp;
  ///
  DsCommand({
    required DsDataClass dsClass,
    required DsDataType type,
    required String path,
    required String name,
    required T value,
    required DsStatus status,
    required DsTimeStamp timestamp,
  }):
    _dsClass = dsClass,
    _type = type,
    _path = path,
    _name = name,
    _value = value,
    _status = status,
    _timestamp = timestamp;
  ///
  DsCommand.fromJson(String json) {
    // log(true, '[$DataPoint.fromJson] json: $json');
    try {
      final decoded = const JsonCodec().decode(json) as Map;
      _dsClass = DsDataClass.fromString('${decoded['class']}');
      _type = DsDataType.fromString('${decoded['type']}');
      _path = '${decoded['path']}';
      _name = '${decoded['name']}';
      _value = int.parse('${decoded['value']}') as T;
      _status = DsStatus.fromString('${decoded['status']}');
      _timestamp = DsTimeStamp.parse('${decoded['timestamp']}');
    } catch (error) {
      log(true, '[$DsCommand.fromJson] error: $error\njson: $json');
      // log(ug, '[$DsCommand.fromJson] dataPoint: $dataPoint');
      // throw Failure.convertion(
      //   message: 'Ошибка в методе $runtimeType.fromJson() $error',
      //   stackTrace: StackTrace.current,
      // );
    }
    // print('event: $decoded');
  }
  ///
  String toJson() {
    return json.encode({
      'class': _dsClass.name,
      'type': _type.name,
      'path': _path,
      'name': _name,
      'value': _value,
      'status': _status.name.value,
      'timestamp': _timestamp.toString(),
    });
  }
  ///
  DsDataClass get dsClass => _dsClass;
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
  DsTimeStamp get timestamp => _timestamp;
  ///
  String get valueStr => '$_value';
  ///
  @override
  String toString() {
    return 'DsCommand {class: $_dsClass, type: $_type, name: $_name, value: $_value, status: $_status, timestamp: $_timestamp}';
  }
  ///
  @override
  int get hashCode => super.hashCode;
  ///
  @override
  bool operator ==(Object other) =>
    other is DsCommand &&
    other.runtimeType == runtimeType &&
    other.dsClass == dsClass &&
    other.type == type &&
    other.path == path &&
    other.name == name &&
    other.value == value &&
    other.status == status &&
    other.timestamp == _timestamp;
}
