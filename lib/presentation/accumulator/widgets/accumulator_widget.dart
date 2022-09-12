import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/widgets/bool_color_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/circular_bar_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/common_container_widget.dart';
import 'package:configure_cma/presentation/core/widgets/invalid_status_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/status_indicator_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
/// Два насоса с приводом
class AccumulatorWidget extends StatefulWidget {
  final DsClient? _dsClient;
  final double? _minNitroPressure;
  final double? _maxNitroPressure;
  final double? _lowNitroPressure;
  final double? _highNitroPressure;
  final String? _pistonMaxLimitTagName;
  final String? _pistonMinLimitTagName;
  final String? _pressureOfNitroTagName;
  final String? _alarmNitroPressureTagName;
  final Widget? _caption;
  ///
  /// - [inUseStream] - поток состояния задействована/незадействована насосная группа
  /// - [_driveStream] - поток состояния привода насосов
  const AccumulatorWidget({
    Key? key,
    DsClient? dsClient,
    double? minNitroPressure,
    double? maxNitroPressure,
    double? lowNitroPressure,
    double? highNitroPressure,
    String? pistonMaxLimitTagName,
    String? pistonMinLimitTagName,
    String? pressureOfNitroTagName,
    String? alarmNitroPressureTagName,
    Widget? caption,
  }) : 
    _dsClient = dsClient,
    _minNitroPressure = minNitroPressure,
    _maxNitroPressure = maxNitroPressure,
    _lowNitroPressure = lowNitroPressure,
    _highNitroPressure = highNitroPressure,
    _pistonMaxLimitTagName = pistonMaxLimitTagName,
    _pistonMinLimitTagName = pistonMinLimitTagName,
    _pressureOfNitroTagName = pressureOfNitroTagName,
    _alarmNitroPressureTagName = alarmNitroPressureTagName,
    _caption = caption,
    super(key: key);
  ///
  @override
  State<AccumulatorWidget> createState() => _AccumulatorWidgetState(
    dsClient: _dsClient,
    minNitroPressure: _minNitroPressure,
    maxNitroPressure: _maxNitroPressure,
    lowNitroPressure: _lowNitroPressure,
    highNitroPressure: _highNitroPressure,
    pistonMaxLimitTagName: _pistonMaxLimitTagName,
    pistonMinLimitTagName: _pistonMinLimitTagName,
    pressureOfNitroTagName: _pressureOfNitroTagName,
    alarmNitroPressureTagName: _alarmNitroPressureTagName,
    caption: _caption,
  );
}

///
class _AccumulatorWidgetState extends State<AccumulatorWidget> {
  // static const _debug = true;
  final DsClient? _dsClient;
  final double? _minNitroPressure;
  final double? _maxNitroPressure;
  final double? _lowNitroPressure;
  final double? _highNitroPressure;
  final String? _pistonMaxLimitTagName;
  final String? _pistonMinLimitTagName;
  final String? _pressureOfNitroTagName;
  final String? _alarmNitroPressureTagName;
  final Widget? _caption;
  ///
  _AccumulatorWidgetState({
    required DsClient? dsClient,
    double? minNitroPressure,
    double? maxNitroPressure,
    double? lowNitroPressure,
    double? highNitroPressure,
    required String? pistonMaxLimitTagName,
    required String? pistonMinLimitTagName,
    required String? pressureOfNitroTagName,
    required String? alarmNitroPressureTagName,
    required Widget? caption,
  }) : 
    _dsClient = dsClient,
    _minNitroPressure = minNitroPressure,
    _maxNitroPressure = maxNitroPressure,
    _lowNitroPressure = lowNitroPressure,
    _highNitroPressure = highNitroPressure,
    _pistonMaxLimitTagName = pistonMaxLimitTagName,
    _pistonMinLimitTagName = pistonMinLimitTagName,
    _pressureOfNitroTagName = pressureOfNitroTagName,
    _alarmNitroPressureTagName = alarmNitroPressureTagName,
    _caption = caption,
    super();
  ///
  @override
  void initState() {
    // final inUseStream = _inUseStream;
    // if (inUseStream != null) {
    //   inUseStream.listen((event) {
    //     if (mounted) {
    //       setState(() {
    //         _inUse = event.value == 2;
    //         _inUseSwitchDisabled = false;
    //       });
    //     }
    //   });
    // }
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    // const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    final stateColors = Theme.of(context).stateColors;
    final dsClient = _dsClient;
    final pistonMaxLimitTagName = _pistonMaxLimitTagName;
    final pistonMinLimitTagName = _pistonMinLimitTagName;
    final pressureOfNitroTagName = _pressureOfNitroTagName;
    final alarmNitroPressureTagName = _alarmNitroPressureTagName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140.0,
          child: Center(child: _caption),
        ),
        const SizedBox(height: blockPadding,),
        StatusIndicatorWidget(
          width: 230.0,
          indicator: BoolColorIndicator(
            // iconData: Icons.account_tree_outlined,
            stream: (dsClient != null && pistonMaxLimitTagName != null) ? dsClient.streamBool(pistonMaxLimitTagName) : null,
          ),
          caption: Text(const AppText('Piston max limit').local),
        ),
        StatusIndicatorWidget(
          width: 230.0,
          indicator: BoolColorIndicator(
            // iconData: Icons.account_tree_outlined,
            stream: (dsClient != null && pistonMinLimitTagName != null) ? dsClient.streamBool(pistonMinLimitTagName) : null,
          ),
          caption: Text(const AppText('Piston min limit').local),
        ),
        const SizedBox(height: blockPadding,),
        InvalidStatusIndicator(
          stream: (dsClient != null && pressureOfNitroTagName != null) ? dsClient.streamBool(pressureOfNitroTagName) : null,
          stateColors: stateColors,
          child: CommonContainerWidget(
            header: Text(
              AppText('Pressure of nitro').local,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            children: [
              CircularBarIndicator(
                size: 192.0,
                min: _minNitroPressure ?? 0,
                max: _maxNitroPressure ?? 0,
                low: _lowNitroPressure,
                high: _highNitroPressure,
                valueUnit: 'bar',
                stream: dsClient != null && pressureOfNitroTagName != null
                  ? dsClient.streamInt(pressureOfNitroTagName) 
                  : null,
              ),
            ],
          ),
        ),
        StatusIndicatorWidget(
          width: 230.0,
          indicator: BoolColorIndicator(
            // iconData: Icons.account_tree_outlined,
            stream: (dsClient != null && alarmNitroPressureTagName != null) ? dsClient.streamBool(alarmNitroPressureTagName) : null,
          ),
          caption: Expanded(child: Text(const AppText('Emergency high nitro pressure').local, textAlign: TextAlign.center,)),
        ),
      ],
    );
  }
}
