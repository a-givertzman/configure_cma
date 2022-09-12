import 'package:crane_monitoring_app/domain/alarm/event_list_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';

///
/// Контейнер храняший один DsDataPoint со статусом [active]
/// для отображения в списке аварий
class AlarmListPoint extends EventListPoint {
  final bool _active;
  final bool _acknowledged;
  ///
  AlarmListPoint({
    required DsDataPoint point, 
    required bool active,
    required bool acknowledged,
  }) : 
    _active = active,
    _acknowledged = acknowledged,
    super(
      id: '0',
      point: point,
    );
  ///
  bool get active => _active;
  bool get acknowledged => _acknowledged;
}