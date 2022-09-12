import 'package:another_flushbar/flushbar_helper.dart';
import 'package:crane_monitoring_app/domain/auth/app_user.dart';
import 'package:crane_monitoring_app/domain/auth/user_login.dart';
import 'package:crane_monitoring_app/domain/auth/user_password.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/core/timers/count_timer.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

/// Класс проверяет пользователя по паролю
class UserPassPage extends StatefulWidget {
  final AppUserSingle _user;
  final UserLogin _userLogin;
  ///
  const UserPassPage({
    Key? key,
    required AppUserSingle user,
    required UserLogin userLogin,
  }) :
    _user = user,
    _userLogin = userLogin,
    super(key: key);
  AppUserSingle get user => _user;
  UserLogin get userLogin => _userLogin;
  @override
  // ignore: no_logic_in_create_state
  _UserPassPageState createState() => _UserPassPageState(
    user: _user,
    userLogin: _userLogin,
  );
}

class _UserPassPageState extends State<UserPassPage> {
  static const _debug = false;
  final AppUserSingle _user;
  final UserLogin _userLogin;
  // bool _isLoading = false;
  bool _allowResend = true;
  int _secondsLeft = 0;
  int _resendTimeout = 1;
  double _resendTimeoutRaw = 1;
  late UserPassword _userPass;
  late CountTimer _countTimer;
  ///
  _UserPassPageState({
    required AppUserSingle user,
    required UserLogin userLogin,
  }) :
    _user = user,
    _userLogin = userLogin;
  ///
  @override
  void initState() {
    // _isLoading = false;
    _userPass = UserPassword(value: '');
    _countTimer = CountTimer(
      count: _resendTimeout,
      onTick:(int secondsLeft) {
        if (mounted) {
          setState(() {
            _secondsLeft = secondsLeft;
          });
        }
      },
      onComplete: () {
        _onResendAllowed();
      },
    );
    super.initState();
  }
  ///
  @override
  void dispose() {
    _countTimer.cancel();
    super.dispose();
  }
  ///
  @override
  Widget build(BuildContext context) {
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.padding;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(const AppText('Authentication').local),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: Padding(
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
                          const AppText('').local,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(height: padding),
                        Text(
                          _userLogin.value(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),                  
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          const AppText('Please enter your password').local,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: padding),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLength: _userPass.maxLength,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              // color: appThemeData.colorScheme.onPrimary,
                            ),
                            errorStyle: TextStyle(
                              height: 1.1,
                            ),
                            errorMaxLines: 5,
                          ),
                          autocorrect: false,
                          onChanged: (value) {
                            setState(() {
                              _userPass = UserPassword(value: value);
                            });
                          },
                        ),
                        const SizedBox(height: padding),
                        SizedBox(
                          // width: double.infinity,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: _allowResend
                              ? _verifyUserPass
                              : null,
                            child: _allowResend
                              ? Text(const AppText('Next').local)
                              : Text('${const AppText('Next').local} ($_secondsLeft)'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // if(_isLoading) ...[
                  //   const SizedBox(height: paddingValue,),
                  //   const LinearProgressIndicator(),
                  // ],
                ],
              ),
            ),
            Expanded(flex: 1, child: SizedBox.shrink(),),
          ],
        ),
      ),
    );
  }
  ///
  void _verifyUserPass() {
    // setState(() {
    //   _isLoading = true;
    // });
    final user = _user;
    final passLoaded = '${_user['pass']}';
    log(_debug, '[_verifyUserId] user:', user);
    log(_debug, '[_verifyUserId] _enteredUserId:', _userPass.encrypted());
    final passIsValid = _userPass.encrypted() == passLoaded;
    if (passIsValid) {
      _updateResendTimeout(reset: true);
      Navigator.of(context).pop(true);
    } else {
      _updateResendTimeout();
      FlushbarHelper.createError(
        duration: AppUiSettings.flushBarDurationMedium,
        message: const AppText('Wrong password').local,
      ).show(context);
    }
    // setState(() {
    //   _isLoading = false;
    // });
  }
  ///
  void _updateResendTimeout({bool? reset}) {
    _countTimer.cancel();
    if (reset is bool && reset) {
      _resendTimeoutRaw = 1;
    } else {
      _resendTimeoutRaw = _resendTimeoutRaw > 120
        ? 1
        : _resendTimeoutRaw * _resendTimeoutRaw * 1.14;
    }
    _resendTimeout = _resendTimeoutRaw.round();
    log(_debug, '[_updateResendTimeout] _resendTimeout:', _resendTimeout);
    _countTimer.run(count: _resendTimeout);
    setState(() {
      _allowResend = _resendTimeout <= 1;
      _secondsLeft = _resendTimeout;
    });
  }
  ///
  void _onResendAllowed() {
    setState(() {
      _allowResend = true;
    });
  }
}
