import 'dart:async';

import 'package:crane_monitoring_app/app_widget.dart';
import 'package:crane_monitoring_app/domain/alarm/alarm-data.dart';
import 'package:crane_monitoring_app/domain/alarm/alarm_list_point.dart';
import 'package:crane_monitoring_app/domain/core/error/failure.dart';
import 'package:crane_monitoring_app/infrastructure/alarm/alarm_list_data_source.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client_emulate.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client_real.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme_switch.dart';
import 'package:crane_monitoring_app/settings/communication_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  debugRepaintRainbowEnabled = false;
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded(
    () async {
      await windowManager.ensureInitialized();
      windowManager.waitUntilReadyToShow(
        WindowOptions(
          size: Size(1280, 800),
          center: true,
          backgroundColor: Colors.transparent,
          skipTaskbar: false,
          titleBarStyle: TitleBarStyle.hidden,
        ),
      )
      .then((value) async {
        await windowManager.show();
        await windowManager.focus();
      });
      // final _dsClient = DsClientEmulate(
      final _dsClient = DsClientReal(
        // ip: '192.168.0.100';
        ip: AppCommunicationSettings.dsClientIp, 
        port: AppCommunicationSettings.dsClientPort,
      );
      // setupDsClientEmulate(_dsClient);
      final _appThemeSwitch = AppThemeSwitch();
      runApp(
        AppWidget(
          themeSwitch: _appThemeSwitch,
          dsClient: _dsClient,
          alarmListData: AlarmListDataSource<AlarmListPoint>(
            stream: _dsClient.streamMerged(
              await AlarmData(assetName: 'assets/alarm/alarm-list.json').names(),
            ),
          ),
        ),
      );
    },
    (error, stackTrace) => throw Failure(
      message: '[main] error: $error', 
      stackTrace: stackTrace,
    ),
  );
}
///
///
/// настраивает эмулятор сервера потока данных
void setupDsClientEmulate(DsClientEmulate _dsClient) {
  _dsClient.streamEmulatedInt('CraneMode.MainMode',
    firstEventDelay: 5000,
    delay: 10000,
    // min: 0,
    max: 2,
  );
              // 'CraneMode.ActiveWinch',
  _dsClient.streamEmulatedInt('CraneMode.Winch1Mode',
    firstEventDelay: 5000,
    delay: 5000,
    // min: 0,
    max: 3,
  );
              // 'CraneMode.Winch1Mode',
              // 'CraneMode.Winch2Mode',
              // 'CraneMode.Winch3Mode',
  _dsClient.streamEmulatedInt('CraneMode.waveHeightLevel',
    firstEventDelay: 2000,
    delay: 3000,
    // min: 0,
    max: 3,
  );
  _dsClient.streamEmulatedInt('CraneMode.ConstantTensionLevel',
    firstEventDelay: 2000,
    delay: 3000,
    min: -1,
    max: 10,
  );
}
