import 'dart:io';

import 'package:configure_cma/domain/core/entities/ds_data_type.dart';
import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/core/result/result.dart';
import 'package:configure_cma/presentation/home/widgets/parse_config_db.dart';
import 'package:configure_cma/domain/core/entities/s7_point_marked.dart';

class S7Db {
  static const _debug = true;
  final String _name;
  late String? _description;
  late int _number;
  late int _offset;
  late int _size;
  late int _delay;
  late Map<String, S7PointMarked> _points;
  late Map<String, S7Point>? _newPoints = null;
  bool _isReading = false;
  late int? _sizeOld;
  bool _sizeIsUpdated = false;

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
    updateDbSize();
    validateOffset();
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
    updateDbSize();
    validateOffset();
  }
  String get name => _name;
  String? get description => _description;
  int get number => _number;
  int get offset => _offset;
  int get size => _size;
  int get delay => _delay;
  Map<String, S7PointMarked> get points => _points;
  Map<String, S7Point>? get newPoints => _newPoints;
  int? get sizeOld => _sizeOld;
  bool get sizeIsUpdated => _sizeIsUpdated;
  ///
  void clearNewPoints() {
    _newPoints = null;
    updateDbSize();
  }
  ///
  bool _isDeleted(String? key, Map<String, S7Point>? newPoints) {
    if (newPoints == null) {
      return false;
    } else if (newPoints.isEmpty) {
      return true;
    } else {
      if (!newPoints.containsKey(key)) log(_debug, '[_S7PointWidgetState._isDeleted] deleted: ', key);
      return !newPoints.containsKey(key);
    }
  }
  ///
  bool _isNew(String? key, Map<String, S7Point> points) {
    if (!points.keys.contains(key)) log(_debug, '[_S7PointWidgetState._buildPointList] NEW: ', key);
    return ! points.keys.contains(key);
  }
  ///
  /// Сравнивает тэги конфигурации сервера с тэгами импортированными из DB-блока контроллера
  /// проставляет атрибутф new, deleted и отмечает все изменившиеся значения каждого тэга
  void comparePoints() {
    final newPoints = _newPoints;
    if (newPoints != null) {
      newPoints.forEach((key, value) {
        // log(_debug, '[S7Db.comparePoints] check for new: $key: ', value);
        if (_isNew(newPoints[key]?.name, _points)) {
          _points[key] = S7PointMarked(value, isNew: true);
        }
      });

      _points.forEach((key, point) {
        if (_isDeleted(point.name, newPoints)) {
          point.setIsDeleted();
        } else {
          point.update(newPoints[point.name]);
        }
      });
    }
  }
  ///
  Future<Result<bool>> updateFromDbFile(String? path) async {
    if (!_isReading) {
      _isReading = true;
      if (path != null) {
        final file = File(path);
        return file.readAsLines().then((lines) {
          _isReading = false;
          _newPoints = ParseConfigDb(
            lines: lines,
            offset: ParseOffset(),
          )
          .parse()
          .map<String, S7Point>((key, value) {
            return MapEntry<String, S7Point>(
              key, 
              S7Point.fromMap(key, value as Map),
            );
          });
          comparePoints();
          updateDbSize();
          return Result(data: true);
        });
      } else {
        return Result(
          error: Failure.convertion(message: '[$S7Db._readDbFile] path can\'t bee null', 
          stackTrace: StackTrace.current),
        );
      }
    } else {
      return Result(
        error: Failure.convertion(message: '[$S7Db._readDbFile] Not ready', 
        stackTrace: StackTrace.current),
      );
    }
  }
  ///
  /// Добавляет новый тэг в блок
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
  ///
  /// Обновляет размер DB-блока
  /// Вызвать данный метод при изменении количества тэгов или адресации
  void updateDbSize() {
    final lastPoint = _points.values.reduce((lastPoint, point) {
      if (point.offset > lastPoint.offset) {
        return point;
      }
      return lastPoint;
    },);
    final newSize = lastPoint.offset + DsDataType.fromString(lastPoint.type).length;
    if (_size != newSize) {
      _sizeIsUpdated = true;
      _sizeOld = _size;
      _size = newSize;
    }
  }
  ///
  /// Проверяет адресацию тегов с учетом их типа
  void validateOffset() {
    return;
    int offset = 0;
    int bit = 0;
    S7PointMarked? prevPoint;
    for (final entry in _points.entries) {
      final point = entry.value;
      if (point.v != null && point.v! > 0) {
      } else {
        if (prevPoint != null) {
          final length = DsDataType.fromString(prevPoint.type).length;
          if (prevPoint.type == 'Bool') {
            bit = prevPoint.bit!;
          }
          offset += length;
          if (point.offset != offset) {
            final newPoint = S7PointMarked(point);
            newPoint.setOffset("$offset");
            point.update(newPoint);
          }
        }
        prevPoint = point;
      }
    }
  }
}


///
/// Счетчик адреса для ParseConfigDb
class DbOffset {
  int _value;
  int _bit;
  bool _isBool = false;
  int _length = 0;
  ///
  DbOffset({
    int value = 0, 
    int bit = 0,
  }) : 
    _value = value,
    _bit = bit;
  ///
  add(String tagTypeName) {
    final tagType = DsDataType.fromString('$tagTypeName');
    _length = tagType.length;
    if (_isBool && tagType == DsDataType.bool()) {
      _bit++;
    } else {
      if (tagType == DsDataType.bool()) {
        _isBool = true;
      } else {
        if (_isBool) {
          _bit = 0;
          _isBool = false;
        }
      }
      _value += _length;
    }
  }
  ///
  int get value => _value - _length;
  int get bit => _bit;
}