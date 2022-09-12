import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

///
/// маленький круглый цветовой индикатор 
/// размером по умолчанию 50px
/// предназначен для цветовой индикации наличия связи
/// работает по статусу DsDataPoint:
///   obsolete    - Theme.of(context).obsoleteColor,
///   invalid     - Theme.of(context).invalidColor,
///   timeInvalid - Theme.of(context).timeInvalidColor,
///   внутреняя ошибка индикатора - Theme.of(context).errorColor,
class InvalidStatusIndicator extends StatelessWidget {
  // static const _debug = true;
  final Stream<DsDataPoint>? _stream;
  final StateColors _statusColors;
  final double _size;
  final double _padding;
  final Widget _child;
  ///
  const InvalidStatusIndicator({
    Key? key,
    Stream<DsDataPoint>? stream,
    required StateColors stateColors,
    double size = 8.0,
    double? padding,
    required Widget child,
  }) : 
    _stream = stream,
    _statusColors = stateColors,
    _size = size,
    _padding = padding ?? size,
    _child = child,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _child,
        Positioned(
          right: _padding,
          bottom: _padding,
          child: StreamBuilder<DsDataPoint>(
            stream: _stream,
            // initialData: DsDataPoint(type: DsDataType.int(), path: '', name: '', value: 0, status: DsStatus.obsolete(), timestamp: DateTime.now().toIso8601String()),
            builder: (context, snapshot) {
              Color color = _statusColors.error;
              if (snapshot.hasData) {
                final point = snapshot.data;
                if (point != null) {
                  if (point.status == DsStatus.ok()) {
                    return SizedBox.shrink();
                  }
                  if (point.status == DsStatus.obsolete()) {
                    color = _statusColors.obsolete;
                  }
                  if (point.status == DsStatus.invalid()) {
                    color = _statusColors.invalid;
                  }
                  if (point.status == DsStatus.timeInvalid()) {
                    color = _statusColors.timeInvalid;
                  }
                }
              }
              return Icon(Icons.circle, size: _size, color: color);
            },
          ),
        ),
      ],
    );
  }
}
