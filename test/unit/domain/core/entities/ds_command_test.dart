import 'package:crane_monitoring_app/domain/core/entities/ds_command.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_class.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_type.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_timestamp.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsCommand', () {
    const _debug = true;
    const jsonStr = '{"class":"requestAll","type":"Bool","path":"test.path","name":"test.name","value":1,"status":0,"timestamp":"2022-06-16T13:28:12.116871"}';
    final cmd0 = DsCommand<int>(
      dsClass: DsDataClass.requestAll(),
      type: DsDataType.bool(),
      path: 'test.path',
      name: 'test.name',
      value: 1,
      status: DsStatus.ok(),
      timestamp: DsTimeStamp.parse('2022-06-16T13:28:12.116871'),
    );
    setUp(() async {
      // return 0;
      // WidgetsFlutterBinding.ensureInitialized();
      // SharedPreferences.setMockInitialValues({});
    });
    test('create', () async {
      final cmd = DsCommand<int>(
        dsClass: DsDataClass.requestAll(),
        type: DsDataType.bool(),
        path: 'test.path',
        name: 'test.name',
        value: 1,
        status: DsStatus.ok(),
        timestamp: DsTimeStamp.parse('2022-06-16T13:28:12.116871'),
      );
      expect(
        cmd,
        isInstanceOf<DsCommand<int>>(),
      );
      log(_debug, 'requestAll cmd: ', cmd);
      expect(cmd, equals(cmd0));
      expect(cmd.toJson(), equals(cmd0.toJson()));
    });
    test('fromJson', () async {
      final cmd = DsCommand<int>.fromJson(jsonStr);
      expect(
        cmd,
        isInstanceOf<DsCommand<int>>(),
      );
      log(_debug, 'requestAll cmd: ', cmd);
      expect(cmd, equals(cmd0));
      expect(cmd.toJson(), equals(cmd0.toJson()));
    });
    test('toJson', () async {
      final cmd = DsCommand<int>.fromJson(jsonStr);
      expect(
        cmd,
        isInstanceOf<DsCommand<int>>(),
      );
      log(_debug, 'requestAll cmd: ', cmd);
      expect(cmd, equals(cmd0));
      expect(cmd.toJson(), equals(cmd0.toJson()));

    });
  });
}
