import 'package:configure_cma/domain/core/entities/s7_ied.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_db_widget.dart';
import 'package:flutter/material.dart';

class S7IedWidget extends StatefulWidget {
  final List<S7Ied> _ieds;
  ///
  S7IedWidget({
    Key? key,
    required List<S7Ied> ieds,
  }) : 
    _ieds = ieds,
    super(key: key);
  ///
  @override
  State<S7IedWidget> createState() => _S7IedWidgetState();
}


class _S7IedWidgetState extends State<S7IedWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget._ieds.length,
      itemBuilder: ((context, index) {
          final ied = widget._ieds[index];
          final color = Theme.of(context).colorScheme.primary.withAlpha(70);
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
                    data: ied.name,
                  ),
                  CellWidget(
                    flex: 5,
                    color: color,
                    borderColor: borderColor,
                    data: ied.description,
                  ),
                  CellWidget(
                    flex: 5,
                    color: color,
                    borderColor: borderColor,
                    data: ied.ip,
                  ),
                  CellWidget(
                    flex: 5,
                    color: color,
                    borderColor: borderColor,
                    data: ied.rack,
                  ),
                  CellWidget(
                    flex: 5,
                    color: color,
                    borderColor: borderColor,
                    data: ied.slot,
                  ),
                ],
              ),
              S7DbWidget(dbs: ied.dbs.values.toList()),
            ],
          );
      })
    );
  }
}
