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
  Map<String, dynamic> toJson() {
    return _ieds.map((iedKey, ied) {
      return MapEntry(
        iedKey, 
        {
          "description": ied.description,
          "ip": ied.ip,
          "rack": ied.rack,
          "slot": ied.slot,
          "db": ied.dbs.map((dbKey, db) {
            return MapEntry(
              dbKey, 
              {
                "description": db.description,
                "number": db.number,
                "offset": db.offset,
                "size": db.size,
                "delay": db.delay,
                "data": db.points.map((pointKey, point) {
                  return MapEntry(
                    pointKey, 
                    {
                      "type": point.type,
                      "offset": point.offset,
                      if (point.bit != null) "bit": point.bit,
                      if (point.threshold != null) "threshHold": point.threshold,
                      if (point.h != null) "h": point.h,
                      if (point.a != null) "a": point.a,
                      if (point.v != null) "v": point.v,
                      if (point.comment != null) "comment": point.comment,
                    }
                  );
                }),
              }
            );
          }),
        },
      );
    });
  }
}
