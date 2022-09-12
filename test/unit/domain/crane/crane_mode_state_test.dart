import 'package:configure_cma/domain/core/entities/state_constatnts.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/crane/crane_wave_height_level.dart';
import 'package:configure_cma/domain/crane/crane_winch_mode_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CraneModeState', () {
    const _debug = true;
    setUp(() async {
    });
    test('CraneWinchModeValue', () async {
      log(_debug, 'CraneWinchModeValue: ', CraneWinchModeValue.ahcIsDisabled);
      log(_debug, 'CraneWinchModeValue: ', CraneWinchModeValue.manridingIsDisabled);
      expect(
        CraneWinchModeValue.ahcIsDisabled.value == stateIsDisabled, 
        equals(true),
      );
      // expect(CraneWinchModeValue.ahcIsDisabled, equals(CraneWinchModeValue.manridingIsDisabled));
      // expect(auth, isInstanceOf<Authenticate>());
    });
    test('CraneWaveHeightLevel', () async {
      log(_debug, 'CraneWaveHeightLevel: ', CraneWaveHeightLevel);
        // expect(authResult.authenticated, equals(users[i]['exists']));
        // expect(authResult.user.exists(), equals(users[i]['exists']));
        // expect(auth.getUser().exists(), equals(users[i]['exists']));
        // expect(auth.authenticated(), equals(users[i]['exists']));
    });
  });
}
