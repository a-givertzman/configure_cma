import 'dart:async';

import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_type.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_status.dart';


///
///
Stream<DsDataPoint<int>> emulateIntStream(int min, int max, {required int delay}) async* {
  while (true) {
    for (final status in [
      DsStatus.obsolete(), 
      DsStatus.invalid(), 
      DsStatus.timeInvalid(), 
      DsStatus.ok(),
    ]) {
      for (int value = min; value <= max; value++) {
        await Future.delayed(
          Duration(milliseconds: delay), 
        );
        yield DsDataPoint(
          type: DsDataType.dInt(),
          path: '',
          name: '',
          value: value,
          status: status,
          timestamp: DateTime.now().toIso8601String(),
        );
      }
    }
  }
}
///
class EmulateInUseStream {
  final StreamController<DsDataPoint<int>> _controller;
  EmulateInUseStream() : _controller = StreamController();
  Stream<DsDataPoint<int>> get stream {
    return _controller.stream;
  }
  void add(int value) {
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _controller.add(
          DsDataPoint(
            type: DsDataType.dInt(),
            path: '',
            name: '',
            value: value,
            status: DsStatus.ok(),
            timestamp: DateTime.now().toIso8601String(),
          ),
        );
      },
    );
  }
}
