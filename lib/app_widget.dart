import 'package:configure_cma/domain/auth/app_user.dart';
import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/auth/authenticate.dart';
import 'package:configure_cma/infrastructure/datasource/app_data_source.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:configure_cma/presentation/home/home_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  final AppThemeSwitch _themeSwitch;
  ///
  const AppWidget({
    Key? key,
    required AppThemeSwitch themeSwitch,
  }) : 
    _themeSwitch = themeSwitch,
    super(key: key);
  ///
  @override
  State<AppWidget> createState() => _AppWidgetState(
    themeSwitch: _themeSwitch,
  );
}

///
class _AppWidgetState extends State<AppWidget> {
  final AppThemeSwitch _themeSwitch;
  late AppUserStacked _appUserStacked;
  _AppWidgetState({
    required AppThemeSwitch themeSwitch,
  }) : 
    _themeSwitch = themeSwitch,
    super();
  ///
  @override
  void dispose() {
    _themeSwitch.removeListener(_themeSwitchListener);
    super.dispose();
  }
  @override
  void initState() {
    _appUserStacked = AppUserStacked(
      appUser: Authenticate(
        user: AppUserSingle.guest()
      ).getUser(),
    );
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
      home: HomePage(
        dataSource: dataSource,
        users: _appUserStacked,
        themeSwitch: _themeSwitch,
      ),
      initialRoute: '/homePage',
      routes: {
        '/homePage': (context) => HomePage(
          dataSource: dataSource,
          users: _appUserStacked,
          themeSwitch: _themeSwitch,
        ),        
        // '/signInPage': (context) => SignInPage(
        //   auth: Authenticate(
        //     user: AppUserSingle(
        //       remote: dataSource.dataSet('app-user'),
        //     ),
        //   ),
        //   themeSwitch: _themeSwitch,
        // ),
      },
      theme: _themeSwitch.themeData,
      // darkTheme: appThemes[AppTheme.dark],
      // themeMode: _themeSwitch.themeMode,
    );
  }
}
