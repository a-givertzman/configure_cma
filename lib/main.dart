import 'dart:async';

import 'package:configure_cma/app_widget.dart';
import 'package:configure_cma/domain/alarm/alarm-data.dart';
import 'package:configure_cma/domain/alarm/alarm_list_point.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/infrastructure/alarm/alarm_list_data_source.dart';
import 'package:configure_cma/infrastructure/stream/ds_client_real.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:configure_cma/settings/communication_settings.dart';
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
      final _appThemeSwitch = AppThemeSwitch();
      runApp(
        AppWidget(
          themeSwitch: _appThemeSwitch,
        ),
      );
    },
    (error, stackTrace) => throw Failure(
      message: '[main] error: $error', 
      stackTrace: stackTrace,
    ),
  );
}
