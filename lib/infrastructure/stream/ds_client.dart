import 'package:crane_monitoring_app/domain/core/entities/ds_data_class.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_type.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_timestamp.dart';
import 'package:crane_monitoring_app/infrastructure/api/response.dart';
import 'package:crane_monitoring_app/infrastructure/stream/stream_mearged.dart';


abstract class DsClient {
  ///
  /// текущее состояние подключения к серверу
  bool isConnected();
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint
  Stream<DsDataPoint<T>> stream<T>(String name);
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>, 
  /// сдвинутый на offset (DsDataPoint.value + offset)  
  Stream<DsDataPoint<bool>> streamBool(String name, {bool inverse = false});
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>, 
  /// сдвинутый на offset (DsDataPoint.value + offset)
  Stream<DsDataPoint<int>> streamInt(String name, {int offset = 0});
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<double>, 
  /// сдвинутый на offset (DsDataPoint.value + offset)
  Stream<DsDataPoint<double>> streamReal(String name, {double offset = 0.0});
  ///
  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint
  Stream<DsDataPoint> streamMerged(List<String> names);
  ///
  /// Посылает команду сервеер S7 DataServer
  /// Если команда запрашивает данные, 
  /// то они прийдут в текущем активном подключении 
  /// в потоке Stream<DsDataPoint> stream
  /// В качестве результата Result<bool> получает результат записи в socket
  Response<bool> send({
    required DsDataClass dsClass,
    required DsDataType type,
    required String path,
    required String name,
    required dynamic value,
    required DsStatus status,
    required DsTimeStamp timestamp,
  });
  ///
  /// Делает запрос на S7 DataServer что бы получить все точки данных
  /// что бы сервер прочитал и прислал значения всех точек в потоке.
  /// Данные не ждем, они прийдут в потоке
  Response<bool> requestAll();
  ///
  /// Делает запрос на S7 DataServer в виде списка имен точек данных
  /// что бы сервер прочитал и прислал значения запрошенных точек в потоке
  /// В качестве результата Result<bool> получает результат чтения из S7 
  /// данные не ждем, они прийдут в потоке
  Response<bool> requestNamed(List<String> names);
  ///
  ///
  /// ====================================================================
  /// Методы работающие только в режиме эмуляции для удобства тестирования
  /// ====================================================================
  ///
  /// Поток, куда прийдут значения запрошенные по именам
  Stream<DsDataPoint<double>> streamRequestedEmulated(String filterByValue, {int delay = 500, double min = 0, double max = 100});
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<bool>
  Stream<DsDataPoint<bool>> streamBoolEmulated(String filterByValue, {int delay = 100});
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<double>
  Stream<DsDataPoint<double>> streamEmulated(
    String filterByValue, {
    int delay = 100, 
    double min = 0, 
    double max = 100, 
    int firstEventDelay = 0,
  });
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>
  Stream<DsDataPoint<int>> streamEmulatedInt(
    String filterByValue, {
    int delay = 100, 
    double min = 0, 
    double max = 100, 
    int firstEventDelay = 0,
  });
  ///
  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint
  StreamMerged<DsDataPoint> streamMergedEmulated(List<String> names);
  ///
  /// Посылает команду сервеер S7 DataServer
  /// Если команда запрашивает данные, 
  /// то они прийдут в текущем активном подключении 
  /// в потоке Stream<DsDataPoint> stream
  /// В качестве результата Result<bool> получает результат записи в socket
  Response<bool> sendEmulated({
    required DsDataClass dsClass,
    required DsDataType type,
    required String path,
    required String name,
    required dynamic value,
    required DateTime timestamp,
  });
  ///
  /// Делает запрос на S7 DataServer в виде списка имен точек данных
  /// что бы сервер прочитал и прислал значения запрошенных точек в потоке
  /// В качестве результата Result<bool> получает результат чтения из S7 
  /// данные не ждем, они прийдут в потоке
  Response<bool> requestNamedEmulated(List<String> names);
}
