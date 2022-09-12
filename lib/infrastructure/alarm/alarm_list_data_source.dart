import 'dart:async';

import 'package:configure_cma/domain/alarm/alarm_list_point.dart';
import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/event/event_list_data.dart';

///
/// Хранит все активные и неактивные не сквитированные события,
/// События получает из основного потока Stream<DsDataPoint>
class AlarmListDataSource<T> implements EventListData<T> {
  static const _debug = true;
  final List<StreamController<int>> _stateControllers = [];
  final List<T> _list = [];
  final Stream<DsDataPoint>? _stream;
  ///
  /// Хранит все активные и неактивные не сквитированные события,
  /// События получает из основного потока Stream<DsDataPoint>
  AlarmListDataSource({
    Stream<DsDataPoint>? stream,
  }) :
  _stream = stream 
  {
    final stream = _stream;
    if (stream != null) {
      stream.listen((event) {
        _updateListWith(
          point: event,
          active: double.parse('${event.value}') > 0,
        );
        _stateAdd(0);
      });
    }
  }
  ///
  void _stateAdd(int state) {
    for (final controller in _stateControllers) {
      controller.add(state);
    }
  }
  ///
  /// Обновляет список новым событием:
  ///   - если аварийное событие першло в неаварийное значение,
  ///   то помечаем событие как неактивное
  ///   - если событие перешло в аварийное значение, 
  ///   то добавляем его в список аварийных и/или помечаем как активное
  void _updateListWith({
    required DsDataPoint point, 
    required bool active, 
  }) {
    // log(_debug, '[$AlarmListDataSource._updateListWith] event: $point');
    for (int i = 0; i < _list.length; i ++) {
      final listPoint = _list[i] as AlarmListPoint;
      if (listPoint.path == point.path && listPoint.name == point.name) {
        _list[i] = AlarmListPoint(
          point: point, 
          active: double.parse('${point.value}') > 0,
          acknowledged: false,
        ) as T;
        return;
      }
    }
    if (double.parse('${point.value}') > 0) {
        _list.insert(
          0, 
          AlarmListPoint(
            point: point, 
            active: double.parse('${point.value}') > 0,
            acknowledged: false,
          ) as T,
        );
    }
  }
  ///
  // void _onListen(StreamController<int> controller) {
  //   log(_debug, '[$AlarmListDataSource.onListen] ');
  // }
  ///
  void _onCancel(StreamController<int>? controller) {
    log(_debug, '[$AlarmListDataSource.onCancel] ');
    _stateControllers.remove(controller);
    if (controller != null) {
      controller.close();
    }
    controller = null;
  }
  /// Поток состояний для ListWiew.builder:
  ///   - 0 (новое событие)
  Stream<int> get stateStream {
    final controller = StreamController<int>();
    controller.onCancel = () {
      _onCancel(controller);
    };
    _stateControllers.add(controller);
    return controller.stream;
  }
  ///
  /// Список элементов для ListView
  List<T> get list {
    return _list;
  }
  ///
  /// Квитирует событие, если оно перешло в неаварийное значение (0)
  void onAcknowledged(T point) {
    final i = _list.indexOf(point);
    if ((i >= 0) && (double.parse('${(_list[i] as AlarmListPoint).value}') == 0)) {
      _list.removeAt(i);
    }
  }
  ///
  /// Is not in use in this case
  loadOnFiltered(int listLength) {
  }
  ///
  /// Is not in use in this case
  @override
  void onDateFromSubmitted(DateTime? dateTime) {
  }
  ///
  /// Is not in use in this case
  @override
  void onDateToSubmitted(DateTime? dateTime) {
  }
  ///
  void dispose() {
    for (final controller in _stateControllers) {
      controller.close();
    }
  }
}
