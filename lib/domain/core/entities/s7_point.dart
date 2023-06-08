import 'package:configure_cma/domain/core/entities/s7_point_fr.dart';
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
  late S7PointFr? _fr;
  late int? _v;
  late String? _comment;
  late String? _typeOld = null;
  late int? _offsetOld = null;
  late int? _bitOld = null;
  late int? _thresholdOld = null;
  late int? _hOld = null;
  late int? _aOld = null;
  late S7PointFr? _frOld = null;
  late int? _vOld = null;
  late String? _commentOld = null;
  late bool _typeIsUpdated = false;
  late bool _offsetIsUpdated = false;
  late bool _bitIsUpdated = false;
  late bool _thresholdIsUpdated = false;
  late bool _hIsUpdated = false;
  late bool _aIsUpdated = false;
  late bool _frIsUpdated = false;
  late bool _vIsUpdated = false;
  late bool _commentIsUpdated = false;
  late bool _offsetError = false;
  late bool _bitError = false;
  ///
  S7Point({
    required String name, 
    required String type,
    required int offset,
    int? bit,
    int? threshold,
    int? h,
    int? a,
    S7PointFr? fr,
    int? v,
    String? comment,
  }) : 
    _name = name,
    _type = type,
    _offset = offset,
    _bit = bit,
    _threshold = threshold,
    _h = h,
    _a = a,
    _fr = fr,
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
    _fr = S7PointFr.fromMap(config['fr']);
    if (config['fr'] != null) {
      log(_debug, '\tfr: ', config['fr']);
      log(_debug, '\t_fr: ', _fr);
    }
    _v = config['v'];
    _comment = config['comment'];
  }
  Map<String, dynamic> toMap() {
    return {
      "type": _type,
      "offset": _offset,
      if (_bit != null) "bit": _bit,
      if (_threshold != null) "threshHold": _threshold,
      if (_h != null) "h": _h,
      if (_a != null) "a": _a,
      if (_fr != null && _fr!.isNotEmpty) "fr": _fr?.toJson(),
      if (_v != null) "v": _v,
      if (_comment != null) "comment": _comment,
    };
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
    && other.fr == _fr
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
  /// Fault registrator
  S7PointFr? get fr => _fr;
  /// If true then tag is virtual, not present in the controller
  int? get v => _v;
  String? get comment => _comment;
  String? get typeOld => _typeOld;
  int? get offsetOld => _offsetOld;
  int? get bitOld => _bitOld;
  int? get thresholdOld => _thresholdOld;
  int? get hOld => _hOld;
  int? get aOld => _aOld;
  S7PointFr? get frOld => _frOld;
  int? get vOld => _vOld;
  String? get commentOld => _commentOld;
  bool get typeIsUpdated => _typeIsUpdated;
  bool get offsetIsUpdated => _offsetIsUpdated;
  bool get bitIsUpdated => _bitIsUpdated;
  bool get thresholdIsUpdated => _thresholdIsUpdated;
  bool get hIsUpdated => _hIsUpdated;
  bool get aIsUpdated => _aIsUpdated;
  bool get frIsUpdated => _frIsUpdated;
  bool get vIsUpdated => _vIsUpdated;
  bool get commentIsUpdated => _commentIsUpdated;
  bool get offsetError => _offsetError;
  bool get bitError => _bitError;
  ///
  void update(S7Point? newPoint) {
    if (newPoint != null) {
      if (_type != newPoint.type) {
        _typeOld = '$_type';
        _type = '${newPoint.type}';
        _typeIsUpdated = true;
      }
      if (_offset != newPoint.offset) {
        _offsetOld = _offset;
        _offset = newPoint.offset;
        _offsetIsUpdated = true;
      }
      if (_bit != newPoint.bit) {
        _bitOld = _bit;
        _bit = newPoint.bit;
        _bitIsUpdated = true;
      }
      if (_bitError != newPoint.bitError) {
        _bitError = newPoint.bitError;
      }
      if (_offsetError != newPoint.offsetError) {
        _offsetError = newPoint.offsetError;
      }

      // if (_threshold != newPoint.threshold) {
      //   _thresholdOld = _threshold;
      //   _threshold = newPoint.threshold;
      //   _thresholdIsUpdated = true;
      // }
      // if (_h != newPoint.h) {
      //   _hOld = _h;
      //   _h = newPoint.h;
      //   _hIsUpdated = true;
      // }
      // if (_a != newPoint.a) {
      //   _aOld = _a;
      //   _a = newPoint.a;
      //   _aIsUpdated = true;
      // }
      // if (_v != newPoint.v) {
      //   _vOld = _v;
      //   _v = newPoint.v;
      //   _vIsUpdated = true;
      // }
      if (_comment != newPoint.comment) {
        _commentOld = '$_comment';
        _comment = '${newPoint.comment}';
        _commentIsUpdated = true;
      }
    }
  }
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
    if (value != null && value.isNotEmpty) {
      final result = _parseInt(value);
      _bit = result.data;
      return result;
    } else {
      _bit = null;
      return Result<int>(data: 0);
    }
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
  void setFr(S7PointFr? value) {
    _fr = value;
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
  void setOffsetError(bool error) {
    _offsetError = error;
  }
  ///
  void setBitError(bool error) {
    _bitError = error;
  }
  ///
  @override
  String toString() {
    return 'name: $_name:\n\tv: $_v; type: $_type; offset: $_offset; bit: $_bit; threshold: $_threshold; h: $_h; a: $_a; fr: $_fr;\n\tcomment: $_comment';
  }
}