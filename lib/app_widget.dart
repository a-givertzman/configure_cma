import 'package:crane_monitoring_app/domain/alarm/alarm_list_point.dart';
import 'package:crane_monitoring_app/domain/auth/app_user.dart';
import 'package:crane_monitoring_app/domain/auth/authenticate.dart';
import 'package:crane_monitoring_app/domain/event/event_list_data.dart';
import 'package:crane_monitoring_app/infrastructure/datasource/app_data_source.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/auth/sign_in/sign_in_page.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme_switch.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  final DsClient _dsClient;
  final AppThemeSwitch _themeSwitch;
  final EventListData<AlarmListPoint> _alarmListData;
  ///
  const AppWidget({
    Key? key,
    required AppThemeSwitch themeSwitch,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
  }) : 
    _themeSwitch = themeSwitch,
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    super(key: key);
  ///
  @override
  State<AppWidget> createState() => _AppWidgetState(
    themeSwitch: _themeSwitch,
    dsClient: _dsClient,
    alarmListData: _alarmListData,
  );
}

class _AppWidgetState extends State<AppWidget> {
  final AppThemeSwitch _themeSwitch;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  _AppWidgetState({
    required AppThemeSwitch themeSwitch,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
  }) : 
    _themeSwitch = themeSwitch,
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    super();
  ///
  @override
  void dispose() {
    _themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
  }
  @override
  void initState() {
    _themeSwitch.addListener(_themeSwitchListener);
    super.initState();
  }
  ///
  void _themeSwitchListener() {
    if (mounted) {
      setState(() {
      });
    }
  }
  ///
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(
          auth: Authenticate(
            user: AppUserSingle(
              remote: dataSource.dataSet('app-user'),
            ),
          ), 
          themeSwitch: _themeSwitch,
          dsClient: _dsClient,
          alarmListData: _alarmListData,
        ),
      initialRoute: '/signInPage',
      routes: {
        '/signInPage': (context) => SignInPage(
          auth: Authenticate(
            user: AppUserSingle(
              remote: dataSource.dataSet('app-user'),
            ),
          ),
          themeSwitch: _themeSwitch,
          dsClient: _dsClient,
          alarmListData: _alarmListData,
        ),
      },
      theme: _themeSwitch.themeData,
      // darkTheme: appThemes[AppTheme.dark],
      // themeMode: _themeSwitch.themeMode,
    );
  }
}
