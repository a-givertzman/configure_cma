import 'package:configure_cma/domain/core/entities/ds_status_value.dart';
import 'package:configure_cma/domain/core/error/failure.dart';

///
/// Классифицирует статусы сигналов/команд передаваемую между DataServer и клиентами:
/// - [ok] - 0, в норме, 
/// - [obsolete] - ,2 устаревшее значение, тэг не обновлен;
/// - [timeInvalid] - 3, недостоверная метка времени;
/// - [invalid] - 10, недостоверное значение, возникает при обрыве связи
class DsStatus {
  late DsStatusValue _name;
  DsStatus.ok() {
    _name = DsStatusValue.ok;
  }
  DsStatus.obsolete() {
    _name = DsStatusValue.obsolete;
  }
  DsStatus.timeInvalid() {
    _name = DsStatusValue.timeInvalid;
  }
  DsStatus.invalid() {
    _name = DsStatusValue.invalid;
  }
  ///
  DsStatus.fromString(String rawValue) {
    final parsedValue = int.tryParse(rawValue);
    if (parsedValue != null) {
      final value = parsedValue;
      if (value == DsStatusValue.ok.value) {
        _name = DsStatusValue.ok;
      } else if (value == DsStatusValue.obsolete.value) {
        _name = DsStatusValue.obsolete;
      } else if (value == DsStatusValue.timeInvalid.value) {
        _name = DsStatusValue.timeInvalid;
      } else if (value == DsStatusValue.invalid.value) {
        _name = DsStatusValue.invalid;
      } else {
        throw Failure.connection(
          message: 'Ошибка в методе $runtimeType.fromString: неизвестный статус "$value"',
          stackTrace: StackTrace.current,
        );
      }
    } else {
      throw Failure.connection(
        message: 'Ошибка в методе $runtimeType.fromString: int.parse.error значение: "$rawValue"',
        stackTrace: StackTrace.current,
      );
    }
  }
  ///
  DsStatusValue get name => _name;
  ///
  @override
  String toString() {
    return 'DsStatus {name: $_name}';
  }
  ///
  @override
  int get hashCode => super.hashCode;
  ///
  @override
  bool operator ==(Object other) =>
    other is DsStatus &&
    other.runtimeType == runtimeType &&
    other.name == name;
  }
