import 'package:crane_monitoring_app/domain/core/entities/state_constatnts.dart';

/// основной работы крана - значения
enum CraneMainModeValue {
  loading(stateIsLoading),
  modeUndefined(0),
  hurbour(1),
  theSea(2);
  const CraneMainModeValue(this.value);
  final num value;
}
