import 'package:configure_cma/domain/auth/authenticate.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/presentation/auth/sign_in/widgets/sign_in_form.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final Authenticate auth;
  final AppThemeSwitch themeSwitch;
  ///
  const SignInPage({
    Key? key,
    required this.auth,
    required this.themeSwitch,
  }) : 
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(const AppText('Authentication').local),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SignInForm(
            auth: auth,
            themeSwitch: themeSwitch,
          ),
        ),
      ),
    );
  }
}
