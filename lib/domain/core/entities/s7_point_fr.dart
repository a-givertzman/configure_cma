import 'package:configure_cma/domain/core/log/log.dart';

class S7PointFr {
  static const _debug = true;
  late List<int>? _act = null;
  late String? _nom = null;
  ///
  S7PointFr({
    List<int>? act,
    String? nom,
  }) : 
    _act = act,
    _nom = nom;
  ///
  S7PointFr.fromMap(Map? config) {
    if (config != null) {
      log(_debug, '[$S7PointFr.fromMap] fr config: ', config);
      _act = (config['act'] as List<dynamic>?)?.map((e) => int.parse('$e')).toList();
      _nom = '${config['nom']}';
    }
  }
  ///
  @override
  bool operator ==(Object other) =>
    other is S7PointFr 
    // && other.runtimeType == runtimeType
    && other.act == _act
    && other.nom == _nom;
  ///
  List<int>? get act => _act;
  String? get nom => _nom;
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
  void setNom(String value) {
    _nom = value;
  }
  ///
  @override
  String toString() {
    if (_act != null) {
      return 'act: $_act';
    } else if (_nom != null) {
      return 'nom: $_nom';
    }
    return '';
  }
}