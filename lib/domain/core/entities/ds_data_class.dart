import 'package:crane_monitoring_app/domain/core/entities/ds_data_class_value.dart';
import 'package:crane_monitoring_app/domain/core/error/failure.dart';


///
/// Классифицирует сигнал/команду передаваемую между DataServer и клиентами:
/// - [requestAll] - команда запрашивает все тэги, 
/// - [requestList] - команда запрашивает списком имен тэгов, 
///   ожидая что DataSetver отправит их последние значения в поток;
/// - [requestTime] - команда запрашивает текущее время с DataServer;
/// - [requestAlarms] - команда запрашивает активные аварии;
/// - [requestPath] - команда запрашивает все тэги по указанному пути;
/// - [syncTime] - команда синхронизации времени;
/// - [commonCmd] - команда со значением типа Bool, Int, Real, etc...;
/// - [intCmd] - команда со значением типа Int;
/// - [realCmd] - команда со значением типа Real;
/// - [commonData] - тэги со значением типа Bool, Int, Real, etc...;
class DsDataClass {
  late String _name;
  DsDataClass.requestAll() {
    _name = DsDataClassValue.requestAll.value;
  }
  DsDataClass.requestList() {
    _name = DsDataClassValue.requestList.value;
  }
  DsDataClass.requestTime() {
    _name = DsDataClassValue.requestTime.value;
  }
  DsDataClass.requestAlarms() {
    _name = DsDataClassValue.requestAlarms.value;
  }
  DsDataClass.requestPath() {
    _name = DsDataClassValue.requestPath.value;
  }
  DsDataClass.syncTime() {
    _name = DsDataClassValue.syncTime.value;
  }
  DsDataClass.commonCmd() {
    _name = DsDataClassValue.commonCmd.value;
  }
  DsDataClass.commonData() {
    _name = DsDataClassValue.commonData.value;
  }
  ///
  DsDataClass.fromString(String value) {
    if (value == DsDataClassValue.requestAll.value) {
      _name = DsDataClassValue.requestAll.value;
    } else if (value == DsDataClassValue.requestList.value) {
      _name = DsDataClassValue.requestList.value;
    } else if (value == DsDataClassValue.requestTime.value) {
      _name = DsDataClassValue.requestTime.value;
    } else if (value == DsDataClassValue.requestAlarms.value) {
      _name = DsDataClassValue.requestAlarms.value;
    } else if (value == DsDataClassValue.requestPath.value) {
      _name = DsDataClassValue.requestPath.value;
    } else if (value == DsDataClassValue.syncTime.value) {
      _name = DsDataClassValue.syncTime.value;
    } else if (value == DsDataClassValue.commonCmd.value) {
      _name = DsDataClassValue.commonCmd.value;
    } else if (value == DsDataClassValue.commonData.value) {
      _name = DsDataClassValue.commonData.value;
    } else {
      throw Failure.connection(
        message: 'Ошибка в методе $runtimeType.fromString: неизвестный класс комманды "$value"',
        stackTrace: StackTrace.current,
      );
    }
  }
  ///
  String get name => _name;
  ///
  @override
  String toString() {
    return 'DsDataClass {name: $_name}';
  }
  ///
  @override
  int get hashCode => super.hashCode;
  ///
  @override
  bool operator ==(Object other) =>
    other is DsDataClass &&
    other.runtimeType == runtimeType &&
    other.name == name;
  }
