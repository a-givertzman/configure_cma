import 'package:configure_cma/domain/core/error/failure.dart';

class DsDataType {
  final String name;
  final int length;
  const DsDataType.struct() :
    name = 'Struct',
    length = 0;
  const DsDataType.bool() :
    name = 'Bool',
    length = 2;
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
    if (lvalue == 'struct') {
      return {'name': DsDataType.struct().name, 'length': DsDataType.struct().length,};
    } else if (lvalue == 'bool') {
      return {'name': DsDataType.bool().name, 'length': DsDataType.bool().length,};
    } else if (lvalue == 'int') {
      return {'name': DsDataType.int().name, 'length': DsDataType.int().length,};
    } else if (lvalue == 'uint') {
      return {'name': DsDataType.uInt().name, 'length': DsDataType.uInt().length,};
    } else if (lvalue == 'dint') {
      return {'name': DsDataType.dInt().name, 'length': DsDataType.dInt().length,};
    } else if (lvalue == 'word') {
      return {'name': DsDataType.word().name, 'length': DsDataType.word().length,};
    } else if (lvalue == 'lint') {
      return {'name': DsDataType.lInt().name, 'length': DsDataType.lInt().length,};
    } else if (lvalue == 'real') {
      return {'name': DsDataType.real().name, 'length': DsDataType.real().length,};
    } else if (lvalue == 'time') {
      return {'name': DsDataType.time().name, 'length': DsDataType.time().length,};
    } else if (lvalue == 'date_and_time') {
      return {'name': DsDataType.dateAndTime().name, 'length': DsDataType.dateAndTime().length,};
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
