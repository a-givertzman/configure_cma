import 'package:crane_monitoring_app/domain/core/entities/ds_data_class.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_class_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DsDataClass', () {
    // const _debug = true;
    setUp(() async {
      // return 0;
      // WidgetsFlutterBinding.ensureInitialized();
      // SharedPreferences.setMockInitialValues({});
    });
    test('requestAll', () async {
      expect(
        DsDataClass.requestAll(),
        isInstanceOf<DsDataClass>(),
      );
      final requestAll = DsDataClass.requestAll();
      expect(requestAll.name, DsDataClassValue.requestAll.value);
    });
    test('requestList', () async {
      expect(
        DsDataClass.requestList(),
        isInstanceOf<DsDataClass>(),
      );
      final requestList = DsDataClass.requestList();
      expect(requestList.name, DsDataClassValue.requestList.value);
    });
    test('requestTime', () async {
      expect(
        DsDataClass.requestTime(),
        isInstanceOf<DsDataClass>(),
      );
      final requestTime = DsDataClass.requestTime();
      expect(requestTime.name, DsDataClassValue.requestTime.value);
    });
    test('requestAlarms', () async {
      expect(
        DsDataClass.requestAlarms(),
        isInstanceOf<DsDataClass>(),
      );
      final requestAlarms = DsDataClass.requestAlarms();
      expect(requestAlarms.name, DsDataClassValue.requestAlarms.value);
    });
    test('requestPath', () async {
      expect(
        DsDataClass.requestPath(),
        isInstanceOf<DsDataClass>(),
      );
      final requestPath = DsDataClass.requestPath();
      expect(requestPath.name, DsDataClassValue.requestPath.value);
    });
    test('syncTime', () async {
      expect(
        DsDataClass.syncTime(),
        isInstanceOf<DsDataClass>(),
      );
      final syncTime = DsDataClass.syncTime();
      expect(syncTime.name, DsDataClassValue.syncTime.value);
    });
    test('commonCmd', () async {
      expect(
        DsDataClass.commonCmd(),
        isInstanceOf<DsDataClass>(),
      );
      final commonCmd = DsDataClass.commonCmd();
      expect(commonCmd.name, DsDataClassValue.commonCmd.value);
    });
    test('commonData', () async {
      expect(
        DsDataClass.commonData(), 
        isInstanceOf<DsDataClass>(),
      );
      final commonData = DsDataClass.commonData();
      expect(commonData.name, DsDataClassValue.commonData.value);
    });
  });
}
