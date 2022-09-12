import 'package:configure_cma/domain/core/log/log.dart';
import 'package:flutter/material.dart';

class AppNav {
  static const _debug = false;
  AppNav();
  static void logout(BuildContext context) {
    Navigator.of(context).popUntil((route) {
      log(_debug, 'route:', route.settings.name); 
      return route.settings.name == '/signInPage';
    });
  }
}
