import 'package:configure_cma/domain/core/entities/s7_ied.dart';
import 'package:configure_cma/domain/core/log/log.dart';

class S7Line {
  static const _debug = true;
  final String _name;
  late Map<String, S7Ied> _ieds;
  S7Line(String name, Map<String, dynamic> config) : _name = name{
    log(_debug, '[S7Line] ', name);
    // log(_debug, '\n[S7Line] config: ', config);
    _ieds = config.map<String, S7Ied>((key, value) {
      return MapEntry<String, S7Ied>(
        key, 
        S7Ied(key, value as Map<String, dynamic>),
      );
    });
  }
  String get name => _name;
  Map<String, S7Ied> get ieds => _ieds;
}
