import 'package:crane_monitoring_app/domain/auth/app_user.dart';
import 'package:crane_monitoring_app/domain/auth/auth_result.dart';
import 'package:crane_monitoring_app/domain/auth/user_password.dart';
import 'package:crane_monitoring_app/domain/core/local_store/local_store.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';

class Authenticate {
  static const _debug = true;
  final _storeKey = 'spwd';
  AppUserSingle _user;
  ///
  Authenticate({
    required AppUserSingle user,
  }) :
    _user = user;
  ///
  AppUserSingle getUser() {
    return _user;
  }
  ///
  bool authenticated() {
    return _user.exists();
  }
  ///
  Future<AuthResult> authenticateIfStored() async {
    final _localStore = LocalStore();
    final userLogin = await _localStore.readStringDecoded(_storeKey);
    log(_debug, '[$Authenticate.authenticateIfStored] stored user: $userLogin');
    if (userLogin.isNotEmpty) {
      return authenticateByPhoneNumber(userLogin);
    } else {
      return AuthResult(
        authenticated: false, 
        message: const AppText('Please authenticate to continue...').local,
        user: _user,
      );
      // return Future.value(
      //   authenticateGuest(),
      // );
    }
  }
  ///
  Future<AuthResult> fetchByLogin(String login) {
    return _user.fetchByLogin(login)
      .then((response) {
        log(_debug, '[$Authenticate.fetchByLogin] response: ', response);
        log(_debug, '[$Authenticate.fetchByLogin] user: ', _user);
        if (response.hasError()) {
          log(_debug, '[$Authenticate.fetchByLogin] error: ', response.errorMessage());
          return AuthResult(
            authenticated: false, 
            message: '${response.errorMessage()}\n\n${const AppText('Try to check network connection').local} ${const AppText('to the database').local}.\n', 
            user: _user,
          );
        } else {
          final exists = _user.exists();
          return AuthResult(
            authenticated: exists, 
            message: exists ? AppText('Ok').local : AppText('User not found').local, 
            user: _user,
          );        
        }
      });
  }
  ///
  AuthResult authenticateGuest() {
    _user = AppUserSingle.guest();
    return AuthResult(
      authenticated: true, 
      message: 'Authenticated as: ${AppText('Guest').local}',
      user: _user,
    );
  }
  ///
  Future<AuthResult> authenticateByLoginAndPass(String login, String pass) {
    log(_debug, '[$Authenticate.authenticateByLoginAndPass] login: $login');
    _user = _user.clear();
    return _user.fetchByLogin(login)
      .then((response) {
        log(_debug, '[$Authenticate.authenticateByLoginAndPass] user: $_user');
        final passLoaded = '${_user['pass']}';
        final passIsValid = UserPassword(value: pass).encrypted() == passLoaded;
        if (response.hasError()) {
          return AuthResult(
            authenticated: false, 
            message: '${response.errorMessage()}\n\n' + AppText('Check the network connection to the database').local + '.\n',
            user: _user,
          );
        }
        if (_user.exists() &&  passIsValid) {
          final localStore = LocalStore();
          localStore.writeStringEncoded(_storeKey, login);
          return AuthResult(
            authenticated: true, 
            message: AppText('Authenticated successfully').local,
            user: _user,
          );
        } else {
          final message = !_user.exists()
            ? AppText('User').local + ' $login ' + AppText('is not found').local + '.'
            : !passIsValid
              ? AppText('Wrong login or password').local
              : AppText('Authentication error').local;
          return AuthResult(
            authenticated: false, 
            message: message,
            user: _user,
          );
        }
      })
      .catchError((error) {
        return AuthResult(
          authenticated: false, 
          message:  AppText('Authentication error').local + ':\n${error.toString()}',
          user: _user,
          error: error as Exception,
        );
      });
  }
  ///
  Future<AuthResult> authenticateByPhoneNumber(String phoneNumber) {
    return _user.fetch(params: {
      'phoneNumber': phoneNumber,
    },).then((user) {
      log(_debug, '[$Authenticate.authenticateByPhoneNumber] user: $user');
      if (_user.exists()) {
        final localStore = LocalStore();
        localStore.writeStringEncoded(_storeKey, phoneNumber);
        return AuthResult(
          authenticated: true, 
          message: AppText('Authenticated successfully').local,
          user: _user,
        );
      } else {
        return AuthResult(
          authenticated: false, 
          message: AppText('User').local + ' $phoneNumber ' + AppText('is not found').local + '.',
          user: _user,
        );
      }
    })
    .catchError((error) {
      return AuthResult(
        authenticated: false, 
        message: AppText('Authentication error').local + ':\n${error.toString()}',
        user: _user,
      );
    });
  }
  ///
  Future<AuthResult> logout() async {
    final _localStore = LocalStore();
    await _localStore.remove(_storeKey);
    _user = _user.clear();
    return AuthResult(
      authenticated: false, 
      message: AppText('Logged out').local, 
      user: _user,
    );
  }
}
