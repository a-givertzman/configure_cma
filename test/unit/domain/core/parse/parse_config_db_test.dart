import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/home/widgets/parse_config_db.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

const source = '''
DATA_BLOCK "DB_Panel_Controls"
{ S7_Optimized_Access := 'FALSE' }
VERSION : 0.1
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
      END_STRUCT;
      Control : Struct
         Common : Struct
            ResetAlarms : Int;
         END_STRUCT;
      END_STRUCT;
   END_STRUCT;


BEGIN

END_DATA_BLOCK

''';

const Map<String, dynamic> result = {
      "Settings.CraneMode.MainMode": {
        "type": "Int", "offset": 0
      }, 
      "Settings.CraneMode.ActiveWinch": {
        "type": "Int", "offset": 2
      }, 
      "Settings.CraneMode.Winch1Mode": {
        "type": "Int", "offset": 4
      }, 
      "Settings.CraneMode.WaveHeightLevel": {
        "type": "Int", "offset": 6
      }, 
      "Settings.CraneMode.ConstantTensionLevel": {
        "type": "Int", "offset": 8
      }, 
      "Settings.CraneMode.SetRelativeDepth": {
        "type": "Int", "offset": 10
      }, 
      "Settings.CraneMode.ResetRelativeDepth": {
        "type": "Int", "offset": 12
      }, 
      "Settings.CraneMode.Rsrv4": {
        "type": "Int", "offset": 14
      }, 
      "Settings.CraneMode.Rsrv5": {
        "type": "Int", "offset": 16
      }, 
      "Settings.CraneMode.Rsrv6": {
        "type": "Int", "offset": 18
      },
      "Settings.HPU.Operate": {
        "type": "Int", "offset": 20
      }, 
      "Settings.HPU.Pump1InUse": {
        "type": "Int", "offset": 22
      }, 
      "Settings.HPU.Pump2InUse": {
        "type": "Int", "offset": 24
      }, 
      "Settings.HPU.Rsrv2": {
        "type": "Int", "offset": 26
      }, 
      "Settings.HPU.Rsrv3": {
        "type": "Int", "offset": 28
      }, 
      "Settings.HPU.Rsrv4": {
        "type": "Int", "offset": 30
      }, 
      "Settings.HPU.OilType": {
        "type": "Int", "offset": 32
      }, 
      "Settings.HPU.LowOilLevel": {
        "type": "Int", "offset": 34
      }, 
      "Settings.HPU.AlarmLowOilLevel": {
        "type": "Int", "offset": 36
      }, 
      "Settings.HPU.HighOilTemp": {
        "type": "Int", "offset": 38
      }, 
      "Settings.HPU.AlarmHighOilTemp": {
        "type": "Int", "offset": 40
      }, 
      "Settings.HPU.LowOilTemp": {
        "type": "Int", "offset": 42
      }, 
      "Settings.HPU.OilCooling": {
        "type": "Int", "offset": 44
      }, 
      "Settings.HPU.OilTempHysteresis": {
        "type": "Int", "offset": 46
      }, 
      "Settings.HPU.WhaterFlowTrackingTimeout": {
        "type": "Int", "offset": 48
      }, 
      "Settings.HPU.Reserv5": {
        "type": "Int", "offset": 50
      }, 
      "Settings.HPU.Reserv6": {
        "type": "Int", "offset": 52
      }, 
      "Settings.HPU.Reserv7": {
        "type": "Int", "offset": 54
      },
      "Settings.Art.TotqueLimit": {
        "type": "Real", "offset": 56
      }, 
      "Settings.Art.Reserv1": {
        "type": "Real", "offset": 60
      }, 
      "Settings.Art.Reserv2": {
        "type": "Real", "offset": 64
      }, 
      "Settings.Art.Reserv3": {
        "type": "Real", "offset": 68
      },
      "Settings.AOPS.RotationLimit1": {
        "type": "Real", "offset": 72
      }, 
      "Settings.AOPS.RotationLimit2": {
        "type": "Real", "offset": 76
      }, 
      "Settings.AOPS.Reserv1": {
        "type": "Real", "offset": 80
      }, 
      "Settings.AOPS.Reserv2": {
        "type": "Real", "offset": 84
      }, 
      "Settings.AOPS.Reserv3": {
        "type": "Real", "offset": 88
      },
      "Settings.MainWinch.SpeedDown1PumpFactor": {
        "type": "Int", "offset": 92
      }, 
      "Settings.MainWinch.SlowSpeedFactor": {
        "type": "Int", "offset": 94
      }, 
      "Settings.MainWinch.SpeedDown2AxisFactor": {
        "type": "Int", "offset": 96
      }, 
      "Settings.MainWinch.SpeedAccelerationTime": {
        "type": "Int", "offset": 98
      }, 
      "Settings.MainWinch.SpeedDecelerationTime": {
        "type": "Int", "offset": 100
      }, 
      "Settings.MainWinch.FastStoppingTime": {
        "type": "Int", "offset": 102
      }, 
      "Settings.MainWinch.SpeedDownMaxPos": {
        "type": "Int", "offset": 104
      }, 
      "Settings.MainWinch.SpeedDownMaxPosFactor": {
        "type": "Int", "offset": 106
      }, 
      "Settings.MainWinch.SpeedDownMinPos": {
        "type": "Int", "offset": 108
      }, 
      "Settings.MainWinch.SpeedDownMinPosFactor": {
        "type": "Int", "offset": 110
      }, 
      "Settings.MainWinch.Reserv1": {
        "type": "Int", "offset": 112
      }, 
      "Settings.MainWinch.Reserv2": {
        "type": "Int", "offset": 114
      }, 
      "Settings.MainWinch.Reserv3": {
        "type": "Int", "offset": 116
      },
      "Settings.MainBoom.SpeedDown1PumpFactor": {
        "type": "Int", "offset": 118
      }, 
      "Settings.MainBoom.SlowSpeedFactor": {
        "type": "Int", "offset": 120
      }, 
      "Settings.MainBoom.SpeedDown2AxisFactor": {
        "type": "Int", "offset": 122
      }, 
      "Settings.MainBoom.SpeedAccelerationTime": {
        "type": "Int", "offset": 124
      }, 
      "Settings.MainBoom.SpeedDecelerationTime": {
        "type": "Int", "offset": 126
      }, 
      "Settings.MainBoom.FastStoppingTime": {
        "type": "Int", "offset": 128
      }, 
      "Settings.MainBoom.PositionOffshore": {
        "type": "Int", "offset": 130
      }, 
      "Settings.MainBoom.SpeedDownMaxPos": {
        "type": "Int", "offset": 132
      }, 
      "Settings.MainBoom.SpeedDownMaxPosFactor": {
        "type": "Int", "offset": 134
      }, 
      "Settings.MainBoom.SpeedDownMinPos": {
        "type": "Int", "offset": 136
      }, 
      "Settings.MainBoom.SpeedDownMinPosFactor": {
        "type": "Int", "offset": 138
      }, 
      "Settings.MainBoom.Reserv1": {
        "type": "Int", "offset": 140
      }, 
      "Settings.MainBoom.Reserv2": {
        "type": "Int", "offset": 142
      }, 
      "Settings.MainBoom.Reserv3": {
        "type": "Int", "offset": 144
      },
      "Settings.RotaryBoom.SpeedDown1PumpFactor": {
        "type": "Int", "offset": 146
      }, 
      "Settings.RotaryBoom.SlowSpeedFactor": {
        "type": "Int", "offset": 148
      }, 
      "Settings.RotaryBoom.SpeedDown2AxisFactor": {
        "type": "Int", "offset": 150
      }, 
      "Settings.RotaryBoom.SpeedAccelerationTime": {
        "type": "Int", "offset": 152
      }, 
      "Settings.RotaryBoom.SpeedDecelerationTime": {
        "type": "Int", "offset": 154
      }, 
      "Settings.RotaryBoom.FastStoppingTime": {
        "type": "Int", "offset": 156
      }, 
      "Settings.RotaryBoom.SpeedDownMaxPos": {
        "type": "Int", "offset": 158
      }, 
      "Settings.RotaryBoom.SpeedDownMaxPosFactor": {
        "type": "Int", "offset": 160
      }, 
      "Settings.RotaryBoom.SpeedDownMinPos": {
        "type": "Int", "offset": 162
      }, 
      "Settings.RotaryBoom.SpeedDownMinPosFactor": {
        "type": "Int", "offset": 164
      }, 
      "Settings.RotaryBoom.Reserv1": {
        "type": "Int", "offset": 166
      }, 
      "Settings.RotaryBoom.Reserv2": {
        "type": "Int", "offset": 168
      }, 
      "Settings.RotaryBoom.Reserv3": {
        "type": "Int", "offset": 170
      },
      "Settings.Rotation.SpeedDown1PumpFactor": {
        "type": "Int", "offset": 172
      }, 
      "Settings.Rotation.SlowSpeedFactor": {
        "type": "Int", "offset": 174
      }, 
      "Settings.Rotation.SpeedDown2AxisFactor": {
        "type": "Int", "offset": 176
      }, 
      "Settings.Rotation.SpeedAccelerationTime": {
        "type": "Int", "offset": 178
      }, 
      "Settings.Rotation.SpeedDecelerationTime": {
        "type": "Int", "offset": 180
      }, 
      "Settings.Rotation.FastStoppingTime": {
        "type": "Int", "offset": 182
      }, 
      "Settings.Rotation.PositionDefault": {
        "type": "Int", "offset": 184
      }, 
      "Settings.Rotation.PositionReset": {
        "type": "Int", "offset": 186
      }, 
      "Settings.Rotation.PositionOffshore": {
        "type": "Int", "offset": 188
      }, 
      "Settings.Rotation.PositionMarchingMode": {
        "type": "Int", "offset": 190
      }, 
      "Settings.Rotation.SpeedDownMaxPos": {
        "type": "Int", "offset": 192
      }, 
      "Settings.Rotation.SpeedDownMaxPosFactor": {
        "type": "Int", "offset": 194
      }, 
      "Settings.Rotation.Reserv1": {
        "type": "Int", "offset": 196
      }, 
      "Settings.Rotation.Reserv2": {
        "type": "Int", "offset": 198
      }, 
      "Settings.Rotation.Reserv3": {
        "type": "Int", "offset": 200
      },
      "Control.Common.ResetAlarms": {
        "type": "Int", "offset": 202
      }
};

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
        offset: ParseOffset(),
      ).parse();
      // log(_debug, 'parse: ', parse);
      bool _test(Map<String, dynamic> map1, Map<String, dynamic> map2) {
        bool result = true;
        map1.forEach((key, value) {
          if (key.contains('.')) {
            final test = mapEquals<String, dynamic>(value, map2[key]);
            log(_debug, '$key: origin: ${map2[key]}\tpased: $value\t$test');
            result = result && test;
          } else {
            result = result && _test(value, map2[key]);
          }
        });
        return result;
      }
      final test = _test(parse, result);
      expect(test, equals(true));
    });
  });
}
