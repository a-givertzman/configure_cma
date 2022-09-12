import 'package:configure_cma/domain/core/entities/ds_data_class.dart';
import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/domain/core/entities/ds_data_type.dart';
import 'package:configure_cma/domain/core/entities/ds_point_path.dart';
import 'package:configure_cma/domain/core/entities/ds_status.dart';
import 'package:configure_cma/domain/core/entities/ds_timestamp.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';

///
/// Sends value of type [T] to the DataServer
class DsSend<T> {
  static const Map _types = {
    bool: DsDataType.bool(),
    int: DsDataType.int(),
    double: DsDataType.real(),
  };
  final DsClient _dsClient;
  final DsPointPath _pointPath;
  final String? _response;
  ///
  /// [path] - path identifies DataServer Point
  /// [name] - name identifies DataServer Point
  /// [response] - name identifies DataServer Point to read written value
  /// if [response] not set then [name] will be used to read response
  DsSend({
    required DsClient dsClient,
    required DsPointPath pointPath,
    String? response,
  }) : 
    assert(_types.containsKey(T)),
    _dsClient = dsClient,
    _pointPath = pointPath,
    _response = response;
  ///
  Future<DsDataPoint<T>> exec(T value) {
    _dsClient.send(
      dsClass: DsDataClass.commonCmd(),
      type: _types[T], 
      path: _pointPath.path, 
      name: _pointPath.name, 
      value: value, 
      status: DsStatus.ok(),
      timestamp: DsTimeStamp.now(),
    );
    final response = _response;
    if (response != null) {
      return _dsClient.stream<T>(response).first;
    } else {
      return _dsClient.stream<T>(_pointPath.name).first;
    }
  }
}