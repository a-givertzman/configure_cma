import 'package:configure_cma/domain/core/error/failure.dart';

class DsDataType {
  final String name;
  final int length;
  const DsDataType.bool() :
    name = 'Bool',
    length = 1;
  const DsDataType.int() :
    name = 'Int',
    length = 2;
  const DsDataType.uInt() :
    name = 'UInt',
    length = 2;
  const DsDataType.dInt() :
    name = 'DInt',
    length = 4;
  const DsDataType.word() :
    name = 'Word',
    length = 2;
  const DsDataType.lInt() :
    name = 'LInt',
    length = 8;
  const DsDataType.real() :
    name = 'Real',
    length = 4;
  const DsDataType.time() :
    name = 'Time',
    length = 4;
  const DsDataType.dateAndTime() :
    name = 'Date_And_Time',
    length = 8;
  ///
  DsDataType.fromString(String value) :
    name = _extract(value)['name'] as String,
    length = _extract(value)['length'] as int;
  ///
  ///
  static Map<String, dynamic> _extract(String value) {
    final lvalue = value.toLowerCase();
    if (lvalue == 'bool') {
      return {'name': 'Bool',
      'length': 1,};
    } else if (lvalue == 'int') {
      return {'name': 'Int',
      'length': 2,};
    } else if (lvalue == 'uint') {
      return {'name': 'UInt',
      'length': 2,};
    } else if (lvalue == 'dint') {
      return {'name': 'DInt',
      'length': 4,};
    } else if (lvalue == 'word') {
      return {'name': 'Word',
      'length': 2,};
    } else if (lvalue == 'lint') {
      return {'name': 'LInt',
      'length': 8,};
    } else if (lvalue == 'real') {
      return {'name': 'Real',
      'length': 4,};
    } else if (lvalue == 'time') {
      return {'name': 'Time',
      'length': 4,};
    } else if (lvalue == 'date_and_time') {
      return {'name': 'Date_And_Time',
      'length': 8,};
    } else {
      throw Failure.connection(
        message: 'Ошибка в методе $DsDataType._extract: неизвестный тип данных $value',
        stackTrace: StackTrace.current,
      );
    }
  }
  @override
  String toString() {
    return 'DsDataType {name: $name, length: $length}';
  }
  ///
  @override
  int get hashCode => super.hashCode;
  ///
  @override
  bool operator ==(Object other) =>
    other is DsDataType &&
    other.runtimeType == runtimeType &&
    other.name == name &&
    other.length == length;
}
