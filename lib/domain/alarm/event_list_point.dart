import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';

///
/// Контейнер храняший один DsDataPoint с ID в базе данных
class EventListPoint extends DsDataPoint {
  final String _id;
  ///
  EventListPoint({
    required DsDataPoint point, 
    required String id,
  }) : 
    _id = id,
    super(
      type: point.type,
      path: point.path,
      name: point.name,
      value: point.value,
      status: point.status,
      timestamp: point.timestamp,
    );
  ///
  String get id => _id;
}