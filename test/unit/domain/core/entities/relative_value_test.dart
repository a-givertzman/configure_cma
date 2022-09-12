import 'package:configure_cma/domain/core/entities/relative_value.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const _debug = true;
  group('RelativeValueTest', () {
    // const _debug = true;
    setUp(() async {
      // return 0;
      // WidgetsFlutterBinding.ensureInitialized();
      // SharedPreferences.setMockInitialValues({});
    });
    test('basis', () async {
      expect(
        RelativeValue(min: 0, max: 100),
        isInstanceOf<RelativeValue>(),
      );
      final basis = RelativeValue(basis: 1.333, min: 0, max: 100).basis;
      expect(basis, 1.333);
    });
    test('relative 0..100', () async {
      final relativeValue = RelativeValue(basis: 1, min: 0, max: 100);
      expect(
        relativeValue,
        isInstanceOf<RelativeValue>(),
      );
      for (int value = 0; value <= 100; value++) {
        final rValue = relativeValue.relative(value.toDouble());
        log(_debug, 'value: $value\trelative: $rValue');
        expect(rValue.toStringAsFixed(2), (value / 100).toStringAsFixed(2));
      }
    });
    test('relative 100..200', () async {
      final relativeValue = RelativeValue(basis: 1, min: 100, max: 200);
      expect(
        relativeValue,
        isInstanceOf<RelativeValue>(),
      );
      for (int value = 100; value <= 200; value++) {
        final rValue = relativeValue.relative(value.toDouble());
        log(_debug, 'value: $value\trelative: $rValue');
        expect(rValue.toStringAsFixed(2), ((value - 100)/ 100).toStringAsFixed(2));
      }
    });
  });
}
