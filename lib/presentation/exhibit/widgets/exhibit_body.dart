import 'dart:math';

import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/infrastructure/stream/stream_mearged.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/sps_icon_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/linear_bar_indicator.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/live_chart_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/status_indicator_widget.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

class ExhibitBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  final List<double> _trace1 = [];
  final List<double> _trace2 = [];
  /// 
  /// Builds home body using current user
  ExhibitBody({
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
    log(_debug, '[$ExhibitBody.build]');
    final user = _users.peek;
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _dsClient.requestAll();
    });
    return StreamBuilder<DsDataPoint<double>>(
      stream: StreamMerged<DsDataPoint<double>>([
        _dsClient.streamReal('HookPosition.x'),
        _dsClient.streamReal('HookPosition.y'),
      ]).stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final point = snapshot.data;
          if (point != null) {
            if (point.name == 'HookPosition.x') {
              _trace1.add(point.value);
            }
            if (point.name == 'HookPosition.y') {
              _trace2.add(point.value);
            }
          }
        }
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: () {
            return Future<List<String>>.value([]);
            // return source.refresh();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Row 1
                Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 94.0),
                      const Expanded(child: Text('')),
                      Image.asset(
                        'assets/img/brand_icon.png',
                        scale: 9.0,
                        opacity: const AlwaysStoppedAnimation<double>(0.5),
                      ),
                      const Expanded(child: Text('')),
                      // Expanded(child: Text(const AppText('Demo').local,)),
                      /// Кнопки управления режимом
                      // const SizedBox(width: blockPadding,),
                      // TextIndicatorWidget(
                      //   indicator: TextIndicator(
                      //     stream: _dsClient.streamReal('HookPosition.x'),
                      //   ), 
                      //   caption: const Text('HookPosition.x'), 
                      //   alignment: Alignment.topCenter,
                      // ),
                      // const SizedBox(width: blockPadding,),
                      /// Индикатор | Связь
                      StatusIndicatorWidget(
                        indicator: SpsIconIndicator(
                          trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                          falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).backgroundColor),
                          stream: _dsClient.streamBool('Local.System.Connection'),
                        ), 
                        caption: Text(const AppText('Connection').local), 
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: blockPadding,),
                /// Row 2
                // Expanded(
                //   flex: 1, 
                //   child: Card(
                //     child: LiveChartWidget(
                      // caption: 'Частота вращения',
                //       yInterval: 1000.0,
                //       xInterval: 2000,
                //       minY: -3000.0, 
                //       maxY: 3000.0,
                //       stream: _dsClient.streamReal('Drive.Speed'),
                //       axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                //     ),
                //   ),
                // ),
                // const SizedBox(height: blockPadding,),
                // Row 3
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                        Expanded(
                          child: Card(
                            child: LiveChartWidget(
                              caption: 'AC Voltage',
                              yInterval: 100.0,
                              xInterval: 5000.0,
                              minY: 0.0, 
                              maxY: 400.0,
                              stream: _dsClient.streamReal('Drive.OutputVoltage'),
                              axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                            ),
                          ),
                        ),
                        const SizedBox(height: blockPadding,),
                        Expanded(
                          child: Card(
                            child: LiveChartWidget(
                              caption: 'DC Voltage',
                              yInterval: 100.0,
                              xInterval: 5000.0,
                              minY: 0.0, 
                              maxY: 700.0,
                              stream: _dsClient.streamReal('Drive.DCVoltage'),
                              axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                            ),
                          ),
                        ),
                          ],
                        ),
                      ),
                      const SizedBox(width: blockPadding,),
                      // Row 3
                      Expanded(
                        child: Card(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/img/ac_dc_converter.png',
                                    scale: 1.2,
                                    color: Colors.white,
                                    opacity: const AlwaysStoppedAnimation<double>(0.5),
                                  ),
                                  Image.asset(
                                    'assets/img/ac_motort_lr.png',
                                    scale: 2.5,
                                    color: Colors.white,
                                    opacity: const AlwaysStoppedAnimation<double>(0.5),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StatusIndicatorWidget(
                                    caption: const Text(''),
                                    indicator: SpsIconIndicator(
                                      stream: _dsClient.streamBool('ChargeIn.On'),
                                      trueIcon: Icon(
                                        Icons.arrow_right_alt,
                                        color: Theme.of(context).primaryColor,
                                        size: 90.0,
                                      ),
                                      falseIcon: Icon(
                                        Icons.arrow_right_alt,
                                        color: Theme.of(context).backgroundColor,
                                        size: 90.0,
                                      ),
                                    ), 
                                  ),
                                  Transform.rotate(
                                    angle: pi,
                                    child: StatusIndicatorWidget(
                                      caption: const Text(''),
                                      indicator: SpsIconIndicator(
                                        stream: _dsClient.streamBool('ChargeOut.On'),
                                        trueIcon: Icon(
                                          Icons.arrow_right_alt,
                                          color: Theme.of(context).primaryColor,
                                          size: 90.0,
                                        ),
                                        falseIcon: Icon(
                                          Icons.arrow_right_alt,
                                          color: Theme.of(context).backgroundColor,
                                          size: 90.0,
                                        ),
                                      ), 
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image.asset(
                                    'assets/img/сapacitor_v.png',
                                    scale: 1.2,
                                    color: Colors.white,
                                    opacity: const AlwaysStoppedAnimation<double>(0.5),
                                  ),
                                  const SizedBox(height: padding,),
                                  FittedBox(
                                    child: LinearBarIndicator(
                                      user: user,
                                      stream: _dsClient.streamReal('Capacitor.Capacity'),
                                      max: 102,
                                      angle: -90,
                                      indicatorLength: 90,
                                      strokeWidth: 90,
                                      width: 100.0,
                                      height: 170.0,
                                    ),
                                  ),
                                ],
                              ),
                              // Text('Суперконденсатор'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: blockPadding,),                // Row 3
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: LiveChartWidget(
                            caption: 'Ток двигателя',
                            yInterval: 0.2,
                            xInterval: 5000.0,
                            minY: 0.0, 
                            maxY: 1.5,
                            stream: _dsClient.streamReal('Drive.Current'),
                            axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          ),
                        ),
                      ),
                      const SizedBox(width: blockPadding,),
                      // Row 3
                      Expanded(
                        child: Card(
                          child: LiveChartWidget(
                            caption: 'Мощность',
                            yInterval: 0.2,
                            xInterval: 5000.0,
                            minY: -0.5, 
                            maxY: 0.5,
                            stream: _dsClient.streamReal('Drive.Torque'),
                            axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
