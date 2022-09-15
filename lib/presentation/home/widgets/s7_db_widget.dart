import 'dart:io';

import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/result/result.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/parse_config_db.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
import 'package:flutter/material.dart';

class S7DbWidget extends StatefulWidget {
  final List<S7Db> _dbs;
  bool _resetNewPoints = false;
  ///
  S7DbWidget({
    Key? key,
    required List<S7Db> dbs,
    bool? resetNewPoints,
  }) : 
    _dbs = dbs,
    _resetNewPoints = resetNewPoints ?? false,
    super(key: key);
  ///
  @override
  State<S7DbWidget> createState() => _S7DbWidgetState();
}

//
class _S7DbWidgetState extends State<S7DbWidget> {
  static const _debug = true;
  String? _newConfigPath;
  List<S7Db>? _newDbs;
  Map<String, S7Point>? _newPoints;
  bool _isReading = false;
  ///
  @override
  Widget build(BuildContext context) {
    if (widget._resetNewPoints) {
      _newPoints = null;
    }
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget._dbs.length,
      itemBuilder: ((context, index) {
        final db = widget._dbs[index];
        final newDb = _newDbs?[index];
        final color = Theme.of(context).colorScheme.primary.withAlpha(50);
        const borderColor = Colors.white10;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.name,
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.description,
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.description,
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.number,
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.offset,
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.size,
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.delay,
                ),
                FittedBox(
                  child: SelectFileWidget(
                    allowedExtensions: ['db', 'txt'],
                    onComplete: (path) {
                      _readDbFile(context, path)
                      .then((result) {
                        if (result.hasData) {
                          setState(() => _newPoints = result.data);
                        }
                      });
                    },
                    icon: Tooltip(
                      child: Icon(Icons.file_download),
                      message: 'Update DB config from file',
                    ),
                  ),
                ),
              ],
            ),
            S7PointWidget(
              flex: {'v': 2, 'name': 20, 'type': 5, 'offset': 3, 'bit': 3, 'threshold': 3, 'h': 3, 'a': 3, 'comment': 15},
              points: db.points,
              newPoints: _newPoints,
            ),
          ],
        );
      })
    );
  }
  ///
  Future<Result<Map<String, S7Point>>> _readDbFile(BuildContext context, String? path) async {
    if (!_isReading) {
      _isReading = true;
      if (path != null) {
        final file = File(path);
        return file.readAsLines().then((lines) {
          _isReading = false;
          return Result(
            data: ParseConfigDb(
              lines: lines,
              offset: ParseOffset(0),
            ).parse().map<String, S7Point>((key, value) {
              return MapEntry<String, S7Point>(
                key, 
                S7Point.fromMap(key, value as Map),
              );
            }),
          );
        });
      } else {
        return Result(
          error: Failure.convertion(message: '[$S7DbWidget._readDbFile] path can\'t bee null', 
          stackTrace: StackTrace.current),
        );
      }
    } else {
      return Result(
        error: Failure.convertion(message: '[$S7DbWidget._readDbFile] Not ready', 
        stackTrace: StackTrace.current),
      );
    }
  }
}
