import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_widget.dart';
import 'package:flutter/material.dart';

class S7DbWidget extends StatefulWidget {
  final List<S7Db> _dbs;
  ///
  S7DbWidget({
    Key? key,
    required List<S7Db> dbs,
  }) : 
    _dbs = dbs,
    super(key: key);
  ///
  @override
  State<S7DbWidget> createState() => _S7DbWidgetState();
}


class _S7DbWidgetState extends State<S7DbWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget._dbs.length,
      itemBuilder: ((context, index) {
          final db = widget._dbs[index];
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
                ],
              ),
              S7PointWidget(points: db.points.values.toList()),
            ],
          );
      })
    );
  }
}
