import 'dart:async';

import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';
import 'package:crane_monitoring_app/domain/core/entities/state_constatnts.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class DsDataStreamExtract<T> {
  late StreamController<DsDataPointExtracted<T>> _controller;
  final Stream<DsDataPoint<T>>? _stream;
  final StateColors _stateColors;
  ///
  DsDataStreamExtract({
    required Stream<DsDataPoint<T>>? stream,
    required StateColors stateColors,
  }) : 
    _stream = stream,
    _stateColors = stateColors;
  ///
  Stream<DsDataPointExtracted<T>> get stream {
    _controller = StreamController(
      onListen: () {
        final stream = _stream;
        if (stream != null) {
          stream.listen((event) {
            final point = event;
            _controller.add(
              DsDataPointExtracted(
                value: point.value, 
                status: point.status,
                color: _buildColor(point),
              ),
            );
          });        
        }
      },
    );
    return _controller.stream;
  }
  ///
  /// расчитывает текущий цвет в зависимости от point.status и point.value
  Color _buildColor(DsDataPoint<T> point) {
    Color clr = _stateColors.invalid;
    if (point.status == DsStatus.ok()) {
      clr = point.value == DsDps.off.value
        ? _stateColors.off
        : point.value == DsDps.on.value
          ? _stateColors.on
          : point.value == DsDps.transient.value
            ? _stateColors.error
            : clr;
    }
    if (point.status == DsStatus.obsolete()) {
      clr = _stateColors.obsolete;
    }
    if (point.status == DsStatus.invalid()) {
      clr = _stateColors.invalid;
    }
    if (point.status == DsStatus.timeInvalid()) {
      clr = _stateColors.timeInvalid;
    }
    return clr;
  }  
}

///
class DsDataPointExtracted<T> {
  final T value;
  final DsStatus status;
  final Color color;
  const DsDataPointExtracted({
    required this.value,
    required this.status,
    required this.color,
  });
}