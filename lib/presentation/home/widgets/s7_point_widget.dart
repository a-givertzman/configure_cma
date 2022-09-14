import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/row_widget.dart';
import 'package:flutter/material.dart';

class S7PointWidget extends StatefulWidget {
  final List<S7Point> _points;
  final List<S7Point>? _newPoints;
  ///
  S7PointWidget({
    Key? key,
    required List<S7Point> points,
    List<S7Point>? newPoints,
  }) : 
    _points = points,
    _newPoints = newPoints,
    super(key: key);
  ///
  @override
  State<S7PointWidget> createState() => _S7PointWidgetState();
}


class _S7PointWidgetState extends State<S7PointWidget> {
  @override
  Widget build(BuildContext context) {
    Color? color = null;
    const borderColor = Colors.white10;
    return Column(
      children: [
        RowWidget(
          color: color,
          borderColor: borderColor,
          values: ['name', 'type', 'offset', 'bit', 'threshHold', 'h', 'a', 'comment'],
          flex: [15, 3, 2, 2, 1, 1, 1, 10],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget._points.length,
          itemBuilder: ((context, index) {
              final point = widget._points[index];
              final newPoint = widget._newPoints?[index];
              if (widget._newPoints != null) {
                if (newPoint != newPoint) {
                  color = Theme.of(context).stateColors.error.withAlpha(100);
                }
              }
              return PointRowWidget(
                color: color,
                borderColor: borderColor,
                point: point,
                newPoint: newPoint,
              );
          })
        ),
      ],
    );
  }
}

///
class PointRowWidget extends StatelessWidget {
  final Color? color;
  final Color borderColor;
  final S7Point point;
  final S7Point? newPoint;
  const PointRowWidget({
    super.key,
    required this.color,
    required this.borderColor,
    required this.point,
    this.newPoint,
  });
  ///
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CellWidget<String>(
          flex: 15,
          color: color,
          borderColor: borderColor,
          data: point.name,
          newData: newPoint?.name,
          onChanged: (value) => point.setName(value),
        ),
        CellWidget<String>(
          flex: 3,
          color: color,
          borderColor: borderColor,
          data: point.type,
          newData: newPoint?.type,
          onChanged: (value) => point.setType(value),
        ),
        CellWidget<int?>(
          flex: 2,
          color: color,
          borderColor: borderColor,
          data: point.offset,
          newData: newPoint?.offset,
          onChanged: (value) => point.setOffset(value),
        ),
        CellWidget<int?>(
          flex: 2,
          color: color,
          borderColor: borderColor,
          data: point.bit,
          newData: newPoint?.bit,
          onChanged: (value) => point.setBit(value),
        ),
        CellWidget<int?>(
          flex: 1,
          color: color,
          borderColor: borderColor,
          data: point.threshold,
          newData: newPoint?.threshold,
          onChanged: (value) => point.setThreshold(value),
        ),
        CellWidget<int?>(
          flex: 1,
          color: color,
          borderColor: borderColor,
          data: point.h,
          newData: newPoint?.h,
          onChanged: (value) => point.setH(value),
        ),
        CellWidget<int?>(
          flex: 1,
          color: color,
          borderColor: borderColor,
          data: point.a,
          newData: newPoint?.a,
          onChanged: (value) => point.setA(value),
        ),
        CellWidget<String?>(
          flex: 10,
          color: color,
          borderColor: borderColor,
          data: point.comment,
          newData: newPoint?.comment,
          onChanged: (value) => point.setComment(value),
        ),
      ],
    );
  }
}


