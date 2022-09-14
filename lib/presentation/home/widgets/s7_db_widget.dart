import 'dart:convert';
import 'dart:io';

import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
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
                      _newConfigPath = path;
                      if (path != null) {
                        final file = File(path);
                        String pointName = '';
                        bool isPoint = false;
                        file.readAsLines().then((list) {
                          bool _isDataLine(List<String> lineItems) {
                            return lineItems.length > 1 && double.tryParse(lineItems[2]) is double;
                          }
                          bool _isStruct(List<String> lineItems) {
                            return lineItems[1].toLowerCase() == 'struct';
                          }
                          return list.asMap().map<String, List<String>>((key, line) {
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
                                final point = MapEntry('$pointName.${lineItems[0]}', lineItems);
                                isPoint = true;
                                return point;
                              }
                            }
                            return MapEntry(UniqueKey().toString(), []);
                          });
                        }).then((points) {
                          points.map((key, value) {
                            if (value.isNotEmpty) log(_debug, '$key: ', value);
                            return MapEntry(key, value);
                          },);
                        });
                      }
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
}
