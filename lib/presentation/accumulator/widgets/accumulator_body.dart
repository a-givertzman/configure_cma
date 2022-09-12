import 'dart:async';
import 'dart:math';

import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/accumulator/widgets/accumulator_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class AccumulatorBody extends StatelessWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  AccumulatorBody({
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
    log(_debug, '[$AccumulatorBody.build]');
    // const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
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
              /// Блок | Компрессор с приводом 1
              AccumulatorWidget(
                dsClient: _dsClient,
                minNitroPressure: 0,
                maxNitroPressure: 400,
                highNitroPressure: 330,
                pistonMaxLimitTagName: 'HPA.PistonMaxLimit',
                pistonMinLimitTagName: 'HPA.PistonMinLimit',
                pressureOfNitroTagName: 'HPA.NitroPressure',
                alarmNitroPressureTagName: 'HPA.AlarmNitroPressure',
                caption: Text(const AppText('High pressure accumulator').local, textAlign: TextAlign.center,),
              ),
              const SizedBox(width: blockPadding * 4,),
              /// Column 2 | Brand Icon
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/brand_icon.png',
                    scale: 4.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.2),
                  ),
                ],
              ),
              const SizedBox(width: blockPadding * 4,),
              /// Блок | Компрессор с приводом 2
              AccumulatorWidget(
                dsClient: _dsClient,
                minNitroPressure: 0,
                maxNitroPressure: 100,
                highNitroPressure: 50,
                pistonMaxLimitTagName: 'LPA.PistonMaxLimit',
                pistonMinLimitTagName: 'LPA.PistonMinLimit',
                pressureOfNitroTagName: 'LPA.NitroPressure',
                alarmNitroPressureTagName: 'LPA.AlarmNitroPressure',
                caption: Text(const AppText('Low pressure accumulator').local, textAlign: TextAlign.center,),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
