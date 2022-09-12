import 'dart:async';
import 'dart:math';

import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/entities/ds_point_path.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/widgets/bool_color_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/circular_bar_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/common_container_widget.dart';
import 'package:configure_cma/presentation/core/widgets/invalid_status_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/linear_bar_indicator_v1.dart';
import 'package:configure_cma/presentation/core/widgets/status_indicator_widget.dart';
import 'package:configure_cma/presentation/hpu/widgets/hpu_double_pump_widget.dart';
import 'package:configure_cma/presentation/hpu/widgets/hpu_pump_widget.dart';
import 'package:configure_cma/infrastructure/stream/ds_send.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class HpuBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  HpuBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    _users = users,
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$HpuBody.build]');
    final user = _users.peek;
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final stateColors = Theme.of(context).stateColors;
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
              /// Индикаторы | Уровень и температура масла
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/brand_icon.png',
                    scale: 4.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.2),
                  ),
                  const SizedBox(height: blockPadding,),
                  Text(const AppText('Hydraulic tank').local),
                  const SizedBox(height: padding,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 80.0,),
                          /// Индикатор | Высокий уровень масла
                          Tooltip(
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: GlobalObjectKey('DigitalSensors.HPU.HighOilLevel'),
                                stream: _dsClient.streamBool('DigitalSensors.HPU.HighOilLevel'),
                                trueColor: stateColors.lowLevel,
                              ), 
                            ),
                            message: const AppText('High oil level').local,
                          ),
                          SizedBox(height: 10.0,),
                          /// Индикатор | Низкий уровень масла
                          Tooltip(
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: GlobalObjectKey('DigitalSensors.HPU.LowOilLevel'),
                                stream: _dsClient.streamBool('DigitalSensors.HPU.LowOilLevel'),
                                trueColor: stateColors.lowLevel,
                              ), 
                            ),
                            message: const AppText('Low oil level').local,
                          ),
                          /// Индикатор | Аварийно низкий уровень масла
                          Tooltip(
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: GlobalObjectKey('DigitalSensors.HPU.AlarmLowOilLevel'),
                                stream: _dsClient.streamBool('DigitalSensors.HPU.AlarmLowOilLevel'),
                                trueColor: stateColors.alarmLowLevel,
                              ), 
                            ),
                            message: const AppText('Emergency low oil level').local,
                          ),
                        ],
                      ),
                      InvalidStatusIndicator(
                        stream: _dsClient.streamReal('HPU.OilLevel'),
                        stateColors: stateColors,
                        child: CommonContainerWidget(
                          header: Text(
                            AppText('Oil level').local.replaceAll(' ', '\n'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          children: [
                            LinearBarIndicatorV1(
                              user: user, 
                              title: const AppText('%').local,
                              angle: 90.0,
                              indicatorLength: 200.0 - 14 - blockPadding - padding,
                              strokeWidth: 36.0,
                              stream: _dsClient.streamReal('HPU.OilLevel'),
                            ),
                          ],
                        ),
                      ),
                      InvalidStatusIndicator(
                        stream: _dsClient.streamReal('HPU.OilTemp'),
                        stateColors: stateColors,
                        child: CommonContainerWidget(
                          header: Text(
                            AppText('Temp').local + '\n',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          children: [
                            LinearBarIndicatorV1(
                              user: user, 
                              title: const AppText('℃').local,
                              min: 0,
                              max: 80,
                              angle: 90.0,
                              indicatorLength: 200.0 - 14 - blockPadding - padding,
                              strokeWidth: 24.0,
                              stream: _dsClient.streamReal('HPU.OilTemp'),
                          ),
                        ],),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 80.0,),
                          Tooltip(
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: GlobalObjectKey('DigitalSensors.HPU.AlarmHighOilTemp'),
                                stream: _dsClient.streamBool('DigitalSensors.HPU.AlarmHighOilTemp'),
                                trueColor: stateColors.alarmHighLevel,
                              ), 
                            ),
                            message: const AppText('Emergency high oil temperature').local,
                          ),
                          /// Индикатор | Высокая температура масла
                          Tooltip(
                            child: StatusIndicatorWidget(
                              indicator: BoolColorIndicator(
                                key: GlobalObjectKey('DigitalSensors.HPU.HighOilTemp'),
                                stream: _dsClient.streamBool('DigitalSensors.HPU.HighOilTemp'),
                                trueColor: stateColors.highLevel,
                              ), 
                            ),
                            message: const AppText('High oil temperature').local,
                          ),
                          SizedBox(height: 10.0,),
                          /// Индикатор | Низкая температура масла
                          SizedBox(height: 46.0,),
                          // Tooltip(
                          //   child: StatusIndicatorWidget(
                          //     indicator: BoolColorIndicator(
                          //       key: GlobalObjectKey('DigitalSensors.HPU.LowOilTemp'),
                          //       stream: _dsClient.streamBool('DigitalSensors.HPU.LowOilTemp'),
                          //       trueColor: stateColors.lowLevel,
                          //     ), 
                          //   ),
                          //   message: const AppText('Low oil temperature').local,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(width: blockPadding * 4.5,),
              /// Блок | Компрессор с приводом 1
              HpuDoublePumpWidget(
                inUseStream: _dsClient.streamInt('Settings.HPU.Pump1InUse'),
                driveStream: _dsClient.streamInt('HPU.Pump1.State'),
                presure1Stream: _dsClient.streamReal('HPU.PressureOutPump1'),
                presure2Stream: _dsClient.streamReal('HPU.PressureInPump1'),
                caption: Text(const AppText('HPU 1').local),
                driveCaption: const AppText('M1').local,
                pump1Caption: const AppText('P1.1').local,
                pump2Caption: const AppText('P1.2').local,
                onChanged: (value) {
                  DsSend<int>(
                    dsClient: _dsClient, 
                    pointPath: DsPointPath(
                      path: 'line1.ied12.db902_panel_controls',
                      name: 'Settings.HPU.Pump1InUse',
                    ),
                  ).exec(value);
                },
              ),
              const SizedBox(width: blockPadding * 4.5,),
              /// Блок | Компрессор с приводом 2
              HpuDoublePumpWidget(
                inUseStream: _dsClient.streamInt('Settings.HPU.Pump2InUse'),
                driveStream: _dsClient.streamInt('HPU.Pump2.State'),
                presure1Stream: _dsClient.streamReal('HPU.PressureOutPump2'),
                presure2Stream: _dsClient.streamReal('HPU.PressureInPump2'),
                caption: Text(const AppText('HPU 2').local),
                driveCaption: const AppText('M2').local,
                pump1Caption: const AppText('P2.1').local,
                pump2Caption: const AppText('P2.2').local,
                onChanged: (value) {
                  DsSend<int>(
                    dsClient: _dsClient, 
                    pointPath: DsPointPath(
                      path: 'line1.ied12.db902_panel_controls',
                      name: 'Settings.HPU.Pump2InUse',
                    ),
                  ).exec(value);
                },
              ),
              const SizedBox(width: blockPadding * 4.5,),
              /// Блок | Компрессор с приводом резервный
              HpuPumpWidget(
                stream: _dsClient.streamInt('HPU.EmergencyHPU.State'),
                caption: Text(const AppText('Emergency HPU').local),
                driveCaption: const AppText('M3').local,
                pumpCaption: const AppText('P3').local,
              ),
            ],
          ),
          const SizedBox(height: blockPadding * 4.5),
          /// Блок | Теплообменник
          Text(AppText('Cooler').local),
          const SizedBox(height: padding),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonContainerWidget(
                header: Text(
                  AppText('Pressure').local,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularBarIndicator(
                    min: 0,
                    max: 20,
                    size: 50.0,
                    valueUnit: 'bar',
                    stream: _dsClient.streamReal('HPU.CoolerPressureIn'),
                  ),
                ],
              ),
              const SizedBox(width: blockPadding,),
              CommonContainerWidget(
                header: Text(
                  AppText('Temp').local,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularBarIndicator(
                    min: -20,
                    max: 60,
                    size: 50.0,
                    valueUnit: '℃',
                    stream: _dsClient.streamReal('HPU.CoolerTemperatureIn'),
                  ),
                ],
              ),
              const SizedBox(width: blockPadding,),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/icons/heat-exchanger.png',
                    width: 100.0 - padding * 2,
                    height: 100.0 - padding * 2,
                    color: Theme.of(context).colorScheme.tertiary,
                    opacity: const AlwaysStoppedAnimation<double>(0.4),
                    // color: Colors.blueAccent,
                  ),
                  // Text(_pump1Caption, textAlign: TextAlign.center),
                ],
              ),
            ),
              const SizedBox(width: blockPadding,),
              CommonContainerWidget(
                disabled: false,
                // disabled: !_inUse,
                header: Text(
                  AppText('Pressure').local,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularBarIndicator(
                    min: 0,
                    max: 20,
                    size: 50.0,
                    valueUnit: 'bar',
                    stream: _dsClient.streamReal('HPU.CoolerPressureOut'),
                  ),
                ],
              ),
              const SizedBox(width: blockPadding,),
              CommonContainerWidget(
                disabled: false,
                // disabled: !_inUse,
                header: Text(
                  AppText('Temp').local,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                children: [
                  CircularBarIndicator(
                    min: -20,
                    max: 60,
                    size: 50.0,
                    valueUnit: '℃',
                    stream: _dsClient.streamReal('HPU.CoolerTemperatureOut'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
