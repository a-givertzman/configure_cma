import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:flutter/material.dart';


class AppThemeSwitch with ChangeNotifier {
  static const _debug = true;
  // final _streamController = StreamController<AppTheme>();
  late ThemeData _themeData;
  AppTheme _theme = AppTheme.dark;
  ThemeMode _themeMode = ThemeMode.light;
  ///
  AppTheme get theme => _theme;
  ///
  ThemeMode get themeMode => _themeMode;
  ///
  ThemeData get themeData => _themeData;
  ///
  AppThemeSwitch() : super() {
    log(_debug, '[$AppThemeSwitch]');
    if (appThemes.containsKey(_theme)) {
      final defaultThemeData = appThemes[_theme];
      if (defaultThemeData != null) {
        _themeData = defaultThemeData;
      } else {
        throw _unexpectedFailure();
      }
    } else {
      throw _unexpectedFailure();
    }
  }
  Failure _unexpectedFailure() {
    return Failure.unexpected(
      message: '[$AppThemeSwitch] несуществующая тема $_themeMode',
      stackTrace: StackTrace.current,
    );
  }
  ///
  void toggleMode(ThemeMode? mode) {
    if (mode != null) {
      _themeMode = mode;
    }
    notifyListeners();
  }
  ///
  void toggleTheme(AppTheme? theme) {
    log(_debug, '[$AppThemeSwitch.toggleTheme()] theme: $theme');
    if (theme != null) {
      if (appThemes.containsKey(theme)) {
        _theme = theme;
        final appTheme = appThemes[theme];
        if (appTheme != null) {
          _themeData = appTheme;
        }
      } else {
        throw _unexpectedFailure();
      }
    }
    notifyListeners();
  }
}
