import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';

class S7Point {
  static const _debug = true;
  late String _name;
  late String _type;
  late int _offset;
  late int? _bit;
  late int? _threshold;
  late int? _h;
  late int? _a;
  late String? _comment;
  ///
  S7Point({
    required String name, 
    required String type,
    required int offset,
    required int? bit,
    required int? threshHold,
    required int? h,
    required int? a,
    required String? comment,
  }) : 
    _name = name,
    _type = type,
    _offset = offset,
    _bit = bit,
    _threshold = threshHold,
    _h = h,
    _a = a,
    _comment = comment;
  ///
  S7Point.fromMap(String name, Map config) : _name = name {
    log(_debug, '[$S7Point.fromMap] $name: ', config);
    _type = config['type'];
    _offset = config['offset'];
    _bit = config['bit'];
    _threshold = config['threshHold'];
    _h = config['h'];
    _a = config['a'];
    _comment = config['comment'];
  }
  /// from string list
  S7Point.fromList(String name, List<String> list) {
    log(_debug, '[$S7Point.fromList] $name: ', list);
    _type = list[0];
    _offset = int.tryParse(list[1]) ?? 0;
    _bit = int.tryParse(list[2]);
    _threshold = int.tryParse(list[3]);
    _h = int.tryParse(list[4]);
    _a = int.tryParse(list[5]);
    _comment = list[6];    
  }
  String get name => _name;
  String get type => _type;
  int get offset => _offset;
  int? get bit => _bit;
  int? get threshold => _threshold;
  int? get h => _h;
  int? get a => _a;
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
  Failure? setOffset(Object? value) {
    return _parseInt(_offset, value);
  }
  ///
  Failure? setBit(Object? value) {
    return _parseInt(_bit, value);
  }
  ///
  Failure? setThreshold(Object? value) {
    return _parseInt(_threshold, value);
  }
  ///
  Failure? setH(Object? value) {
    return _parseInt(_h, value);
  }
  ///
  Failure? setA(Object? value) {
    return _parseInt(_a, value);
  }
  ///
  void setComment(String? value) {
    _comment = value;
  }
  ///
  Failure? _parseInt(int? target, Object? value) {
    final intValue = int.tryParse('$value');
    if (intValue != null) {
      target = intValue;
      return null;
    } else {
      return Failure.convertion(
        message: 'Ошибка int.tryParse в методе $runtimeType.setH на значении "$value"', 
        stackTrace: StackTrace.current,
      );
    }
  }
}