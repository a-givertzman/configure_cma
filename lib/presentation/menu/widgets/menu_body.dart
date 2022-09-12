import 'package:configure_cma/domain/auth/app_user_group.dart';
import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class MenuBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  /// 
  /// Builds home body using current user
  const MenuBody({
    Key? key,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) : 
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$MenuBody.build]');
    final user = _users.peek;
    // const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    // const dropDownControlButtonWidth = 118.0;
    // const dropDownControlButtonHeight = 44.0;
    final buttonTextStyle = Theme.of(context).textTheme.titleLarge;
    final buttonStyle = ButtonStyle().copyWith(
      backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
      minimumSize: MaterialStateProperty.all(const Size(240.0, 128.0)),
    );
    if (user.userGroup() == UserGroupList.admin) {

    }
    return StreamBuilder<List<dynamic>>(
      // stream: dataStream,
      builder: (context, snapshot) {
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///
                    /// Экран | Домашний
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        log(_debug, 'Экран | Домашний pressed');
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => HomePage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/homePage"),
                        //   ),
                        // ).then((_) {
                        // });                  
                      }, 
                      child: Text(
                        const AppText('Main page').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | HPU
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => HpuPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/hpuPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('HPU').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Acccumulator
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => AccumulatorPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/acumulatorPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Accumulator').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Main winch
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => Winch1Page(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/mainWinchPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Main winch').local,
                        style: buttonTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: blockPadding,),
                /// Row 2
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///
                    /// Экран | Аварии
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => AlarmPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       listData: _alarmListData,
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/alarmPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Alarm page').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | События
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => EventPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/eventPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Event page').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Уставки
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => SettingsPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/settingsPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Settings page').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Настройки приложения
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => PreferencesPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/preferencesPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Preferences page').local,
                        style: buttonTextStyle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: blockPadding,),
                /// Row 3
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    ///
                    /// Экран | Demo
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => ExhibitPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/exhibitPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Demo').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Demo1
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => Exhibit1Page(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/exhibit1Page"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Demo1').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),

                    ///
                    /// Экран | Диагностика связи
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => DiagnosticPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/diagnosticPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Диагностика связи').local,
                        style: buttonTextStyle,
                      ),
                    ),
                    const SizedBox(width: blockPadding,),
                    ///
                    /// Экран | Резера
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => EventPage(
                        //       dataSource: dataSource,
                        //       users: _users,
                        //       dsClient: _dsClient, 
                        //       themeSwitch: _themeSwitch,
                        //     ),
                        //     settings: const RouteSettings(name: "/eventPage"),
                        //   ),
                        // ).then((_) {
                        // });
                      }, 
                      child: Text(
                        const AppText('Резерв').local,
                        style: buttonTextStyle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
  //     log(_debug, '[$MenuBody._authenticate] authResult: ', authResult);
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
}
