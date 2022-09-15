import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/core/result/result.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/parse_config_db.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class S7DbWidget extends StatefulWidget {
  final List<S7Db> _dbs;
  ///
  S7DbWidget({
    Key? key,
    required List<S7Db> dbs,
    // List<S7Db>? newDbs,
  }) : 
    _dbs = dbs,
    // _newDbs = newDbs,
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
              flex: {'name': 15, 'type': 3, 'offset': 2, 'bit': 2, 'threshold': 2, 'h': 2, 'a': 2, 'comment': 10},
              points: db.points.values.toList(),
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
      }
    }
    return Result(
      error: Failure.convertion(message: 'Not ready', 
      stackTrace: StackTrace.current),
    );
  }
}
