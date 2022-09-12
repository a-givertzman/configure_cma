import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/auth/auth_result.dart';
import 'package:crane_monitoring_app/domain/core/error/failure.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/presentation/core/dialogs/auth_dialog.dart';
import 'package:flutter/material.dart';

///
  Future<AuthResult> networkFieldAuthenticate(BuildContext context, AppUserStacked users) {
    const _debug = true;
    return Navigator.of(context).push<AuthResult>(
      MaterialPageRoute(
        builder: (context) => AuthDialog(
          key: UniqueKey(),
          currentUser: users.peek,
        ),
        settings: const RouteSettings(name: "/authDialog"),
      ),
    ).then((authResult) {
      log(_debug, '[_authenticate] authResult: ', authResult);
      final result = authResult;
      if (result != null) {
        if (result.authenticated) {
          users.push(result.user);
        }
        return result;
      }
      throw Failure.unexpected(
        message: 'Authentication error, null returned instead of AuthResult ', 
        stackTrace: StackTrace.current,
      );
    });    
  }