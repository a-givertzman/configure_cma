import 'dart:async';

import 'package:configure_cma/app_widget.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:window_manager/window_manager.dart';

void main() {
  debugRepaintRainbowEnabled = false;
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await windowManager.ensureInitialized();
      windowManager.waitUntilReadyToShow(
        WindowOptions(
          // size: Size(1280, 800),
          // center: true,
          backgroundColor: Colors.transparent,
          // skipTaskbar: false,
          // titleBarStyle: TitleBarStyle.hidden,
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
