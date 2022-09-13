import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/presentation/home/widgets/row_widget.dart';
import 'package:flutter/material.dart';

class S7PointWidget extends StatefulWidget {
  final List<S7Point> _points;
  ///
  S7PointWidget({
    Key? key,
    required List<S7Point> points,
  }) : 
    _points = points,
    super(key: key);
  ///
  @override
  State<S7PointWidget> createState() => _S7PointWidgetState();
}


class _S7PointWidgetState extends State<S7PointWidget> {
  @override
  Widget build(BuildContext context) {
    final color = null;
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
              return PointRowWidget(
                color: color,
                borderColor: borderColor,
                point: point,
              );
          })
        ),
      ],
    );
  }
}


class PointRowWidget extends StatelessWidget {
  final Color? color;
  final Color borderColor;
  final S7Point point;
  const PointRowWidget({
    super.key,
    required this.color,
    required this.borderColor,
    required this.point,
  });
  ///
  @override
  Widget build(BuildContext context) {
    return RowWidget(
      color: color,
      borderColor: borderColor,
      values: [point.name, point.type, point.offset, point.bit, point.threshHold, point.h, point.a, point.comment],
      flex: [15, 3, 2, 2, 1, 1, 1, 10],
    );
  }
}


