import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';

class S7Db {
  static const _debug = true;
  final String _name;
  late String _description;
  late int _number;
  late int _offset;
  late int _size;
  late int _delay;
  late Map<String, S7Point> _points;
  S7Db(String name, Map<String, dynamic> config) : _name = name {
    log(_debug, '[S7Line] ', name);
    // log(_debug, '\n[S7Db] config: ', config);
    _description = config['description'] ?? '-';
    _number = config['number'];
    _offset = config['offset'];
    _size = config['size'];
    _delay = config['delay'];
    _points = config['data'].map<String, S7Point>((key, value) {
      return MapEntry<String, S7Point>(
        key, 
        S7Point.fromMap(key, value as Map),
      );
    });
  }
  String get name => _name;
  String get description => _description;
  int get number => _number;
  int get offset => _offset;
  int get size => _size;
  int get delay => _delay;
  Map<String, S7Point> get points => _points;
}
