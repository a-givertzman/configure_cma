import 'dart:async';
import 'dart:math';

import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/common_container_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/invalid_status_indicator.dart';
import 'package:crane_monitoring_app/presentation/winch_1/widgets/winch_widget.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/circular_bar_indicator.dart';

class Winch1Body extends StatelessWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  Winch1Body({
    Key? key,
    // required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    // _users = users,
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$Winch1Body.build]');
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    // final statusColors = StatusColors(
    //   error: Theme.of(context).errorColor,
    //   obsolete: Theme.of(context).obsoleteColor,
    //   invalid: Theme.of(context).invalidColor,
    //   timeInvalid: Theme.of(context).timeInvalidColor,
    //   off: Theme.of(context).backgroundColor,
    //   on: Theme.of(context).colorScheme.primary,
    // );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_dsClient.isConnected()) {
    //     _dsClient.requestAll();
    //   }
    // });
    Future.delayed(Duration(seconds: 1), () {
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });
    return Transform.scale(
      scale: min(
        width / AppUiSettings.displaySize.width, 
        height / AppUiSettings.displaySize.height,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Блок | Датчики гидромотора 1
              WinchWidget(
                dsClient: _dsClient,
                rotationSpeedTagName: 'AnalogSensors.Winch.EncoderBR1',
                lvdtTagName: 'AnalogSensors.Winch.LVDT1',
                pressureTagName: 'AnalogSensors.Winch.PressureLineA_1',
                pressureBrakeTagName: 'AnalogSensors.Winch.PressureBrakeA',
                temperatureTagName: 'AnalogSensors.Winch.TempLine1',
                hydromotorActiveTagName: 'Winch.Hydromotor1Active',
                caption: Text(const AppText('Hydromotor').local + ' 1.0', textAlign: TextAlign.center,),
              ),
              const SizedBox(width: blockPadding * 2,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/pump-top-bottom-var-left.png',
                    width: 80.0,
                    height: 80.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                    // color: Colors.blueAccent,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(width: padding,),
                  Image.asset(
                    'assets/icons/winch.png',
                    width: 100.0,
                    height: 100.0,
                    // color: Colors.blueAccent,
                    color: Theme.of(context).colorScheme.tertiary,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                  ),
                  const SizedBox(width: padding,),
                  Image.asset(
                    'assets/icons/pump-top-bottom-var-right.png',
                    width: 80.0,
                    height: 80.0,
                    color: Theme.of(context).colorScheme.tertiary,
                    // color: Colors.blueAccent,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                  ),
                ],
              ),
              /// Column 2 | Brand Icon
              // Column(
              //   mainAxisSize: MainAxisSize.min,
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Image.asset(
              //       'assets/img/brand_icon.png',
              //       scale: 4.0,
              //       opacity: const AlwaysStoppedAnimation<double>(0.2),
              //     ),
              //   ],
              // ),
              const SizedBox(width: blockPadding * 2,),
              /// Блок | Датчики гидромотора 1
              WinchWidget(
                dsClient: _dsClient,
                // rotationSpeedTagName: 'AnalogSensors.Winch.EncoderBR2',
                lvdtTagName: 'AnalogSensors.Winch.LVDT2',
                pressureTagName: 'AnalogSensors.Winch.PressureLineA_2',
                pressureBrakeTagName: 'AnalogSensors.Winch.PressureBrakeB',
                temperatureTagName: 'AnalogSensors.Winch.TempLine2',
                hydromotorActiveTagName: 'Winch.Hydromotor2Active',
                caption: Text(const AppText('Hydromotor').local + ' 2.0', textAlign: TextAlign.center,),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InvalidStatusIndicator(
                stream: _dsClient.streamInt('AnalogSensors.Winch.EncoderBR1'),
                stateColors: Theme.of(context).stateColors,
                child: CommonContainerWidget(
                  header: Text(
                    AppText('Rotation speed').local.replaceFirst(' ', '\n'),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    CircularBarIndicator(
                      size: 60,
                      min: 0,
                      max: 4500,
                      high: 4050.0,
                      valueUnit: AppText('rpm').local,
                      stream: _dsClient.streamInt('AnalogSensors.Winch.EncoderBR1'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: blockPadding),
              InvalidStatusIndicator(
                stream: _dsClient.streamInt('AnalogSensors.Winch.EncoderBR2'),
                stateColors: Theme.of(context).stateColors,
                child: CommonContainerWidget(
                  header: Text(
                    AppText('Rope length').local.replaceFirst(' ', '\n'),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  children: [
                    CircularBarIndicator(
                      size: 60,
                      min: 0,
                      max: 53,
                      valueUnit: AppText('m').local,
                      stream: _dsClient.streamInt('AnalogSensors.Winch.EncoderBR2').map((event) {
                        return DsDataPoint(
                          type: event.type, 
                          path: event.path, 
                          name: event.name, 
                          value: event.value / 100, 
                          status: event.status, 
                          timestamp: event.timestamp,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),      
        ],
      ),
    );
  }
}
