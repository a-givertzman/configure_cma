import 'package:configure_cma/domain/core/entities/data_collection.dart';
import 'package:configure_cma/infrastructure/datasource/data_set.dart';

/// Класс реализует список элементов T = [DsDataPoint] для [EventListDataSource]
/// Список закупок для отображения в катологе 
class EventList<T> extends DataCollection<T>{
  EventList({
    required DataSet<Map<String, dynamic>> remote,
    required T Function(Map<String, dynamic>) dataMaper,
  }): super(
    remote: remote,
    dataMaper: dataMaper,
  );
}
