import 'package:crane_monitoring_app/domain/auth/app_user_group.dart';
import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/crane/crane_mode_state.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/alarmed_status_indicator_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/bool_color_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/sps_icon_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/circular_bar_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/common_container_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/button/drop_down_control_button/drop_down_control_button.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/edit_field/network_edit_field.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/status_indicator_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/text_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/text_indicator_widget.dart';
import 'package:crane_monitoring_app/presentation/home/widgets/crane_load_card.dart';
import 'package:flutter/material.dart';

class DemoBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  // ignore: unused_field
  final DsClient _dsClient;
  // final DropDownControlButtonNotifier _dropDownControlButtonNotifier = DropDownControlButtonNotifier();
  // final CraneModeState _craneModeState;
  /// 
  /// Builds home body using current user
  const DemoBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
    required CraneModeState craneModeState,
  }) : 
    _users = users,
    _dsClient = dsClient,
    // _craneModeState = craneModeState,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$DemoBody.build]');
    final user = _users.peek;
    const dropDownControlButtonWidth = 118.0;
    const dropDownControlButtonHeight = 44.0;
    return StreamBuilder<List<dynamic>>(
      // stream: dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: () {
            return Future<List<String>>.value([]);
            // return source.refresh();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Кнопки управления режимом
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Селектор | Режим работы крана
                        DropDownControlButton(
                          width: dropDownControlButtonWidth,
                          height: dropDownControlButtonHeight,
                          tooltip: const AppText('Select crane mode').local,
                          label: const AppText('Mode').local,
                          items: {
                            1: const AppText('Harbour').local,
                            2: const AppText('In sea').local,
                          },
                        ),
                        const SizedBox(height: 8.0,),
                        /// Селектор | Режим работы лебедки
                        DropDownControlButton(
                          width: dropDownControlButtonWidth,
                          height: dropDownControlButtonHeight,
                          tooltip: const AppText('Select winch mode').local,
                          label: const AppText('Winch').local,
                          items: {
                            1: const AppText('Freight').local,
                            2: const AppText('AHC').local,
                            3: const AppText('Manriding').local,
                          }
                        ),
                        const SizedBox(height: 8.0,),
                        /// Селектор | Уровень высоты волны
                        DropDownControlButton(
                          width: dropDownControlButtonWidth,
                          height: dropDownControlButtonHeight,
                          tooltip: const AppText('Select wave hight level').local,
                          label: const AppText('SWH').local,
                          items: {
                            1: '0.1 m',
                            2: '1.25 m',
                            3: '2.0 m',
                          },
                        ),
                      ],
                    ),
                  ),
                  /// Индикаторы
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Индикатор | Скорость высокая
                      SizedBox(
                        width: 150.0,
                        child: StatusIndicatorWidget(
                          indicator: BoolColorIndicator(
                            trueColor: Theme.of(context).stateColors.highLevel,
                            stream: _dsClient.streamBoolEmulated('BoolInd1',
                              delay: 1000,
                            ),
                          ), 
                          caption: const Text('Сорость выс'), 
                        ),
                      ),
                      /// Индикатор | Скорость посадочная
                      SizedBox(
                        width: 150.0,
                        child: StatusIndicatorWidget(
                          indicator: BoolColorIndicator(
                            stream: _dsClient.streamBoolEmulated('BoolInd2',
                              delay: 2000,
                            ),
                          ), 
                          caption: const Text('Скорость пос'), 
                        ),
                      ),
                      /// Индикатор | Постоянное натяжение
                      SizedBox(
                        width: 150.0,
                        child: StatusIndicatorWidget(
                          indicator: BoolColorIndicator(
                            // iconData: Icons.account_tree_outlined,
                            stream: _dsClient.streamBoolEmulated('BoolInd3',
                              delay: 3000,
                            ),
                          ), 
                          caption: const Text('Пост натяж'), 
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Скорость ветра
                      TextIndicatorWidget(
                        width: 120,
                        indicator: TextIndicator(
                          stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR111',
                            delay: 300,
                          ),
                          fractionDigits: 2,
                          valueUnit: const AppText('m/c').local,
                        ),
                        caption: Text(
                          'Скорость ветра',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.topRight, 
                      ),
                      ///  Температура масла
                      TextIndicatorWidget(
                        width: 120,
                        indicator: TextIndicator(
                          stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR111',
                            delay: 300,
                          ),
                          fractionDigits: 2,
                          valueUnit: '℃',
                        ),
                        caption: Text(
                          'Температура масла',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.topRight, 
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Дифферент/ Pitch
                      TextIndicatorWidget(
                        width: 120,
                        indicator: TextIndicator(
                          stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR111',
                            delay: 300,
                          ),
                          fractionDigits: 2,
                          valueUnit: 'º',
                        ),
                        caption: Text(
                          'Дифферент',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.topRight, 
                      ),
                      /// Крен / Roll
                      TextIndicatorWidget(
                        width: 120,
                        indicator: TextIndicator(
                          stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR111',
                            delay: 300,
                          ),
                          fractionDigits: 2,
                          valueUnit: 'º',
                        ),
                        caption: Text(
                          'Крен',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        alignment: Alignment.topRight, 
                      ),
                    ],
                  ),
                  CommonContainerWidget(
                    header: const Text('EncoderBR2'),
                    children: [CircularBarIndicator(
                      valueUnit: 'T',
                      user: user,
                      min: 15,
                      max: 105,
                      angle: 180,
                      low: 30,
                      high: 80,
                      stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR2',
                        delay: 50,
                        min:  15,
                        max: 105,
                      ),
                      size: 80.0,
                    ),],
                  ),
                  CommonContainerWidget(
                    header: const Text('EncoderBR3'),
                    children: [CircularBarIndicator(
                      user: user,
                      angle: 225,
                      stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR3',
                        delay: 10,
                      ),
                      valueUnit: 'mm',
                      size: 80.0,
                    ),],
                  ),
                  CommonContainerWidget(
                    header: const Text('EncoderBR4'),
                    children: [CircularBarIndicator(
                      user: user,
                      angle: 315,
                      low: 20,
                      high: 80,
                      stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR4',
                        // delay: 100,
                      ),
                      // valueUnit: '%',
                      size: 100.0,
                    ),],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonContainerWidget(
                        width: 250.0,
                        height: 150.0,
                        children: [
                          NetworkEditField(
                            users: _users,
                            labelText: 'Enter some text 1',
                            dsClient: _dsClient,
                            writeTagName: DsPointPath(path: '', name: 'Settings.p1'),
                          ),
                          NetworkEditField(
                            users: _users,
                            allowedGroups: const [UserGroupList.admin],
                            dsClient: _dsClient,
                            writeTagName: DsPointPath(path: '', name: 'Settings.p2'),
                            labelText: 'Enter some text 2',
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // CommonContainer(
                  //   width: 130.0,
                  //   height: 230.0,
                  //   header: const Text('Analog Sensors\nWinch',
                  //     textAlign: TextAlign.center,
                  //     textScaleFactor: 1.2,
                  //   ),
                  //   children: [
                  //     CircularBarIndicator(
                  //       title: 'EncoderBR1',
                  //       width: 60.0,
                  //       height: 60.0,
                  //       min: 15,
                  //       max: 105,
                  //       low: 30,
                  //       high: 80,
                  //       user: _user,
                  //       stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR1',
                  //         delay: 50,
                  //         min:  15,
                  //         max: 105,
                  //       ),
                  //       // fractionDigits: 1,
                  //       valueUnit: '%',
                  //     ),
                  //     CircularBarIndicator(
                  //       title: 'EncoderBR2',
                  //       width: 60.0,
                  //       height: 60.0,
                  //       user: _user,
                  //       stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR2'),
                  //       valueUnit: 'A',
                  //     ),
                  //   ],
                  // ),
                  Column(
                    children: [
                      CommonContainerWidget(
                        header: const Text('EncoderBR5'),
                        children: [CircularBarIndicator(
                          user: user,
                          angle: 315,
                          low: 20,
                          high: 80,
                          stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR5',
                            // delay: 100,
                          ),
                          valueUnit: '%',
                          size: 200.0,
                        ),],
                      ),
                      Row(children: [
                        TextIndicatorWidget(
                          width: 95,
                          indicator: TextIndicator(
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR111',
                              delay: 300,
                            ),
                            fractionDigits: 2,
                            valueUnit: 'm',
                          ),
                          caption: Text(
                            'EncoderBR111',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.topLeft, 
                        ),
                        TextIndicatorWidget(
                          width: 95,
                          indicator: TextIndicator(
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR112',
                              delay: 2000,
                            ),
                            fractionDigits: 2,
                          ),
                          caption: Text(
                            'EncoderBR112',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.topCenter, 
                        ),
                        TextIndicatorWidget(
                          width: 125,
                          indicator: TextIndicator(
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR113',
                              delay: 1000,
                            ),
                            fractionDigits: 6,
                          ),
                          caption: Text(
                            'EncoderBR113',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.topRight, 
                        ),
                      ],),
                      Row(children: [
                        TextIndicatorWidget(
                          width: 150,
                          indicator: TextIndicator(
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR111',
                              delay: 300,
                            ),
                            fractionDigits: 1,
                          ),
                          caption: Text(
                            'EncoderBR111.2',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.centerLeft, 
                        ),
                        TextIndicatorWidget(
                          width: 155,
                          indicator: TextIndicator(
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR113',
                              delay: 1000,
                            ),
                            fractionDigits: 1,
                          ),
                          caption: Text(
                            'EncoderBR113.2',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.centerRight, 
                        ),
                      ],),
                      Row(children: [
                        TextIndicatorWidget(
                          width: 95,
                          indicator: TextIndicator(
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR111.3',
                              delay: 300,
                            ),
                            fractionDigits: 2,
                          ),
                          caption: Text(
                            'EncoderBR111.3',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.bottomLeft, 
                        ),
                        TextIndicatorWidget(
                          width: 95,
                          indicator: TextIndicator(
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR112.3',
                              delay: 2000,
                            ),
                            fractionDigits: 2,
                          ),
                          caption: Text(
                            'EncoderBR112.3',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.bottomCenter, 
                        ),
                        TextIndicatorWidget(
                          width: 95,
                          indicator: TextIndicator(
                            low: 20,
                            high: 70,
                            stream: _dsClient.streamEmulated('AnalogSensors.Winch.EncoderBR113.3',
                              delay: 1000,
                            ),
                            fractionDigits: 2,
                          ),
                          caption: Text(
                            'EncoderBR113.3',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          alignment: Alignment.bottomRight, 
                        ),
                      ],),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          AlarmedStatusIndicatorWidget(
                            stateIndicator: BoolColorIndicator(
                              stream: _dsClient.streamBoolEmulated('BoolInd4',
                                delay: 6000,
                              ),
                            ), 
                            alarmIndicator: BoolColorIndicator(
                              trueColor: Theme.of(context).errorColor,
                              falseColor: Colors.transparent,
                              stream: _dsClient.streamBoolEmulated('BoolInd4.1',
                                delay: 2000,
                              ),
                            ), 
                            caption: const Text('Индикатор 4'), 
                          ),
                          StatusIndicatorWidget(
                            indicator: BoolColorIndicator(
                              stream: _dsClient.streamBoolEmulated('BoolInd5',
                                delay: 5000,
                              ),
                            ), 
                            caption: const Text('Индикатор 5'), 
                          ),
                          StatusIndicatorWidget(
                            indicator: SpsIconIndicator(
                              trueIcon: Icon(Icons.accessibility_new, color: Colors.green[300]),
                              falseIcon: Icon(Icons.accessibility_new, color: Theme.of(context).backgroundColor),
                              stream: _dsClient.streamBoolEmulated('BoolInd6',
                                delay: 6000,
                              ),
                            ), 
                            caption: const Text('Индикатор 5'), 
                          ),
                        ],
                      ),
                      CraneLoadCard(
                        dsClient: _dsClient,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
