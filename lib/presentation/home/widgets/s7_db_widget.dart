import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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
                    allowedExtensions: ['csv', 'txt'],
                    onComplete: (path) {
                      _readCsvFile(context, path);
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
              points: db.points.values.toList(),
              newPoints: newDb?.points.values.toList(),
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
  bool _findHeaderLine(BuildContext context, List<String> headerLine, List<String> lines) {
    final hLine = lines.firstWhere(
      (line) {
        if (line.isNotEmpty) {
          // log(_debug, 'headLine element: ', line);
          final items = line.split(';').map((e) => e.toLowerCase()).toList();
          // log(_debug, 'headLine items: ', items);
          // log(_debug, 'headLine items: ', ['name', 'datatype', 'offset', 'comment', 'h', 'a']);
          if (items.length > 1) {
            return headerLine.every((element) {
              final test = items.contains(element);
              if (test) log(_debug, '[_findHeaderLine] item: $element test: ', test);
              return test;
            });
          }
        }
        return false;
      },
      orElse: () => '',
    ).split(';');
    log(_debug, '[_findHeaderLine] headLine: ', hLine);
    if (hLine.length > 1) {
      log(_debug, '[_findHeaderLine] headLine ok');
      return true;
    }
    FlushbarHelper.createError(
      duration: AppUiSettings.flushBarDurationMedium,
      message: 'The file you trying to import is incorrect',
    ).show(context);
    log(_debug, '[_findHeaderLine] headLine error');
    return false;
  }
  ///
  void _readCsvFile(BuildContext context, String? path) async {
    if (!_isReading) {
      _isReading = true;
      if (path != null) {
        final file = File(path);
        String pointName = '';
        bool isPoint = false;
        Map<String, int> header = {};
        file.readAsLines().then((lines) {
          final headerLine = ['name', 'datatype', 'offset', 'bit', 'threshHold', 'comment', 'h', 'a'];
          if (!_findHeaderLine(context, headerLine, lines)) {
            return Map<String, S7Point>();
          }
          header = headerLine.asMap().map((key, value) {
            log(_debug, '[_readCsvFile] headLine error');
            return MapEntry(value, key);
          });
          log(_debug, '[_readCsvFile] headLine ok');
          log(_debug, 'header: ', header);
          return lines.asMap().map<String, S7Point?>((key, line) {
            final lineItems = line.split(';');
            lineItems.removeWhere((item) => item.isEmpty);
            log(_debug, 'line items: ', lineItems);
            if (_isDataLine(lineItems)) {
              if (_isStruct(lineItems)) {
                if (isPoint) {
                  pointName = '';
                  isPoint = false;
                }
                pointName += '${lineItems[0]}.';
              } else {
                final point = MapEntry(
                  '$pointName${lineItems[0]}',
                  S7Point.fromList('$pointName${lineItems[0]}', [
                    lineItems[header['name']!], 
                    lineItems[header['datatype']!], 
                    lineItems[header['offset']!],
                    lineItems[header['bit']!],
                    lineItems[header['threshHold']!],
                    lineItems[header['h']!],
                    lineItems[header['a']!],
                    lineItems[header['comment']!],
                  ]),
                );
                isPoint = true;
                return point;
              }
            }
            return MapEntry(UniqueKey().toString(), null);
          });
        }).then((points) {
          points.map((key, value) {
            if (value != null) log(_debug, '$key: ', value);
            return MapEntry(
              key, 
              value,
            );
          },);
        }).whenComplete(() => _isReading = false);
      }
    }
  }
}
