import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/core/result/result.dart';

class S7Point {
  static const _debug = true;
  late String _name;
  late String _type;
  late int _offset;
  late int? _bit;
  late int? _threshold;
  late int? _h;
  late int? _a;
  late int? _v;
  late String? _comment;
  ///
  S7Point({
    required String name, 
    required String type,
    required int offset,
    required int? bit,
    required int? threshold,
    required int? h,
    required int? a,
    required int? v,
    required String? comment,
  }) : 
    _name = name,
    _type = type,
    _offset = offset,
    _bit = bit,
    _threshold = threshold,
    _h = h,
    _a = a,
    _v = v,
    _comment = comment;
  ///
  S7Point.fromMap(String name, Map config) : _name = name {
    log(_debug, '[$S7Point.fromMap] $name: ', config);
    _type = config['type'];
    _offset = config['offset'];
    _bit = config['bit'];
    _threshold = config['threshold'];
    _h = config['h'];
    _a = config['a'];
    _v = config['v'];
    _comment = config['comment'];
  }
  ///
  @override
  bool operator ==(Object other) =>
    other is S7Point 
    // && other.runtimeType == runtimeType
    && other.v == _v
    && other.name == _name
    && other.type == _type
    && other.offset == _offset
    && other.bit == _bit
    && other.threshold == _threshold
    && other.h == _h
    && other.a == _a
    && other.comment == _comment;
  ///
  String get name => _name;
  String get type => _type;
  int get offset => _offset;
  int? get bit => _bit;
  /// if [threshold] > 0 then smoothing activated with given factor
  int? get threshold => _threshold;
  /// if [h] > 0 then history activated
  int? get h => _h;
  /// Alarm class
  int? get a => _a;
  /// If true then tag is virtual, not present in the controller
  int? get v => _v;
  String? get comment => _comment;
  ///
  void setName(String value) {
    _name = value;
  }
  ///
  void setType(String value) {
    _type = value;
  }
  ///
  Result<int> setOffset(String? value) {
    final result = _parseInt(value);
    if (result.hasData) {
      _offset = result.data!;
    }
    return result;
  }
  ///
  Result<int> setBit(String? value) {
    final result = _parseInt(value);
    _bit = result.data;
    return result;
  }
  ///
  Result<int> setThreshold(String? value) {
    final result = _parseInt(value);
    _threshold = result.data;
    return result;
  }
  ///
  Result<int> setH(String? value) {
    final result = _parseInt(value);
    _h = result.data;
    return result;
  }
  ///
  Result<int> setA(String? value) {
    final result = _parseInt(value);
    _a = result.data;
    return result;
  }
  ///
  Result<int> setV(String value) {
    final result = _parseInt(value);
    _v = result.data;
    return result;
  }
  ///
  void setComment(String? value) {
    _comment = value;
  }
  ///
  Result<int> _parseInt(String? value, {int? defaultValue = null}) {
    final intValue = int.tryParse('$value');
    if (intValue != null) {
      return Result<int>(
        data: intValue,
      );
    } else {
      return Result<int>(
        data: defaultValue,
        error: Failure.convertion(
          message: 'Ошибка в методе $runtimeType._parseInt недопустимое значении "$value"', 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
  ///
  @override
  String toString() {
    return 'name: $_name:\n\tv: $_v; type: $_type; offset: $_offset; bit: $_bit; threshold: $_threshold; h: $_h; a: $_a; comment: $_comment';
  }
}