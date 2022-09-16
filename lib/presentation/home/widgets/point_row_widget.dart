import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_marked.dart';
import 'package:flutter/material.dart';

///
class PointRowWidget extends StatefulWidget {
  final Color? _color;
  final Color? borderColor;
  final S7PointMarked _point;
  final S7Point? newPoint;
  final Map<String, int>? _flex;
  ///
  PointRowWidget({
    Key? key,
    Color? color,
    this.borderColor,
    required S7PointMarked point,
    this.newPoint,
    Map<String, int>? flex,
  }) : 
    _point = point,
    _flex = flex,
    _color = color,
    super(key: key);
  ///
  @override
  State<PointRowWidget> createState() => _PointRowWidgetState();
}

class _PointRowWidgetState extends State<PointRowWidget> {
  static const _debug = true;
  ///
  @override
  Widget build(BuildContext context) {
    final flex = widget._flex;
    Color? color;
    if (widget._point.isNew) {
      color = Theme.of(context).stateColors.on.withAlpha(100);
    } else if (widget._point.isDeleted) {
      color = Theme.of(context).stateColors.error.withAlpha(100);
    } else {
      color = widget._color;
    }
    if (widget._point.isSelected) {
      color = Color.alphaBlend(
        color ?? Colors.transparent, 
        Theme.of(context).colorScheme.primary.withOpacity(0.5)
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          widget._point.setIsSelected(value: !widget._point.isSelected);
        });
      },
      child: Row(
        children: [
          CellWidget<String>(
            flex: flex != null ? flex['v'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.v != null ? widget._point.v! > 0 ? '●' : '' : '',
            // newData: newPoint?.v,
            onChanged: (value) => widget._point.setV(value.isEmpty ? '' : '1'),
            tooltip: widget.newPoint != null ? (widget.newPoint!.v != widget._point.v ? '${widget.newPoint!.v}' : '') : '',
          ),
          CellWidget<String>(
            flex: flex != null ? flex['name'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.name,
            newData: widget.newPoint?.name,
            onChanged: (value) => widget._point.setName(value),
          ),
          CellWidget<String>(
            flex: flex != null ? flex['type'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.type,
            newData: widget.newPoint?.type,
            onChanged: (value) => widget._point.setType(value),
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['offset'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.offset,
            newData: widget.newPoint?.offset,
            onChanged: (value) => widget._point.setOffset(value),
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['bit'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.bit,
            newData: widget.newPoint?.bit,
            onChanged: (value) => widget._point.setBit(value),
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['threshold'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.threshold,
            newData: widget.newPoint?.threshold,
            onChanged: (value) => widget._point.setThreshold(value),
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['h'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.h,
            newData: widget.newPoint?.h,
            onChanged: (value) => widget._point.setH(value),
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['a'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.a,
            newData: widget.newPoint?.a,
            onChanged: (value) => widget._point.setA(value),
          ),
          CellWidget<String>(
            flex: flex != null ? flex['comment'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.comment,
            newData: widget.newPoint?.comment,
            onChanged: (value) => widget._point.setComment(value),
          ),
        ],
      ),
    );
  }
}