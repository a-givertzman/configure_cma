import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/home/widgets/parse_config_db.dart';
import 'package:flutter_test/flutter_test.dart';

const source = '''
DATA_BLOCK "DB_Panel_Controls"
{ S7_Optimized_Access := 'FALSE' }
VERSION : 0.1
NON_RETAIN
   STRUCT 
      Settings : Struct
         CraneMode : Struct
            MainMode : Int;
            ActiveWinch : Int;
            Winch1Mode : Int;
            WaveHeightLevel : Int;
            ConstantTensionLevel : Int;
            SetRelativeDepth : Int;   // Установить относительную глубтну
            ResetRelativeDepth : Int;   // Сбросить относительную глубтну
            Rsrv4 : Int;
            Rsrv5 : Int;
            Rsrv6 : Int;
         END_STRUCT;
         HPU : Struct
            Operate : Int;
            Pump1InUse : Int;   //  Ввод насоса в работу 1/2 (не включение, включает оператор с пульта)
            Pump2InUse : Int;   //  Ввод насоса в работу 1/2 (не включение, включает оператор с пульта)
            Rsrv2 : Int;
            Rsrv3 : Int;
            Rsrv4 : Int;
            OilType : Int;
            LowOilLevel : Int;
            AlarmLowOilLevel : Int;
            HighOilTemp : Int;
            AlarmHighOilTemp : Int;
            LowOilTemp : Int;
            OilCooling : Int;
            OilTempHysteresis : Int;
            WhaterFlowTrackingTimeout : Int;
            Reserv5 : Int;
            Reserv6 : Int;
            Reserv7 : Int;
         END_STRUCT;
         Art : Struct
            TotqueLimit : Real;
            Reserv1 : Real;
            Reserv2 : Real;
            Reserv3 : Real;
         END_STRUCT;
         AOPS : Struct
            RotationLimit1 : Real;
            RotationLimit2 : Real;
            Reserv1 : Real;
            Reserv2 : Real;
            Reserv3 : Real;
         END_STRUCT;
         MainWinch : Struct
            SpeedDown1PumpFactor : Int;
            SlowSpeedFactor : Int;
            SpeedDown2AxisFactor : Int;
            SpeedAccelerationTime : Int;
            SpeedDecelerationTime : Int;
            FastStoppingTime : Int;
            SpeedDownMaxPos : Int;
            SpeedDownMaxPosFactor : Int;
            SpeedDownMinPos : Int;
            SpeedDownMinPosFactor : Int;
            Reserv1 : Int;
            Reserv2 : Int;
            Reserv3 : Int;
         END_STRUCT;
         MainBoom : Struct
            SpeedDown1PumpFactor : Int;
            SlowSpeedFactor : Int;
            SpeedDown2AxisFactor : Int;
            SpeedAccelerationTime : Int;
            SpeedDecelerationTime : Int;
            FastStoppingTime : Int;
            PositionOffshore : Int;
            SpeedDownMaxPos : Int;
            SpeedDownMaxPosFactor : Int;
            SpeedDownMinPos : Int;
            SpeedDownMinPosFactor : Int;
            Reserv1 : Int;
            Reserv2 : Int;
            Reserv3 : Int;
         END_STRUCT;
         RotaryBoom : Struct
            SpeedDown1PumpFactor : Int;
            SlowSpeedFactor : Int;
            SpeedDown2AxisFactor : Int;
            SpeedAccelerationTime : Int;
            SpeedDecelerationTime : Int;
            FastStoppingTime : Int;
            SpeedDownMaxPos : Int;
            SpeedDownMaxPosFactor : Int;
            SpeedDownMinPos : Int;
            SpeedDownMinPosFactor : Int;
            Reserv1 : Int;
            Reserv2 : Int;
            Reserv3 : Int;
         END_STRUCT;
         Rotation : Struct
            SpeedDown1PumpFactor : Int;
            SlowSpeedFactor : Int;
            SpeedDown2AxisFactor : Int;
            SpeedAccelerationTime : Int;
            SpeedDecelerationTime : Int;
            FastStoppingTime : Int;
            PositionDefault : Int;
            PositionReset : Int;
            PositionOffshore : Int;
            PositionMarchingMode : Int;
            SpeedDownMaxPos : Int;
            SpeedDownMaxPosFactor : Int;
            Reserv1 : Int;
            Reserv2 : Int;
            Reserv3 : Int;
         END_STRUCT;
         Control : Struct
            Common : Struct
               ResetAlarms : Int;
            END_STRUCT;
         END_STRUCT;
      END_STRUCT;
   END_STRUCT;


BEGIN

END_DATA_BLOCK

''';

void main() {
  group('ParseConfigDb', () {
    const _debug = true;
    setUp(() async {
      // return 0;
      // WidgetsFlutterBinding.ensureInitialized();
      // SharedPreferences.setMockInitialValues({});
    });
    test('create', () async {
      final parse = ParseConfigDb(
        lines: source.split('\n'),
        offset: ParseOffset(0),
      ).parse();
      log(_debug, 'parse: ', parse);
      // expect(
      //   cmd,
      //   isInstanceOf<DsCommand<int>>(),
      // );
      // expect(cmd, equals(cmd0));
      // expect(cmd.toJson(), equals(cmd0.toJson()));
    });
  });
}
