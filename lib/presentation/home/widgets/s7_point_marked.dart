import 'package:configure_cma/domain/core/entities/s7_point.dart';

///
class S7PointMarked extends S7Point {
  bool _isNew;
  bool _isDeleted;
  S7PointMarked(
    S7Point point, {
    bool isNew = false,
    bool isDeleted = false,
  }) :
    _isNew = isNew,
    _isDeleted = isDeleted,
    super(
      v: point.v,
      name: point.name, 
      type: point.type, 
      offset: point.offset, 
      bit: point.bit, 
      threshold: point.threshold, 
      h: point.h, 
      a: point.a, 
      comment: point.comment,
    );
  bool get isNew => _isNew;
  bool get isDeleted => _isDeleted;
  ///
  void setIsNew({bool value = true}) {
    _isNew = value;
  }
  ///
  void setIsDeleted({bool value = true}) {
    _isDeleted = value;
  }
  @override
  String toString() {
    return super.toString() + '; isNew: $_isNew; _isDeleted: $_isDeleted';
  }
}
