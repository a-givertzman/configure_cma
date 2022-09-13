import 'package:configure_cma/domain/core/log/log.dart';

class S7Point {
  static const _debug = true;
  final String _name;
  late String _type;
  late int _offset;
  late int? _bit;
  late int? _threshHold;
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
    _threshHold = threshHold,
    _h = h,
    _a = a,
    _comment = comment;
  ///
  S7Point.fromMap(String name, Map config) : _name = name {
    log(_debug, '[S7Point] $name: ', config);
    _type = config['type'];
    _offset = config['offset'];
    _bit = config['bit'];
    _threshHold = config['threshHold'];
    _h = config['h'];
    _a = config['a'];
    _comment = config['comment'];
  }
  String get name => _name;
  String get type => _type;
  int get offset => _offset;
  int? get bit => _bit;
  int? get threshHold => _threshHold;
  int? get h => _h;
  int? get a => _a;
  String? get comment => _comment;
}