import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/infrastructure/api/api_params.dart';
import 'package:configure_cma/infrastructure/api/json_to.dart';
import 'package:configure_cma/infrastructure/api/response.dart';

class ApiHandleError<T> {
  static const _debug = true;
  final JsonTo<Map<String, dynamic>> _json;
  ApiHandleError({
    required JsonTo<Map<String, dynamic>> json,
  }):
    _json = json;
  Future<Response<T>> fetch({required ApiParams params}) {
    log(_debug, '[ApiHandleError.fetch]');
    return _json
      .parse(params: params)
      .then((_parsedResponse) {
        // final int dataCount = int.parse('${_parsed['dataCount']}');
        log(_debug, '[ApiHandleError.fetch] _parsedResponse: ', _parsedResponse);
        if (_parsedResponse.hasData()) {
          final sqlData = _parsedResponse.data();
          if (sqlData != null) {
            final T? data = sqlData['data'] as T?;
            final int errCount = int.parse('${sqlData['errCount']}');
            final String errDump = '${sqlData['errDump']}';
            return Response<T>(
              errCount: errCount, 
              errDump: errDump, 
              data: data,
            );
          } else {
            return Response<T>(
              errCount: _parsedResponse.errorCount(), 
              errDump: _parsedResponse.errorMessage(), 
            );
          }
        } else {
          return Response<T>(
            errCount: _parsedResponse.errorCount(), 
            errDump: _parsedResponse.errorMessage(), 
          );

        }
      })
      .onError((error, stackTrace) {
        return Response<T>(
          errCount: 1, 
          errDump: 'Ошибка в методе $runtimeType.fetch() $error', 
        );
        // throw Failure.unexpected(
        //   message: 'Ошибка в методе $runtimeType.fetch() $error',
        //   stackTrace: stackTrace,
        // );
      });
  }
}
