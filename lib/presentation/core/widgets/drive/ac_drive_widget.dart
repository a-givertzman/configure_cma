import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/widgets/dps_icon_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/invalid_status_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/status_indicator_widget.dart';
import 'package:flutter/material.dart';

class AcDriveWidget extends StatelessWidget {
  final Stream<DsDataPoint<int>>? _stream;
  final String? _caption;
  final bool _disabled;
  ///
  const AcDriveWidget({
    Key? key,
    Stream<DsDataPoint<int>>? stream,
    String? caption,
    bool disabled = false,
  }) : 
    _stream = stream,
    _caption = caption,
    _disabled = disabled,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    final caption = _caption;
    final stateColors = Theme.of(context).stateColors;
    return InvalidStatusIndicator(
      stream: _stream,
      stateColors: stateColors,
      child: StatusIndicatorWidget(
        width: 100,
        height: 100,
        disabled: _disabled,
        indicator: DpsIconIndicator(
          stream: _stream,
          posUndefinedIcon: Image.asset(
            'assets/icons/ac_motor.png',
            color: Theme.of(context).stateColors.invalid,
          ),
          posOffIcon: Image.asset(
            'assets/icons/ac_motor.png',
            color: Theme.of(context).stateColors.off,
          ),
          posOnIcon: Image.asset(
            'assets/icons/ac_motor.png',
            color: Theme.of(context).stateColors.on,
          ),
          posTransientIcon: Image.asset(
            'assets/icons/ac_motor_failure.png',
            color: Theme.of(context).stateColors.error,
          ),
        ), 
        caption: (caption != null) 
          ? Text(caption, textAlign: TextAlign.center) 
          : null,
        alignment: Alignment.center,
      ),
    );
  }
}