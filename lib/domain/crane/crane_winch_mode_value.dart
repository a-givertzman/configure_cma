import 'package:crane_monitoring_app/domain/core/entities/state_constatnts.dart';

/// режим лебедки - значения
enum CraneWinchModeValue {
  loading(stateIsLoading),
  modeUndefined(0),
  freight(1),
  ahc(2),
  ahcIsEnabled(stateIsEnabled),
  ahcIsDisabled(stateIsDisabled),
  manriding(3),
  manridingIsEnabled(stateIsEnabled),
  manridingIsDisabled(stateIsDisabled);
  const CraneWinchModeValue(this.value);
  final num value;
}
