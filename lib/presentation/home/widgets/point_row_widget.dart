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
  final void Function(String)? onChanged;
  ///
  PointRowWidget({
    Key? key,
    Color? color,
    this.borderColor,
    required S7PointMarked point,
    this.newPoint,
    Map<String, int>? flex,
    this.dsClient,
    this.onChanged,
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
    Color? errorColor = Theme.of(context).stateColors.error;
    final point = widget._point;
    if (point.isNew) {
      color = Theme.of(context).stateColors.on.withAlpha(100);
    } else if (point.isDeleted) {
      color = Theme.of(context).stateColors.error.withAlpha(100);
    } else {
      color = widget._color;
    }
    if (point.isSelected) {
      color = Color.alphaBlend(
        color ?? Colors.transparent, 
        Theme.of(context).colorScheme.primary.withOpacity(0.5)
      );
    }
    return InkWell(
      onTap: () {
        setState(() {
          point.setIsSelected(value: !point.isSelected);
        });
      },
      child: Row(
        children: [
          Expanded(
            flex: flex != null ? flex['value'] ?? 1 : 1,
            child: RepaintBoundary(
              child: TextIndicator(
                textScaleFactor: 0.8,
                stream: _valueStream(widget.dsClient, point),
              ),
            ),
          ),
          CellWidget<String>(
            flex: flex != null ? flex['v'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: point.v != null ? point.v! > 0 ? '●' : '' : '',
            onChanged: (value) {
              _onValueChanged(value);
              point.setV(value.isEmpty ? '' : '1');
            },
            tooltip: widget.newPoint != null ? (widget.newPoint!.v != point.v ? '${widget.newPoint!.v}' : '') : '',
          ),
          CellWidget<String>(
            flex: flex != null ? flex['name'] ?? 1 : 1,
            color: color,
            borderColor: widget.borderColor,
            data: point.name,
            onChanged: (value) {
              _onValueChanged(value);
              point.setName(value);
            },
            tooltip: widget.newPoint != null ? (widget.newPoint!.name != point.name ? '${widget.newPoint!.name}' : '') : '',
          ),
          CellWidget<String>(
            flex: flex != null ? flex['type'] ?? 1 : 1,
            color: point.typeIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.type,
            onChanged: (value) {
              _onValueChanged(value);
              point.setType(value);
            },
            tooltip: point.typeIsUpdated ? 'before: ${point.typeOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['offset'] ?? 1 : 1,
            color: point.offsetError ? errorColor : point.offsetIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.offset,
            onChanged: (value) {
              _onValueChanged(value);
              point.setOffset(value);
            },
            tooltip: point.offsetIsUpdated ? 'before: ${point.offsetOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['bit'] ?? 1 : 1,
            color: point.bitError ? errorColor : point.bitIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.bit,
            onChanged: (value) {
              _onValueChanged(value);
              point.setBit(value);
            },
            tooltip: point.bitIsUpdated ? 'before: ${point.bitOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['threshold'] ?? 1 : 1,
            color: point.thresholdIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.threshold,
            onChanged: (value) {
              _onValueChanged(value);
              point.setThreshold(value);
            },
            tooltip: point.thresholdIsUpdated ? 'before: ${point.thresholdOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['h'] ?? 1 : 1,
            color: point.hIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.h,
            onChanged: (value) {
              _onValueChanged(value);
              point.setH(value);
            },
            tooltip: point.hIsUpdated ? 'before: ${point.hOld}' : null,
          ),
          CellWidget<int?>(
            flex: flex != null ? flex['a'] ?? 1 : 1,
            color: point.aIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.a,
            onChanged: (value) {
              _onValueChanged(value);
              point.setA(value);
            },
            tooltip: point.aIsUpdated ? 'before: ${point.aOld}' : null,
          ),
          CellWidget<S7PointFr?>(
            flex: flex != null ? flex['fr'] ?? 1 : 1,
            color: point.frIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.fr,
            // onChanged: (value) {
            //} point.setFr(value),
            tooltip: point.frIsUpdated ? 'before: ${point.frOld}' : null,
          ),
          CellWidget<String>(
            flex: flex != null ? flex['comment'] ?? 1 : 1,
            color: point.commentIsUpdated ? isUpdatedColor : color,
            borderColor: widget.borderColor,
            data: point.comment,
            onChanged: (value) {
              _onValueChanged(value);
              point.setComment(value);
            },
            tooltip: point.commentIsUpdated ? 'before: ${point.commentOld}' : null,
          ),
        ],
      ),
    );
  }
  ///
  /// if any of cell value was changed
  void _onValueChanged(String value) {
    final onChanged = widget.onChanged;
    if (onChanged != null) {
      onChanged(value);
    }
  }
  ///
  Stream<DsDataPoint<num>>? _valueStream(DsClient? dsClient, S7PointMarked point) {
    if (point.type == 'Int') {
      return dsClient?.streamInt(point.name);
    }
    if (point.type == 'Real') {
      return dsClient?.streamReal(point.name);
    }
    return null;
  }
}