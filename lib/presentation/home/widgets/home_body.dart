import 'dart:math';

import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_type.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/crane/crane_mode_state.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/infrastructure/stream/stream_mearged.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/bool_color_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/dps_icon_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/invalid_status_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/circular_bar_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/common_container_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/status_indicator_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/text_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/text_indicator_widget.dart';
import 'package:crane_monitoring_app/presentation/home/widgets/crane_load_card.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_send.dart';
import 'package:crane_monitoring_app/presentation/home/widgets/crane_mode_control_widget.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  final CraneModeState _craneModeState;
  /// 
  /// Builds home body using current user
  const HomeBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
    required CraneModeState craneModeState,
  }) : 
    _users = users,
    _dsClient = dsClient,
    _craneModeState = craneModeState,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$HomeBody.build]');
    final user = _users.peek;
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    const dropDownControlButtonWidth = 118.0;
    const dropDownControlButtonHeight = 44.0;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final stateColors = Theme.of(context).stateColors;
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_dsClient.isConnected()) {
    //     _dsClient.requestAll();
    //   }
    // });
    Future.delayed(Duration(seconds: 3), () {
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });
    return Transform.scale(
      scale: min(
        width / AppUiSettings.displaySize.width, 
        height / AppUiSettings.displaySize.height,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Row 1
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Кнопки управления режимом
                CraneModeControlWidget(
                  dsClient: _dsClient,
                  craneModeState: _craneModeState,
                  buttonWidth: dropDownControlButtonWidth,
                  buttonHeight: dropDownControlButtonHeight,
                ),
                const SizedBox(width: blockPadding,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Индикатор | Постоянное натяжение
                    StatusIndicatorWidget(
                      width: 150.0,
                      indicator: BoolColorIndicator(
                        // iconData: Icons.account_tree_outlined,
                        stream: _dsClient.streamBool('ConstantTension.Active'),
                      ), 
                      caption: Text(const AppText('Constant tension').local),
                    ),
                    /// Индикатор | Степень натяжения
                    TextIndicatorWidget(
                      width: 150.0 - 22.0,
                      indicator: TextIndicator(
                        stream: _dsClient.streamInt('ConstantTension.Level'),
                        valueUnit: '%',
                      ),
                      caption: Text(
                        const AppText('Tension factor').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),                      
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Постоянное натяжение | Убавить
                        ElevatedButton(
                          style: ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(75.0, 50.0)),
                          ),
                          onPressed: () {
                            if (_craneModeState.constantTensionLevel > 0) {
                              DsSend<int>(
                                dsClient: _dsClient, 
                                pointPath: DsPointPath(
                                  path: 'line1.ied12.db902_panel_controls', 
                                  name: 'Settings.CraneMode.ConstantTensionLevel'
                                ),
                              ).exec(_craneModeState.constantTensionLevel.toInt() - 1);
                            }
                          }, 
                          child: Icon(
                            Icons.remove, 
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        const SizedBox(width: padding,),
                        /// Постоянное натяжение | Прибавить
                        ElevatedButton(
                          style: ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(75.0, 50.0)),
                          ),
                          onPressed: () {
                            if (_craneModeState.constantTensionLevel < 100) {
                              DsSend<int>(
                                dsClient: _dsClient, 
                                pointPath: DsPointPath(
                                  path: 'line1.ied12.db902_panel_controls', 
                                  name: 'Settings.CraneMode.ConstantTensionLevel'
                                ),
                              ).exec(_craneModeState.constantTensionLevel.toInt() + 1);
                            }
                          }, 
                          child: Icon(
                            Icons.add, 
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3,),
                  ],
                ),
                const SizedBox(width: blockPadding * 3,),
                Image.asset(
                  'assets/img/brand_icon.png',
                  scale: 4.0,
                  opacity: const AlwaysStoppedAnimation<double>(0.2),
                ),
                const SizedBox(width: blockPadding * 3,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// Скорость ветра
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextIndicator(
                        stream: _dsClient.streamReal('Crane.Wind'),
                        fractionDigits: 2,
                        valueUnit: const AppText('m/c').local,
                      ),
                      caption: Text(
                        const AppText('Wind').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                    ///  Температура масла
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextIndicator(
                        stream: _dsClient.streamReal('HPU.OilTemp'),
                        fractionDigits: 0,
                        valueUnit: '℃',
                      ),
                      caption: Text(
                        const AppText('Oil temp').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                  ],
                ),
                const SizedBox(width: blockPadding,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Дифферент/ Pitch
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextIndicator(
                        stream: _dsClient.streamReal('Crane.Pitch'),
                        fractionDigits: 2,
                        valueUnit: 'º',
                      ),
                      caption: Text(
                        const AppText('Pitch').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                    /// Крен / Roll
                    TextIndicatorWidget(
                      width: 120,
                      indicator: TextIndicator(
                        stream: _dsClient.streamReal('Crane.Roll'),
                        fractionDigits: 2,
                        valueUnit: 'º',
                      ),
                      caption: Text(
                        const AppText('Roll').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.topRight, 
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: blockPadding,),
            /// Row 2
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.CraneOffshore'),
                  ), 
                  caption: Text(const AppText('Offshore').local),
                ),
                // const SizedBox(width: padding,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.ParkingModeActive'),
                  ), 
                  caption: Text(const AppText('Parking').local),
                ),
                const SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.MOPS'),
                  ), 
                  caption: Text(const AppText('MOPS').local),
                ),
                const SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.AOPS'),
                  ), 
                  caption: Text(const AppText('AOPS').local),
                ),
                const SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.AHC'),
                  ), 
                  caption: Text(const AppText('АHC').local),
                ),
                const SizedBox(width: padding * 2,),
                StatusIndicatorWidget(
                  indicator: BoolColorIndicator(
                    // iconData: Icons.account_tree_outlined,
                    stream: _dsClient.streamBool('CraneMode.WinchBrake'),
                  ), 
                  caption: Text(const AppText('Brake').local),
                ),
                const SizedBox(width: padding * 2,),
                /// Индикатор | HPU
                Tooltip(
                  child: StatusIndicatorWidget(
                    indicator: DpsIconIndicator(
                      key: GlobalObjectKey('HPU.Pump12.State'),
                      stream: StreamMerged<DsDataPoint<int>>([
                        _dsClient.streamInt('HPU.Pump1.State'),
                        _dsClient.streamInt('HPU.Pump2.State'),
                      ], handler: (values) {
                        return _buildHpuPumpStateValue(values[0]?.value, values[1]?.value);
                      },).stream,
                    ), 
                    caption: Text(const AppText('HPU').local),
                  ),
                  message: const AppText('Hydraulic power unit').local,
                ),                
                /// Индикатор | HPUR
                Tooltip(
                  child: StatusIndicatorWidget(
                    indicator: DpsIconIndicator(
                      key: GlobalObjectKey('HPU.EmergencyHPU.State'),
                      stream: _dsClient.streamInt('HPU.EmergencyHPU.State'),
                    ), 
                    caption: Text(const AppText('HPUR').local),
                  ),
                  message: const AppText('Emergency hydraulic power unit').local,
                ),                
                // AlarmedStatusIndicatorWidget(
                //   stateIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).primaryColor,
                //     stream: StreamMergedOr([
                //       _dsClient.streamBool('HPU.Pump1.Active'),
                //       _dsClient.streamBool('HPU.Pump2.Active'),
                //     ]).stream,
                //   ),
                //   alarmIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).highColor,
                //     falseColor: Colors.transparent,
                //     stream: StreamMergedOr([
                //       _dsClient.streamBool('HPU.Pump1.Alarm'),
                //       _dsClient.streamBool('HPU.Pump2.Alarm'),
                //     ]).stream,
                //   ), 
                //   caption: Text(const AppText('HPU').local), 
                // ),
                // AlarmedStatusIndicatorWidget(
                //   stateIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).primaryColor,
                //     stream: _dsClient.streamBool('HPU.EmergencyHPU.Active'),
                //   ),
                //   alarmIndicator: BoolColorIndicator(
                //     trueColor: Theme.of(context).highColor,
                //     falseColor: Colors.transparent,
                //     stream: _dsClient.streamBool('HPU.EmergencyHPU.Alarm'),
                //   ), 
                //   caption: Text(const AppText('HPUR').local), 
                // ),
                // const SizedBox(width: padding * 2,),
                // /// Индикатор | Связь
                // StatusIndicatorWidget(
                //   indicator: SpsIconIndicator(
                //     trueIcon: Icon(Icons.account_tree_sharp, color: stateColors.on),
                //     falseIcon: Icon(Icons.account_tree_outlined, color: stateColors.off),
                //     stream: _dsClient.streamBool('Local.System.Connection')
                //       .map((event) {
                //         log(_debug, '[$HomeBody] Local.System.Connection: ', event.value);
                //         return event;
                //       }),
                //   ), 
                //   caption: Text(const AppText('Connection').local), 
                // ),
              ],
            ),
            const SizedBox(height: blockPadding,),
            /// Row 3
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Row 3 | Column 1
                Column(children: [
                  TextIndicatorWidget(
                    width: 216,
                    indicator: TextIndicator(
                      stream: _dsClient.streamReal('Winch1.SWL'),
                      fractionDigits: 1,
                      valueUnit: const AppText('t').local,
                    ),
                    caption: Text(
                      const AppText('SWL').local,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    alignment: Alignment.centerLeft, 
                  ),
                  TextIndicatorWidget(
                    width: 216,
                    indicator: TextIndicator(
                      stream: _dsClient.streamReal('Winch1.Load'),
                      fractionDigits: 1,
                      valueUnit: const AppText('t').local,
                    ),
                    caption: Text(
                      const AppText('Load').local,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    alignment: Alignment.centerLeft, 
                  ),
                  InvalidStatusIndicator(
                    stream: _loadFactorStream([
                      _dsClient.streamReal('Winch1.SWL'),
                      _dsClient.streamReal('Winch1.Load'),
                    ]),
                    stateColors: stateColors,
                    child: CommonContainerWidget(
                      header: Text(
                        const AppText('% of SWL').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      children: [CircularBarIndicator(
                        user: user,
                        low: 20,
                        high: 80,
                        stream: _loadFactorStream([
                          _dsClient.streamReal('Winch1.SWL'),
                          _dsClient.streamReal('Winch1.Load'),
                        ]),
                        valueUnit: '%',
                        size: 200.0,
                      ),],
                    ),
                  ),
                ],),
                const SizedBox(width: blockPadding,),
                /// Row 3 | Column 2
                CraneLoadCard(
                  dsClient: _dsClient,
                ),
                const SizedBox(width: blockPadding,),
                /// Row 3 | Column 1 | Row 1 | Column 2
                Column(children: [
                    Tooltip(
                      message: AppText('Absolute depth').local,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextIndicator(
                          key: GlobalObjectKey('Crane.Depth'),
                          stream: _dsClient.streamReal('Crane.Depth'),
                          valueUnit: const AppText('m').local,
                          fractionDigits: 1,
                        ),
                        caption: Text(
                          const AppText('Depth abs').local,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    /// Относительная глубина | Индикатор
                    Row(
                      children: [
                        Tooltip(
                          message: AppText('Relative depth').local,
                          child: TextIndicatorWidget(
                            width: 216 - 48 * 2 + padding,
                            indicator: TextIndicator(
                              key: GlobalObjectKey('Crane.DeckDepth'),
                              stream: _dsClient.streamReal('Crane.DeckDepth'),
                              valueUnit: const AppText('m').local,
                              fractionDigits: 1,
                            ),
                            caption: Text(
                              const AppText('Rel depth').local,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            alignment: Alignment.centerLeft, 
                          ),
                        ),
                        /// Относительная глубина | Установить
                        ElevatedButton(
                          style: ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            maximumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          onPressed: () {
                            DsSend<int>(
                              dsClient: _dsClient, 
                              pointPath: DsPointPath(
                                path: 'line1.ied12.db902_panel_controls', 
                                name: 'Settings.CraneMode.SetRelativeDepth',
                              ),
                            ).exec(1);
                          }, 
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        const SizedBox(width: padding * 0.5),
                        /// Относительная глубина | Сбросить
                        ElevatedButton(
                          style: ButtonStyle().copyWith(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            minimumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            maximumSize: MaterialStateProperty.all(const Size(48.0, 48.0)),
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                          ),
                          onPressed: () {
                            DsSend<int>(
                              dsClient: _dsClient, 
                              pointPath: DsPointPath(
                                path: 'line1.ied12.db902_panel_controls', 
                                name: 'Settings.CraneMode.ResetRelativeDepth',
                              ),
                            ).exec(1);                          }, 
                          child: Icon(
                            Icons.cancel_outlined, 
                            color: Theme.of(context).textTheme.bodyLarge!.color,
                          ),
                        ),
                        const SizedBox(width: padding * 0.5),
                      ],
                    ),
                    TextIndicatorWidget(
                      width: 216,
                      indicator: TextIndicator(
                        stream: _dsClient.streamReal('Hook.Speed'),
                        valueUnit: const AppText('m/min').local,
                        fractionDigits: 1,
                      ),
                      caption: Text(
                        const AppText('Hook speed').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.centerLeft, 
                    ),
                    // Row(
                    //   children: [
                    //     /// Индикатор | Скорость высокая
                    //     SingleStatusIndicatorWidget(
                    //     width: 118.0,
                    //       indicator: BoolColorIndicator(
                    //         trueColor: Theme.of(context).highColor,
                    //         stream: _dsClient.streamBool('Other.Hook.HighSpeed'),
                    //       ), 
                    //       caption: Text(const AppText('High').local), 
                    //     ),
                    //     /// Индикатор | Скорость посадочная
                    //     SingleStatusIndicatorWidget(
                    //       width: 118.0,
                    //       indicator: BoolColorIndicator(
                    //         stream: _dsClient.streamBool('Other.Hook.LandingSpeed'),
                    //       ), 
                    //       caption: Text(const AppText('Landing').local), 
                    //     ),
                    //   ],
                    // ),                          
                    const SizedBox(height: blockPadding,),
                    Tooltip(
                      message: const AppText('Main boom angle').local,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextIndicator(
                          key: GlobalObjectKey('Crane.BoomAngle'),
                          stream: _dsClient.streamReal('Crane.BoomAngle'),
                          valueUnit: const AppText('º').local,
                        ),
                        caption: Text(
                          const AppText('Main boom').local,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    Tooltip(
                      message: AppText('Knuckle jib angle').local,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextIndicator(
                          key: GlobalObjectKey('Crane.JibAngle'),
                          stream: _dsClient.streamReal('Crane.JibAngle'),
                          valueUnit: const AppText('º').local,
                        ),
                        caption: Text(
                          const AppText('Knukle jib').local,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    Tooltip(
                      message: AppText('Crane slewing angle').local,
                      child: TextIndicatorWidget(
                        width: 216,
                        indicator: TextIndicator(
                          key: GlobalObjectKey('Crane.Slewing'),
                          stream: _dsClient.streamReal('Crane.Slewing'),
                          valueUnit: const AppText('º').local,
                        ),
                        caption: Text(
                          const AppText('Slewing').local,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.centerLeft, 
                      ),
                    ),
                    TextIndicatorWidget(
                      width: 216,
                      indicator: TextIndicator(
                        stream: _dsClient.streamReal('Crane.Radius'),
                        valueUnit: const AppText('m').local,
                      ),
                      caption: Text(
                        const AppText('Radius').local,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      alignment: Alignment.centerLeft, 
                    ),
                ],),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Stream<DsDataPoint<double>> _loadFactorStream(List<Stream<DsDataPoint<double>>> streams) {
    return StreamMerged<DsDataPoint<double>>(
      streams, 
      handler: (values) {
        final winch1SwlValue = values[0];
        final winch1LoadValue = values[1];
        if (winch1SwlValue != null && winch1LoadValue != null) {
          return DsDataPoint(
            type: DsDataType.real(),
            path: '', name: '',
            value: 100 * (winch1LoadValue.value / winch1SwlValue.value),
            status: DsStatus.ok(),
            timestamp: DateTime.now().toIso8601String(),
          );
        }
        return DsDataPoint(
          type: DsDataType.real(),
          path: '', name: '',
          value: 0.0,
          status: DsStatus.invalid(),
          timestamp: DateTime.now().toIso8601String(),
        );
      },
    ).stream;
  }
  ///
  DsDataPoint<int> _buildHpuPumpStateValue(
    int? pump1State, 
    int? pump2State
  ) {
    int value = 0;
    if (pump1State != null && pump2State != null) {
      if (pump1State == 1 && pump2State == 1) {
        value = 1;
      }
      if (pump1State == 2 || pump2State == 2) {
        value = 2;
      }
      if (pump1State == 0 || pump2State == 0) {
        value = 0;
      }
      if (pump1State == 3 || pump2State == 3) {
        value = 3;
      }
    }
    return DsDataPoint<int>(
      type: DsDataType.int(), 
      path: '', name: '', 
      value: value, 
      status: DsStatus.ok(), 
      timestamp: DateTime.now().toIso8601String(),
    );
  }
  ///
  // Future<AuthResult> _authenticate(BuildContext context) {
  //   return Navigator.of(context).push<AuthResult>(
  //     MaterialPageRoute(
  //       builder: (context) => AuthDialog(
  //         key: UniqueKey(),
  //         currentUser: _users.peek,
  //       ),
  //       settings: const RouteSettings(name: "/authDialog"),
  //     ),
  //   ).then((authResult) {
  //     log(_debug, '[$HomeBody._authenticate] authResult: ', authResult);
  //     final result = authResult;
  //     if (result != null) {
  //       if (result.authenticated) {
  //         _users.push(result.user);
  //       }
  //       return result;
  //     }
  //     throw Failure.unexpected(
  //       message: 'Authentication error, null returned instead of AuthResult ', 
  //       stackTrace: StackTrace.current,
  //     );
  //   });    
  // }
  ///
  // Future<DsDataPoint<int>> _sendIntCmd({required String name, required num value}) {
  //   final path = 'line1.ied12.db902_panel_controls';
  //   log(_debug, '[$HomeBody._sendIntCmd] path: $path\tname: $name\tvalue: $value');
  //   return DsSend<int>(
  //     dsClient: _dsClient,
  //     pointPath: DsPointPath(path: path, name: name),
  //   ).exec(value.toInt());
  //   // _dsClient.send(
  //   //   dsClass: DsDataClass.commonCmd(), 
  //   //   type: DsDataType.int(), 
  //   //   path: 'line1.ied12.db902_panel_controls', 
  //   //   name: name, 
  //   //   value: value, 
  //   //   status: DsStatus.ok(),
  //   //   timestamp: DateTime.now(),
  //   // );
  // }
}
