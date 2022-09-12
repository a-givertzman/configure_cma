import 'package:configure_cma/infrastructure/api/api_params.dart';
import 'package:configure_cma/infrastructure/api/api_request.dart';
import 'package:configure_cma/infrastructure/datasource/data_set.dart';
import 'package:configure_cma/infrastructure/datasource/data_source.dart';

DataSource dataSource = DataSource({
  ///
  ///пользователь системы
  'app-user': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'app_user',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-app-user',
      port: 8080,
    ),
  ),
  'app-user-test': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'app_user_test',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-app-user',
      port: 8080,
    ),
  ),
  'history': DataSet<Map<String, String>>(
    params: ApiParams(const <String, dynamic>{
      'api-sql': 'select',
      'tableName': 'event',
    }),
    apiRequest: const ApiRequest(
      url: '127.0.0.1',
      api: '/get-event',
      port: 8080,
    ),
  ),
});
