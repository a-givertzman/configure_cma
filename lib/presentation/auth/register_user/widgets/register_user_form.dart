import 'package:another_flushbar/flushbar_helper.dart';
import 'package:configure_cma/domain/auth/app_user_group.dart';
import 'package:configure_cma/domain/auth/register_user.dart';
import 'package:configure_cma/domain/auth/user_login.dart';
import 'package:configure_cma/domain/auth/user_password.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/datasource/app_data_source.dart';
import 'package:configure_cma/presentation/core/widgets/in_pogress_overlay.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
class RegisterUserForm extends StatefulWidget {
  final UserLogin _userLogin;
  ///
  const RegisterUserForm({
    Key? key,
    required UserLogin userLogin,
  }) : 
    _userLogin = userLogin,
    super(key: key);
  ///
  @override
  State<RegisterUserForm> createState() => _RegisterUserFormState();
}

///
class _RegisterUserFormState extends State<RegisterUserForm> {
  static const _debug = false;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _userName = '';
  final _userLocation = '';
  late UserPassword _userPassword;
  ///
  @override
  void initState() {
    if (mounted) {
      const _length = 4; // будет сгенерирован пароль в формате xxxx-xxxx
      _userPassword = UserPassword.generate(_length, _length);
    }
    log(_debug, '[_RegisterUserFormState.initState] generated userPassword: ', _userPassword.value());
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: user.authStream,
      builder:(context, auth) {
        if (_isLoading) {
          log(_debug, '[_RegisterUserFormState.build] _isLoading !!!');
          return InProgressOverlay(
            isSaving: true,
            message: const AppText('Loading...').local,
          );
        } else {
          return _buildSignInWidget(context, auth);
        }
      },
    );
  }
  ///
  Widget _buildSignInWidget(BuildContext context, AsyncSnapshot<Object?> auth) {
    log(_debug, '[_RegisterUserFormState.build] _buildSignInWidget');
    const paddingValue = 13.0;
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: ListView(
        padding: const EdgeInsets.all(paddingValue * 2),
        children: [
          const SizedBox(height: 34.0),
          Text(
            'Ваши данные',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: paddingValue),
          _buildFullNameFormField(context),
          const SizedBox(height: paddingValue),
          _buildPassFormField(context),
          const SizedBox(height: paddingValue),
          ElevatedButton(
            onPressed: isFormValid()
              ? _registerUser
              : null,
            child: Text(const AppText('Next').local),
          ),
        ],
      ),
    );
  }
  ///
  TextFormField _buildPassFormField(BuildContext context) {
    return TextFormField(
          style: Theme.of(context).textTheme.bodyMedium,
          maxLength: _userPassword.maxLength,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.lock,
              // color: Theme.of(context).colorScheme.onPrimary,
            ),
            labelText: 'Пароль',
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            errorStyle: const TextStyle(
              height: 1.1,
            ),
            errorMaxLines: 5,
          ),
          autocorrect: false,
          initialValue: _userPassword.value(),
          validator: (value) => _userPassword.validate().message(),
          onChanged: (value) {
            setState(() {
              _userPassword = UserPassword(value: value);
            });
          },
        );
  }
  ///
  TextFormField _buildFullNameFormField(BuildContext context) {
    return TextFormField(
          style: Theme.of(context).textTheme.bodyMedium,
          maxLength: 50,
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.account_box,
              // color: appThemeData.colorScheme.onPrimary,
            ),
            labelText: 'ФИО',
            labelStyle: Theme.of(context).textTheme.bodyMedium,
            errorMaxLines: 3,
          ),
          autocorrect: false,
          validator: (value) => value is String && value.length >= 5 
            ? null
            : 'Не менее 5 символов',
          onChanged: (value) {
            setState(() {
              _userName = value;
            });
          },
        );
  }
  ///
  bool isFormValid() {
    final formKeyCurrentState = _formKey.currentState;
    bool formValid = false;
    if (formKeyCurrentState != null) {
      formValid = formKeyCurrentState.validate();
    }
    return formValid;
  }
  ///
  void _registerUser() {
    setState(() {
      _isLoading = true;
    });
    RegisterUser(
      remote: dataSource.dataSet<Map<String, dynamic>>('set_client'),
      group: UserGroupList.operator,
      location: _userLocation,
      name: _userName,
      phone: widget._userLogin.value(),
      pass: _userPassword.encrypted(),
    )
      .fetch()
      .then((response) {
        if(!response.hasError()) {
          Navigator.of(context).pop(true);
          FlushbarHelper.createSuccess(
            duration: AppUiSettings.flushBarDurationMedium,
            message: 'Вы зарегистрированы, сохраните ваш логин и пароль.',
          ).show(context);
        } else {
          FlushbarHelper.createError(
            duration: AppUiSettings.flushBarDurationMedium,
            message: response.errorMessage(),
          ).show(context);
        }
      });
  }
}
