import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/core/result/result.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
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
                      _readCsvFile(context, path)
                      .then((points) {
                        setState(() {
                          _newPoints = points;
                        });
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
  bool _isDataLine(List<String> lineItems) {
    return lineItems.length > 1 && double.tryParse(lineItems[2]) is double;
  }
  bool _isStruct(List<String> lineItems) {
    return lineItems[1].toLowerCase() == 'struct';
  }
  ///
  Result<Map<String, int>> _buildHeader(BuildContext context, List<String> headerLine, List<String> lines) {
    final headerLineReduced = headerLine.where((value) {
      return value != 'bit' && value != 'threshold' && value != 'comment' && value != 'h' && value != 'a';
    });
    final hLine = lines.firstWhere(
      (line) {
        if (line.isNotEmpty) {
          // log(_debug, 'headLine element: ', line);
          final items = line.split(';').map((e) => e.toLowerCase()).toList();
          // log(_debug, 'headLine items: ', items);
          // log(_debug, 'headLine items: ', ['name', 'datatype', 'offset', 'comment', 'h', 'a']);
          if (items.length > 1) {
            return headerLineReduced.every((element) {
              final test = items.contains(element);
              if (test) log(_debug, '[_buildHeader] item: $element test: ', test);
              return test;
            });
          }
        }
        return false;
      },
      orElse: () => '',
    ).split(';');
    // hLine.removeWhere((element) => element.isEmpty);
    log(_debug, '[_buildHeader] headLine: ', hLine);
    if (hLine.length > 1) {
      log(_debug, '[_buildHeader] hLine ok');
      final Map<String, int> header = {};
      hLine.asMap().forEach((key, value) {
        // log(_debug, '[_buildHeader] headLine error');
        if (value.isNotEmpty) {
          header[value.toLowerCase()] = key;
        }
      });
      return Result(
        data: header,
      );
    }
    final message = 'The file you trying to import is incorrect';
    FlushbarHelper.createError(
      duration: AppUiSettings.flushBarDurationMedium,
      message: message,
    ).show(context);
    log(_debug, '[_buildHeader] hLine error');
    return Result(
      error: Failure.unexpected(message: message, stackTrace: StackTrace.current)
    );
  }
  ///
  Future<Map<String, S7Point>> _readCsvFile(BuildContext context, String? path) async {
    if (!_isReading) {
      _isReading = true;
      if (path != null) {
        final file = File(path);
        String pointName = '';
        bool isPoint = false;
        return file.readAsLines().then((lines) {
          return lines.asMap().map<String, S7Point?>((key, line) {
            final lineItems = line.split(RegExp(r'[:,;]'));
            log(_debug, 'line items: ', lineItems);
            if (_isDataLine(lineItems)) {
              if (_isStruct(lineItems)) {
                if (isPoint) {
                  final pointNameList = pointName.split('.');
                  pointNameList.removeLast();
                  pointName = pointNameList.join('.') + '.';
                  isPoint = false;
                }
                pointName += '${lineItems[0]}.';
              } else {
                final point = MapEntry(
                  '$pointName${lineItems[0]}',
                  // S7Point.fromMap('$pointName${lineItems[0]}', {
                  //   "type": lineItems[header['datatype']!],
                  //   "offset": lineItems[header['offset']!],
                  //   if (header['bit'] != null) "bit": lineItems[header['bit']!],
                  //   if (header['threshold'] != null) "threshold": lineItems[header['threshold']!],
                  //   if (header['h'] != null) "h": lineItems[header['h']!],
                  //   if (header['a'] != null) "a": lineItems[header['a']!],
                  //   if (header['comment'] != null) "comment": lineItems[header['comment']!],
                  // }),
                  S7Point.fromList('$pointName${lineItems[0]}', [
                    lineItems[header['name']!], 
                    lineItems[header['datatype']!], 
                    lineItems[header['offset']!],
                    header['bit'] != null ? lineItems[header['bit']!] : '',
                    header['threshold'] != null ? lineItems[header['threshold']!] : '',
                    header['h'] != null ? lineItems[header['h']!] : '',
                    header['a'] != null ? lineItems[header['a']!] : '',
                    header['comment'] != null ? lineItems[header['comment']!] : '',
                  ]),
                );
                isPoint = true;
                return point;
              }
            }
            return MapEntry(UniqueKey().toString(), null);
          });
        }).then((points) {
          final newPoints = Map<String, S7Point>();
          points.forEach((key, value) {
            if (value != null) {
              log(_debug, '$key: ', value);
              newPoints.putIfAbsent(key, () => value);
            }
          },);
          return newPoints;
        }).whenComplete(() => _isReading = false);
      }
    }
    return Future.value(Map<String, S7Point>());
  }
}
