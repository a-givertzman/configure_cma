import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/bool_color_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/circular_bar_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/common_container_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/invalid_status_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/status_indicator_widget.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
/// Два насоса с приводом
class WinchWidget extends StatefulWidget {
  final DsClient? _dsClient;
  final String? _rotationSpeedTagName;
  final String? _lvdtTagName;
  final String? _pressureTagName;
  final String? _pressureBrakeTagName;
  final String? _temperatureTagName;
  final String? _hydromotorActiveTagName;
  final Widget? _caption;
  // final bool _left;
  ///
  /// - [inUseStream] - поток состояния задействована/незадействована насосная группа
  /// - [_driveStream] - поток состояния привода насосов
  const WinchWidget({
    Key? key,
    DsClient? dsClient,
    String? rotationSpeedTagName,
    String? lvdtTagName,
    String? pressureTagName,
    String? pressureBrakeTagName,
    String? temperatureTagName,
    String? hydromotorActiveTagName,
    Widget? caption,
    bool left = true,
  }) : 
    _dsClient = dsClient,
    _rotationSpeedTagName = rotationSpeedTagName,
    _lvdtTagName = lvdtTagName,
    _pressureTagName = pressureTagName,
    _pressureBrakeTagName = pressureBrakeTagName,
    _temperatureTagName = temperatureTagName,
    _hydromotorActiveTagName = hydromotorActiveTagName,
    _caption = caption,
    // _left = left,
    super(key: key);
  ///
  @override
  State<WinchWidget> createState() => _AccumulatorWidgetState(
    dsClient: _dsClient,
    rotationSpeedTagName: _rotationSpeedTagName,
    lvdtTagName: _lvdtTagName,
    pressureTagName: _pressureTagName,
    pressureBrakeTagName: _pressureBrakeTagName,
    temperatureTagName: _temperatureTagName,
    hydromotorActiveTagName: _hydromotorActiveTagName,
    caption: _caption,
  );
}

///
class _AccumulatorWidgetState extends State<WinchWidget> {
  // static const _debug = true;
  final DsClient? _dsClient;
  final String? _lvdtTagName;
  final String? _pressureTagName;
  final String? _pressureBrakeTagName;
  final String? _temperatureTagName;
  final String? _hydromotorActiveTagName;
  final Widget? _caption;
  ///
  _AccumulatorWidgetState({
    required DsClient? dsClient,
    required String? rotationSpeedTagName,
    required String? lvdtTagName,
    required String? pressureTagName,
    required String? pressureBrakeTagName,
    required String? temperatureTagName,
    required String? hydromotorActiveTagName,
    required Widget? caption,
  }) : 
    _dsClient = dsClient,
    _lvdtTagName = lvdtTagName,
    _pressureTagName = pressureTagName,
    _pressureBrakeTagName = pressureBrakeTagName,
    _temperatureTagName = temperatureTagName,
    _hydromotorActiveTagName = hydromotorActiveTagName,
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
    const width = 230.0;
    const size = 60.0;
    // const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    final stateColors = Theme.of(context).stateColors;
    final dsClient = _dsClient;
    final temperatureTagName = _temperatureTagName;
    final lvdtTagName = _lvdtTagName;
    final pressureTagName = _pressureTagName;
    final pressureBrakeTagName = _pressureBrakeTagName;
    final hydromotorActiveTagName = _hydromotorActiveTagName;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140.0,
          child: Center(child: _caption),
        ),
        const SizedBox(height: blockPadding,),
        StatusIndicatorWidget(
          width: width,
          indicator: BoolColorIndicator(
            // iconData: Icons.account_tree_outlined,
            stream: (dsClient != null && hydromotorActiveTagName != null) ? dsClient.streamBool(hydromotorActiveTagName) : null,
          ),
          caption: Text(const AppText('Hydromotor state').local),
        ),
        const SizedBox(height: blockPadding,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // if (widget._left) ...[
            //   _buildTempIndicator(stateColors, size),
            //   const SizedBox(width: blockPadding,),
            // ],
            Column(
              children: [
                Row(
                  children: [
                    InvalidStatusIndicator(
                      stream: (dsClient != null && temperatureTagName != null) ? dsClient.streamReal(temperatureTagName) : null,
                      stateColors: stateColors,
                      child: CommonContainerWidget(
                        header: Text(
                          AppText('Drainage temp').local.replaceFirst(' ', '\n'),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        children: [
                          CircularBarIndicator(
                            size: size,
                            min: -20,
                            max: 40,
                            valueUnit: '℃',
                            stream: (dsClient != null && temperatureTagName != null) ? dsClient.streamReal(temperatureTagName) : null,
                          ),
                        ],
                      ),
                    ),
                    InvalidStatusIndicator(
                      stream: (dsClient != null && lvdtTagName != null) ? dsClient.streamReal(lvdtTagName) : null,
                      stateColors: stateColors,
                      child: CommonContainerWidget(
                        header: Text(
                          AppText('LVDT').local + '\n',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        children: [
                          CircularBarIndicator(
                            size: size,
                            min: 0,
                            max: 15,
                            valueUnit: 'º',
                            fractionDigits: 2,
                            stream: (dsClient != null && lvdtTagName != null) ? dsClient.streamReal(lvdtTagName) : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: blockPadding,),
                Row(
                  children: [
                    InvalidStatusIndicator(
                      stream: (dsClient != null && pressureTagName != null) ? dsClient.streamReal(pressureTagName) : null,
                      stateColors: stateColors,
                      child: CommonContainerWidget(
                        header: Text(
                          AppText('Pressure').local + '\n',
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        children: [
                          CircularBarIndicator(
                            size: size,
                            min: 0,
                            max: 400,
                            // high: 330.0,
                            valueUnit: 'bar',
                            stream: (dsClient != null && pressureTagName != null) ? dsClient.streamReal(pressureTagName) : null,
                          ),
                        ],
                      ),
                    ),
                    InvalidStatusIndicator(
                      stream: (dsClient != null && pressureBrakeTagName != null) ? dsClient.streamReal(pressureBrakeTagName) : null,
                      stateColors: stateColors,
                      child: CommonContainerWidget(
                        header: Text(
                          AppText('Presure of brake').local.replaceFirst(' ', '\n'),
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                        children: [
                          CircularBarIndicator(
                            size: size,
                            min: 0,
                            max: 200,
                            // high: 330.0,
                            valueUnit: 'bar',
                            stream: (dsClient != null && pressureBrakeTagName != null) ? dsClient.streamReal(pressureBrakeTagName) : null,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // if (!widget._left) ...[
            //   const SizedBox(width: blockPadding,),
            //   _buildTempIndicator(stateColors, size),
            // ],
          ],
        ),
      ],
    );
  }
  // Widget _buildTempIndicator(StateColors stateColors, double size) {
  //   final dsClient = _dsClient;
  //   final temperatureTagName = _temperatureTagName;
  //   return InvalidStatusIndicator(
  //     stream: (dsClient != null && temperatureTagName != null) ? dsClient.streamInt(temperatureTagName) : null,
  //     stateColors: stateColors,
  //     child: CommonContainerWidget(
  //       header: Text(
  //         AppText('Drainage temp').local.replaceFirst(' ', '\n'),
  //         style: Theme.of(context).textTheme.bodySmall,
  //         textAlign: TextAlign.center,
  //       ),
  //       children: [
  //         CircularBarIndicator(
  //           size: size,
  //           min: 0,
  //           max: 400,
  //           high: 330.0,
  //           valueUnit: '℃',
  //           stream: (dsClient != null && temperatureTagName != null) ? dsClient.streamInt(temperatureTagName) : null,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
