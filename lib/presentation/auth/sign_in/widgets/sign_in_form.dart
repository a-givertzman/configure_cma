import 'package:another_flushbar/flushbar_helper.dart';
import 'package:crane_monitoring_app/domain/alarm/alarm_list_point.dart';
import 'package:crane_monitoring_app/domain/auth/app_user.dart';
import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/auth/auth_result.dart';
import 'package:crane_monitoring_app/domain/auth/authenticate.dart';
import 'package:crane_monitoring_app/domain/auth/user_login.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/event/event_list_data.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/auth/register_user/register_user_page.dart';
import 'package:crane_monitoring_app/presentation/auth/sign_in/user_pass_page.dart';
import 'package:crane_monitoring_app/presentation/auth/sign_in/widgets/user_login_widget.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme_switch.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:crane_monitoring_app/presentation/menu/menu_page.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
class SignInForm extends StatefulWidget {
  final Authenticate _auth;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  final AppThemeSwitch _themeSwitch;
  ///
  const SignInForm({
    Key? key,
    required Authenticate auth,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
    required AppThemeSwitch themeSwitch,
  }) : 
    _auth = auth,
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    _themeSwitch = themeSwitch,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<SignInForm> createState() => _SignInFormState(
    auth: _auth,
    dsClient: _dsClient,
    alarmListData: _alarmListData,
    themeSwitch: _themeSwitch,
  );
}

///
class _SignInFormState extends State<SignInForm> {
  static const _debug = true;
  final Authenticate _auth;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  final AppThemeSwitch _themeSwitch;
  late UserLogin _userLogin;
  bool _isLoading = true;
  // late UserPassword _userPassword;
  ///
  _SignInFormState({
    required Authenticate auth,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
    required AppThemeSwitch themeSwitch,
  }) :
    _auth = auth,
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    _themeSwitch = themeSwitch,
    _userLogin = const UserLogin(value: '');
  ///
  @override
  void initState() {
    // if (_debug) {
    //   final user = _auth.getUser();
    //   user.fetchByLogin('anton.lobanov1')
    //     .then((value) {
    //       _setAuthState(
    //         AuthResult(
    //           authenticated: true,
    //           message: 'Authenticated automaticali in the debug mode',
    //           user: user,
    //         ), 
    //         true,
    //       );
    //     },);
    //   super.initState();
    //   return;
    // }
    _isLoading = true;
    _auth
      .authenticateIfStored()
      .then((authResult) {
        if (authResult.authenticated) {
          _setAuthState(authResult, true);
        }
        setState(() => _isLoading = false);
      });
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      log(_debug, '[_SignInFormState.build] _isLoading!!!');
      return InProgressOverlay(
        isSaving: true,
        message: const AppText('Loading...').local,
      );
    } else {
      return _buildSignInWidget(context);
    }
  }
  ///
  Widget _buildSignInWidget(BuildContext context) {
    log(_debug, '[_SignInFormState._buildSignInWidget]');
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.padding;
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Padding(
        padding: const EdgeInsets.all(blockPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: SizedBox.shrink()),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          const AppText('Crane monitoring').local,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: padding),
                        Text(
                          const AppText('Welcome').local,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          const AppText('Please authenticate to continue...').local,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: padding),
                        UserLoginWidget(
                          userLogin: _userLogin,
                          onCompleted: (userLogin) {
                            _userLogin = userLogin;
                            _tryFindUser(userLogin);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: SizedBox.shrink(),),
          ],
        ),
      ),
    );
  }
  /// ищем пользователя в базе по логину / номеру телефона
  void _tryFindUser(UserLogin userLogin) {
    setState(() => _isLoading = true);
    final user = _auth.getUser();
    if (userLogin.value() == 'guest') {
      _setAuthState(
        _auth.authenticateGuest(), 
        _auth.authenticated(),
      );
    } else {
      _auth.fetchByLogin(userLogin.value())
        .then((authResult) {
          log(_debug, '[_tryFindUser] user: ', user);
          setState(() => _isLoading = false);
          if (authResult.authenticated) {
            if (user.exists()) {
              // вход после проверки по смс-коду или паролю
              _showUserIdPage(_userLogin, user);
            } else {
              // регистрация нового пользователя
              // _tryRegister(_userLogin);
              _showFlushBar(
                '${authResult.message}\n\n${const AppText('User not found').local}.\n',
              );
            }
          } else {
            _showFlushBar(
              authResult.message,
            );
          }
        });
    }
  }
  ///
  void _showUserIdPage(UserLogin userlogin, AppUserSingle user) {
    Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => UserPassPage(
          user: user,
          userLogin: userlogin,
        ),
        settings: const RouteSettings(name: "/userPassPage"),
      ),
    ).then((authenticated) {
      log(_debug, '[_SignInFormState._showUserIdPage] userExists: $authenticated');
      if (authenticated is bool && authenticated) {
        _setAuthState(
          AuthResult(
            authenticated: authenticated, 
            message: AppText('Authenticated successfully').local, 
            user: user
          ), 
          authenticated,
        );
      } else {
        log(_debug, '[_showUserIdPage] пользователь не прошел проверку');
        setState(() {
          _userLogin = userlogin;
          _isLoading = false;
        });
      }
    });    
  }
  ///
  void _tryRegister(UserLogin userLogin) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>  RegisterUserPage(
          userLogin: userLogin,
        ),
        settings: const RouteSettings(name: "/registerUserPage"),
      ),
    ).then((isRegistered) {
      if (isRegistered is bool && isRegistered) {
        _tryAuth(userLogin.value(), true);
      }
    });
  }
  ///
  void _tryAuth(String userLogin, bool userExists) {
    setState(() => _isLoading = true);
    _auth
      .authenticateByLoginAndPass(userLogin, '${_auth.getUser()['pass']}')
      .then((authResult) {
        _setAuthState(authResult, userExists);
      });
  }
  ///
  Future<void> _setAuthState(AuthResult authResult, bool userExists) async {
    if (authResult.authenticated) {
      log(_debug, '[_SignInFormState._setAuthState] Authenticated!!!');
      setState(() => _isLoading = false);
      Navigator.of(context).push(
        // MaterialPageRoute(
        //   builder: (context) =>  HomePage(
        //     dataSource: dataSource,
        //     user: _auth.getUser(),
        //     dsClient: _dsClient, 
        //     themeSwitch: _themeSwitch,
        //   ),
        //   settings: const RouteSettings(name: "/homePage"),
        // ),
        MaterialPageRoute(
          builder: (context) =>  MenuPage(
            users: AppUserStacked(appUser: _auth.getUser()),
            dsClient: _dsClient, 
            alarmListData: _alarmListData,
            themeSwitch: _themeSwitch,
          ),
          settings: const RouteSettings(name: "/menuPage"),
        ),
      ).then((_) {
        setState(() => _isLoading = true);
        _auth.logout().then((authResult) {
          setState(() => _isLoading = false);
        });
      });
    } else {
      log(_debug, '[_SignInFormState._setAuthState] Not Authenticated!!!');
      setState(() => _isLoading = false);
      if (userExists) {
        if (!mounted) return;
        _tryRegister(_userLogin);
      }
      if (authResult.message != '') {
        _showFlushBar(authResult.message);
      }
    }
  }
  ///
  void _showFlushBar(String message) {
    FlushbarHelper.createError(
      duration: AppUiSettings.flushBarDurationMedium,
      message: message,
    ).show(context);
  }
  ///  
  @override
  void dispose() {
    super.dispose();
  }
}
