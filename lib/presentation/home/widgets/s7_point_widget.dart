import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/row_widget.dart';
import 'package:flutter/material.dart';

class S7PointWidget extends StatefulWidget {
  final List<S7Point> _points;
  final Map<String, S7Point>? _newPoints;
  final Map<String, int>? _flex;
  ///
  S7PointWidget({
    Key? key,
    required List<S7Point> points,
    Map<String, S7Point>? newPoints,
    Map<String, int>? flex,
  }) : 
    _points = points,
    _newPoints = newPoints,
    _flex = flex,
    super(key: key);
  ///
  @override
  State<S7PointWidget> createState() => _S7PointWidgetState();
}

///
class _S7PointWidgetState extends State<S7PointWidget> {
  static const _debug = true;
  ///
  @override
  Widget build(BuildContext context) {
    Color? color = null;
    final flex = widget._flex ?? {'name': 1, 'type': 1, 'offset': 1, 'bit': 1, 'threshold': 1, 'h': 1, 'a': 1, 'comment': 1};
    const borderColor = Colors.white10;
    return Column(
      children: [
        RowWidget(
          color: color,
          borderColor: borderColor,
          values: ['name', 'type', 'offset', 'bit', 'threshold', 'h', 'a', 'comment'],
          flex: [flex['name']!, flex['type']!, flex['offset']!, flex['bit']!, flex['threshold']!, flex['h']!, flex['a']!, flex['comment']!],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget._points.length,
          itemBuilder: ((context, index) {
              final point = widget._points[index];
              final newPoint = widget._newPoints?[point.name];
              if (newPoint != null) log(_debug, '\npoint:  $point\nnPoint: $newPoint');
              // if (widget._newPoints != null) {
              //   if (point != newPoint) {
              //     color = Theme.of(context).stateColors.error.withAlpha(100);
              //   }
              // }
              return PointRowWidget(
                color: color,
                borderColor: borderColor,
                point: point,
                newPoint: newPoint,
                flex: widget._flex,
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
  final S7Point _point;
  final S7Point? newPoint;
  final Map<String, int>? _flex;
  const PointRowWidget({
    super.key,
    required this.color,
    required this.borderColor,
    required S7Point point,
    this.newPoint,
    Map<String, int>? flex,
  }) : 
    _point = point,
    _flex = flex;
  ///
  @override
  Widget build(BuildContext context) {
    final flex = _flex;
    return Row(
      children: [
        CellWidget<String>(
          flex: flex != null ? flex['name'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.name,
          newData: newPoint?.name,
          onChanged: (value) => _point.setName(value),
        ),
        CellWidget<String>(
          flex: flex != null ? flex['type'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.type,
          newData: newPoint?.type,
          onChanged: (value) => _point.setType(value),
        ),
        CellWidget<int?>(
          flex: flex != null ? flex['offset'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.offset,
          newData: newPoint?.offset,
          onChanged: (value) => _point.setOffset(value),
        ),
        CellWidget<int?>(
          flex: flex != null ? flex['bit'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.bit,
          newData: newPoint?.bit,
          onChanged: (value) => _point.setBit(value),
        ),
        CellWidget<int?>(
          flex: flex != null ? flex['threshold'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.threshold,
          newData: newPoint?.threshold,
          onChanged: (value) => _point.setThreshold(value),
        ),
        CellWidget<int?>(
          flex: flex != null ? flex['h'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.h,
          newData: newPoint?.h,
          onChanged: (value) => _point.setH(value),
        ),
        CellWidget<int?>(
          flex: flex != null ? flex['a'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.a,
          newData: newPoint?.a,
          onChanged: (value) => _point.setA(value),
        ),
        CellWidget<String?>(
          flex: flex != null ? flex['comment'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.comment,
          newData: newPoint?.comment,
          onChanged: (value) => _point.setComment(value),
        ),
      ],
    );
  }
}


