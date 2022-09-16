import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_marked.dart';

class S7Db {
  static const _debug = true;
  final String _name;
  late String? _description;
  late int _number;
  late int _offset;
  late int _size;
  late int _delay;
  late Map<String, S7PointMarked> _points;
  ///
  S7Db({
    required String name, 
    required String? description,
    required int number,
    required int offset,
    required int size,
    required int delay,
  }) : 
    _name = name,
    _description = description,
    _number = number,
    _offset = offset,
    _size = size,
    _delay = delay;
  ///
  S7Db.fromMap(String name, Map<String, dynamic> config) : _name = name {
    log(_debug, '[S7Line] ', name);
    // log(_debug, '\n[S7Db] config: ', config);
    _description = config['description'];
    _number = config['number'];
    _offset = config['offset'];
    _size = config['size'];
    _delay = config['delay'];
    _points = config['data'].map<String, S7PointMarked>((key, value) {
      return MapEntry<String, S7PointMarked>(
        key, 
        S7PointMarked(S7Point.fromMap(key, value as Map)),
      );
    });
  }
  ///
  S7Db.fromList(String name, List<String> list) : _name = name {
    log(_debug, '[S7Line] ', name);
    // log(_debug, '\n[S7Db] config: ', list);
    _description = list[0];
    _number = int.parse(list[1]);
    _offset = int.parse(list[2]);
    _size = int.parse(list[3]);
    _delay = int.parse(list[4]);
    // _points = list[5].map<String, S7Point>((key, value) {
    //   return MapEntry<String, S7Point>(
    //     key, 
    //     S7Point.fromMap(key, value as Map),
    //   );
    // });
  }
  String get name => _name;
  String? get description => _description;
  int get number => _number;
  int get offset => _offset;
  int get size => _size;
  int get delay => _delay;
  Map<String, S7PointMarked> get points => _points;
  ///
  void newPoint() {
    final point =  S7PointMarked(
      S7Point(
        name: 'new',
        type: 'Int',
        offset: 0,
      ),
    );
    _points.addAll({
      "new": point,
    });
  }
}
