import 'package:configure_cma/domain/auth/user_login.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/presentation/auth/register_user/widgets/register_user_form.dart';
import 'package:flutter/material.dart';

class RegisterUserPage extends StatelessWidget {
  final UserLogin _userLogin;
  const RegisterUserPage({
    Key? key,
    required UserLogin userLogin,
  }) : 
    _userLogin = userLogin,
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(const AppText('Signing up').local),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      body: Center(
        child: RegisterUserForm(
          userLogin: _userLogin,
        ),
      ),
    );
  }
}
