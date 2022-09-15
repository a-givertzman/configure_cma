import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_marked.dart';
import 'package:flutter/material.dart';

///
class PointRowWidget extends StatelessWidget {
  final Color? _color;
  final Color? borderColor;
  final S7PointMarked _point;
  final S7Point? newPoint;
  final Map<String, int>? _flex;
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
  Widget build(BuildContext context) {
    final flex = _flex;
    Color? color;
    if (_point.isNew) {
      color = Theme.of(context).stateColors.on.withAlpha(100);
    } else if (_point.isDeleted) {
      color = Theme.of(context).stateColors.error.withAlpha(100);
    } else {
      color = _color;
    }
    return Row(
      children: [
        CellWidget<String>(
          flex: flex != null ? flex['v'] ?? 1 : 1,
          color: color,
          borderColor: borderColor,
          data: _point.v != null ? _point.v! > 0 ? '●' : '' : '',
          // newData: newPoint?.v,
          onChanged: (value) => _point.setV(value.isEmpty ? '' : '1'),
          tooltip: newPoint != null ? (newPoint!.v != _point.v ? '${newPoint!.v}' : '') : '',
        ),
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
        CellWidget<String>(
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