import 'package:configure_cma/domain/core/entities/state_constatnts.dart';

/// активная лебедка - значения
enum CraneActiveWinchValue {
  loading(stateIsLoading),
  winchUndefined(0),
  winch1(1),
  winch2(2),
  winch3(3);
  const CraneActiveWinchValue(this.value);
  final num value;
}
