
import 'package:configure_cma/domain/auth/app_user_group.dart';
import 'package:configure_cma/domain/core/entities/data_object.dart';
import 'package:configure_cma/domain/core/entities/value_string.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/api/response.dart';
import 'package:configure_cma/infrastructure/datasource/data_set.dart';

///
abstract class AppUser {
  AppUserGroup userGroup();
  bool exists();
  bool valid();
  AppUserSingle clear();
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login);
  Future<Response<Map<String, dynamic>>> fetch({Map<String, dynamic> params = const {}});
}

///
class AppUserSingle extends DataObject with AppUser {
  final DataSet<Map<String, String>> _remote;
  ///
  AppUserSingle({
    required DataSet<Map<String, String>> remote, 
  }) :
    _remote = remote,
    super(remote: remote) {
    _init();
  }
  /// Создание гостевого пользователя.
  /// Используется при отсутствии связи или других прав доступа у пользователя
  AppUserSingle.guest() :
    _remote = const DataSet.empty(),
    super(remote:const DataSet.empty())
  {
    _init();
    super.fromRow({
      'id': '0',
      'group': UserGroupList.guest,
      'name': AppText('Guest').local,
      'login': 'guest',
      'pass': 'guest',
    });
  }
  /// Метод возвращает новый экземпляр класса
  /// с прежним remote, но без данных
  @override
  AppUserSingle clear() {
    return AppUserSingle(remote: _remote);
  }
  void _init() {
    this['id'] = const ValueString('');
    this['group'] = const ValueString('');
    this['name'] = const ValueString('');
    this['login'] = const ValueString('');
    this['pass'] = const ValueString('');
    this['account'] = const ValueString('');
    this['created'] = const ValueString('');
    this['updated'] = const ValueString('');
    this['deleted'] = const ValueString('');
  }
  /// Возвращает true после загрузки пользователя из базы
  /// если пользователь в базе есть, false если его там нет
  /// Возвращает null если еще не загружен
  @override
  bool exists() {
    if (!valid()) {
      return false;
    }
    if (valid() 
      && '${this["id"]}' != '' 
      && '${this["group"]}' != '' 
      && '${this["name"]}' != '' 
      && '${this["login"]}' != '' 
      && '${this["pass"]}' != ''
    ) {
      return true;
    } else {
      return false;
    }
  }
  ///
  @override
  AppUserGroup userGroup() {
    if (valid()) {
      return AppUserGroup(
        '${this['group']}',
      );
    }
    throw Failure.dataObject(
      message: 'Ошибка в методе userGroup класса [$runtimeType] пользователь еще не проинициализирован',
      stackTrace: StackTrace.current,
    );
  }
  ///
  @override
  Future<Response<Map<String, dynamic>>> fetchByLogin(String login) {
    return fetch(params: {
      'where': [
        {'operator': 'where', 'field': 'login', 'cond': '=', 'value': login},
      ],
    },);
  }
  ///
  @override
  Future<Response<Map<String, dynamic>>> fetch({Map<String, dynamic> params = const {}}) {
    return super.fetch(params: params);
  }
}
