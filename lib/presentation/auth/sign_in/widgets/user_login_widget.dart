import 'package:configure_cma/domain/auth/user_login.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class UserLoginWidget extends StatefulWidget {
  final UserLogin? userLogin;
  final void Function(UserLogin)? onCompleted;
  ///
  const UserLoginWidget({
    Key? key,
    this.userLogin,
    this.onCompleted,
  }) : super(key: key);
  ///
  @override
  _UserLoginWidgetState createState() => _UserLoginWidgetState();
}

///
class _UserLoginWidgetState extends State<UserLoginWidget> {
  static const _debug = false;
  late UserLogin _userLogin;
  ///
  @override
  void initState() {
    if (mounted) {
      final widgetUserLogin = widget.userLogin;
      if (widgetUserLogin != null) {
        _userLogin = widgetUserLogin;
      } else {
        _userLogin = const UserLogin(value: '');
      }
    }
    log(_debug, '[_UserLoginWidgetState.initState] userLogin: ', _userLogin.value());
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    log(_debug, '[_UserLoginWidgetState.build] userLogin: ', _userLogin.value());
    const blockPadding = AppUiSettings.blockPadding;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RepaintBoundary(
          child: TextFormField(
            style: Theme.of(context).textTheme.bodyMedium,
            keyboardType: TextInputType.number,
            maxLength: 254,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.account_circle,
              ),
              prefixStyle: Theme.of(context).textTheme.bodyMedium,
              labelText: const AppText('Your login').local,
              labelStyle: Theme.of(context).textTheme.bodyMedium,
              errorMaxLines: 3,
            ),
            autocorrect: false,
            initialValue: _userLogin.value(),
            validator: (value) => _userLogin.validate().message(),
            onChanged: (phone) {
              setState(() {
                _userLogin = UserLogin(value: phone);
              });
            },
          ),
        ),
        const SizedBox(height: blockPadding),
        SizedBox(
          // width: double.infinity,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
            onPressed: _userLogin.validate().valid()
              ? _onComplete
              : null,
            child: Text(const AppText('Next').local),
          ),
        ),
      ],
    );
  }
  ///
  void _onComplete() {
    FocusScope.of(context).unfocus();
    final widgetOnCompleted = widget.onCompleted;
    if (widgetOnCompleted != null) {
      widgetOnCompleted(_userLogin);
    }
  }
}
