import 'package:configure_cma/domain/core/log/log.dart';

class S7PointFr {
  static const _debug = true;
  late List<int>? _act = null;
  late int? _nomConst = null;
  late String? _nomTag = null;
  ///
  S7PointFr({
    List<int>? act,
    int? nomConst,
    String? nomTag,
  }) : 
    _act = act,
    _nomConst = nomConst,
    _nomTag = nomTag;
  ///
  S7PointFr.fromMap(Map? config) {
    if (config != null) {
      log(_debug, '[$S7PointFr.fromMap] fr config: ', config);
      _act = (config['act'] as List<dynamic>?)?.map((e) => int.parse('$e')).toList();
      final nom = config['nom'];
      if (nom != null) {
        log(_debug, '[$S7PointFr.fromMap] fr nom: ', nom);
        if (nom is int) {
          log(_debug, '[$S7PointFr.fromMap] fr nom is int: ', nom);
          _nomConst = nom;
        } else if (nom is String) {
          log(_debug, '[$S7PointFr.fromMap] fr nom: is String ', nom);
          _nomTag = nom;
        } else {
          log(_debug, '[$S7PointFr.fromMap] Uncnown type of nom: ', nom);
        }
      }
    }
  }
  ///
  bool get isEmpty {
    return _act == null && _nomConst == null && (_nomTag == null || (_nomTag != null && _nomTag!.isEmpty));
  }
  ///
  bool get isNotEmpty => !isEmpty;
  ///
  Map<String, dynamic> toJson() {
    log(_debug, '[$S7PointFr.toJson] _act: ', _act);
    log(_debug, '[$S7PointFr.toJson] _nomConst: ', _nomConst);
    log(_debug, '[$S7PointFr.toJson] _nomTag: ', _nomTag);
    final result = {
      if (_act != null) 'act': _act,
      if (_nomConst != null) 'nom': _nomConst,
      if (_nomTag != null && _nomTag!.isNotEmpty) 'nom': _nomTag,
    };
    log(_debug, '[$S7PointFr.toJson] fr: ', result);
    return result;
  }
  ///
  @override
  bool operator ==(Object other) =>
    other is S7PointFr 
    // && other.runtimeType == runtimeType
    && other.act == _act
    && other._nomConst == _nomConst
    && other.nomTag == _nomTag;
  ///
  List<int>? get act => _act;
  int? get nomConst => _nomConst;
  String? get nomTag => _nomTag;
  ///
  // void update(S7PointFr? newPoint) {
  //   if (newPoint != null) {
  //     if (_type != newPoint.type) {
  //       _typeOld = '$_type';
  //       _type = '${newPoint.type}';
  //       _typeIsUpdated = true;
  //     }
  //     if (_offset != newPoint.offset) {
  //       _offsetOld = _offset;
  //       _offset = newPoint.offset;
  //       _offsetIsUpdated = true;
  //     }
  //     if (_bit != newPoint.bit) {
  //       _bitOld = _bit;
  //       _bit = newPoint.bit;
  //       _bitIsUpdated = true;
  //     }
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
  //     if (_comment != newPoint.comment) {
  //       _commentOld = '$_comment';
  //       _comment = '${newPoint.comment}';
  //       _commentIsUpdated = true;
  //     }
  //   }
  // }
  ///
  void setAct(String value) {
    _act = value.split(',').map((vStr) => int.parse(vStr)).toList();
  }
  ///
  void setNomConst(int value) {
    _nomConst = value;
  }
  ///
  void setNomTag(String value) {
    _nomTag = value;
  }
  ///
  @override
  String toString() {
    if (_act != null) {
      return 'act: $_act';
    } else if (_nomConst != null) {
      return 'nom: $_nomConst';
    } else if (_nomTag != null) {
      return 'nom: $_nomTag';
    }
    return '';
  }
}