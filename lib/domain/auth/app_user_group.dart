
import 'package:crane_monitoring_app/domain/core/error/failure.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';

/// Константы групп пользователей в системе
class UserGroupList {
  static const admin = 'admin';
  static const operator = 'operator';
  static const guest = 'guest';
}

/// Класс работы с группами пользователей
class AppUserGroup {
  final Map<String, String> _groups = {
    UserGroupList.admin: AppText('Administrator').local,
    UserGroupList.operator: AppText('Operator').local,
    UserGroupList.guest: AppText('Guest').local,
  };
  late String _group;
  ///
  AppUserGroup(String group) {
    if (_groups.containsKey(group)) {
      _group = group;
    } else {
      throw Failure.convertion(
          message: "[UserGroup] '$group' несуществующая группа",
          stackTrace: StackTrace.current,
      );
    }
  }
  /// вернет значение группы
  String get value => _group;
  /// вернет текстовое представление группы
  String text() => textOf(_group);
  /// вернет текстовое представление группы переданной в параметре
  String textOf(String key) {
    if (_groups.containsKey(key)) {
      final status = _groups[key];
      if (status != null) {
        return status;
      }
    }
    throw Failure.unexpected(
      message: '[$runtimeType] $key - несуществующая группа',
      stackTrace: StackTrace.current,
    );
  }
}
