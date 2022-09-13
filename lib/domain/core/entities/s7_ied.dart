import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/domain/core/log/log.dart';

class S7Ied {
  static const _debug = true;
  final String _name;
  late String _description;
  late String _ip;
  late int _rack;
  late int _slot;
  late Map<String, S7Db> _dbs;
  S7Ied(String name, Map<String, dynamic> config) : _name = name {
    log(_debug, '[S7Line] ', name);
    // log(_debug, '\n[S7Ied] config: ', config);
    _description = config['description'] ?? '-';
    _ip = config['ip'];
    _rack = config['rack'];
    _slot = config['slot'];
    _dbs = config['db'].map<String, S7Db>((key, value) {
      return MapEntry<String, S7Db>(
        key, 
        S7Db(key, value as Map<String, dynamic>),
      );
    });
  }
  String get name => _name;
  String get description => _description;
  String get ip => _ip;
  int get rack => _rack;
  int get slot => _slot;
  Map<String, S7Db> get dbs => _dbs;
}
