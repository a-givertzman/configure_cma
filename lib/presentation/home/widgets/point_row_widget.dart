import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/entities/s7_point_fr.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/widgets/text_indicator.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/domain/core/entities/s7_point_marked.dart';
import 'package:flutter/material.dart';

///
class PointRowWidget extends StatefulWidget {
  final Color? _color;
  final Color? borderColor;
  final S7PointMarked _point;
  final S7Point? newPoint;
  final Map<String, int>? _flex;
  final DsClient? dsClient;
  ///
  PointRowWidget({
    Key? key,
    Color? color,
    this.borderColor,
    required S7PointMarked point,
    this.newPoint,
    Map<String, int>? flex,
    this.dsClient,
  }) : 
    _point = point,
    _flex = flex,
    _color = color,
    super(key: key);
  ///
  @override
  State<PointRowWidget> createState() => _PointRowWidgetState();
}

///
class _PointRowWidgetState extends State<PointRowWidget> {
  // static const _debug = true;
  ///
  @override
  Widget build(BuildContext context) {
    final flex = widget._flex;
    Color? color;
    Color? isUpdatedColor = Colors.yellow.withAlpha(200);
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
          Expanded(
            flex: flex != null ? flex['value'] ?? 1 : 1,
            child: RepaintBoundary(
              child: TextIndicator(
                textScaleFactor: 0.8,
                stream: _valueStream(),
              ),
            ),
          ),
          CellWidget<String>(
            flex: flex != null ? flex['v'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.v != null ? widget._point.v! > 0 ? '●' : '' : '',
            onChanged: (value) => widget._point.setV(value.isEmpty ? '' : '1'),
            tooltip: widget.newPoint != null ? (widget.newPoint!.v != widget._point.v ? '${widget.newPoint!.v}' : '') : '',
          ),
          CellWidget<String>(
            flex: flex != null ? flex['name'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: widget._point.name,
            onChanged: (value) => widget._point.setName(value),
            tooltip: widget.newPoint != null ? (widget.newPoint!.name != widget._point.name ? '${widget.newPoint!.name}' : '') : '',
          ),
          CellWidget<String>(
            flex: flex != null ? flex['type'] ?? 1 : 1,
            color: widget._point.typeIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.type,
            onChanged: (value) => widget._point.setType(value),
            tooltip: widget._point.typeIsUpdated ? 'before: ${widget._point.typeOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['offset'] ?? 1 : 1,
            color: widget._point.offsetIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.offset,
            onChanged: (value) => widget._point.setOffset(value),
            tooltip: widget._point.offsetIsUpdated ? 'before: ${widget._point.offsetOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['bit'] ?? 1 : 1,
            color: widget._point.bitIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.bit,
            onChanged: (value) => widget._point.setBit(value),
            tooltip: widget._point.bitIsUpdated ? 'before: ${widget._point.bitOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['threshold'] ?? 1 : 1,
            color: widget._point.thresholdIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.threshold,
            onChanged: (value) => widget._point.setThreshold(value),
            tooltip: widget._point.thresholdIsUpdated ? 'before: ${widget._point.thresholdOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['h'] ?? 1 : 1,
            color: widget._point.hIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.h,
            onChanged: (value) => widget._point.setH(value),
            tooltip: widget._point.hIsUpdated ? 'before: ${widget._point.hOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['a'] ?? 1 : 1,
            color: widget._point.aIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.a,
            onChanged: (value) => widget._point.setA(value),
            tooltip: widget._point.aIsUpdated ? 'before: ${widget._point.aOld}' : null,
          ),
          CellWidget<S7PointFr?>(
            flex: flex != null ? flex['fr'] ?? 1 : 1,
            color: widget._point.frIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.fr,
            // onChanged: (value) => widget._point.setFr(value),
            tooltip: widget._point.frIsUpdated ? 'before: ${widget._point.frOld}' : null,
          ),
          CellWidget<String>(
            flex: flex != null ? flex['comment'] ?? 1 : 1,
            color: widget._point.commentIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: widget._point.comment,
            onChanged: (value) => widget._point.setComment(value),
            tooltip: widget._point.commentIsUpdated ? 'before: ${widget._point.commentOld}' : null,
          ),
        ],
      ),
    );
  }
  ///
  Stream<DsDataPoint<num>>? _valueStream() {
    if (widget._point.type == 'Int') {
      return widget.dsClient?.streamInt(widget._point.name);
    }
    if (widget._point.type == 'Real') {
      return widget.dsClient?.streamReal(widget._point.name);
    }
    return null;
  }
}