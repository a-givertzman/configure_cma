
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/infrastructure/api/response.dart';
import 'package:crane_monitoring_app/infrastructure/datasource/data_set.dart';

class RegisterUser {
  static const _debug = false;
  final DataSet<Map<String, dynamic>> _remote;
  final String _group;
  final String _location;
  final String _name;
  final String _phone;
  final String _pass;
  @override
  RegisterUser({
    required DataSet<Map<String, dynamic>> remote,
    required String group,
    required String location,
    required String name,
    required String phone,
    required String pass,
  }) :
    _remote = remote,
    _group = group,
    _location = location,
    _name = name,
    _phone = phone,
    _pass = pass;
  Future<Response<Map<String, dynamic>>> fetch() async {
    final fieldData = {
      'group': _group,
      'location': _location,
      'name': _name,
      'phone': _phone,
      'pass': _pass,
    };
    return _remote.fetchWith(
      params: {
        'fieldData': fieldData,
      },
    )
      .then((response) {
        log(_debug, '[$RegisterUser.fetch] response:', response);
        return Response(
          errCount: (response.hasError()) 
            ? 1
            : 0,
          errDump: (response.hasError()) 
            ? 'Ошибка регистрации нового пользователя: ${response.errorMessage()}'
            : '',
          data: response.data(),
        );
      })
      .onError((error, stackTrace) {
        log(_debug, 'Ошибка в методе $RegisterUser.fetchWith: $error');
        return Response(
          errCount: 1, 
          errDump: 'Ошибка в методе $RegisterUser.fetchWith: $error',
          data: {},
        );
      });
  }
}
