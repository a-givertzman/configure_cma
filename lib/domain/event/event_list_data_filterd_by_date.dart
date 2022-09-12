import 'dart:async';

import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/event/event_list_data.dart';

///
/// Filtering [EventListData] by [From] & [To] date period
class EventListDataFilteredByDate<T> implements EventListData<T> {
  static const _debug = true;
  late StreamController<int> _stateController;
  late StreamSubscription _stateSubscription;
  final EventListData<T> _listData;
  DateTime? _fromDateTime;
  DateTime? _toDateTime;
  ///
  /// Filtering [EventListData] by start & end date
  EventListDataFilteredByDate({
    required EventListData<T> listData,
  }) :
    _listData = listData;
  ///
  /// Call this method if [From] date modified
  void onDateFromSubmitted(DateTime? dateTime) {
      log(_debug, '[$EventListDataFilteredByDate.onDateFromSubmitted] From date: ${dateTime}');
      final fromDateTime = _fromDateTime;
      if (dateTime != null && fromDateTime != null) {
        if (dateTime.isAtSameMomentAs(fromDateTime)) {
          _fromDateTime = dateTime;
          _listData.onDateFromSubmitted(dateTime);
          _stateController.add(0);
        }
      } else if (dateTime != _fromDateTime) {
        if (dateTime != fromDateTime) {
          _fromDateTime = dateTime;
          _listData.onDateFromSubmitted(dateTime);
          _stateController.add(0);
        }
      }
  }
  ///
  /// Call this method if [To] date modified
  void onDateToSubmitted(DateTime? dateTime) {
      log(_debug, '[$EventListDataFilteredByDate.onDateToSubmitted] To date: ${dateTime}');
      final toDateTime = _toDateTime;
      if (dateTime != null && toDateTime != null) {
        if (dateTime.isAtSameMomentAs(toDateTime)) {
          _toDateTime = dateTime;
          _listData.onDateToSubmitted(dateTime);
          _stateController.add(0);
        }
      } else if (dateTime != _fromDateTime) {
        if (dateTime != toDateTime) {
          _toDateTime = dateTime;
          _listData.onDateToSubmitted(dateTime);
          _stateController.add(0);
        }
      }
  }
  ///
  /// Список элементов для ListView
  List<T> get list {
    final fromDateTime = _fromDateTime;
    final toDateTime = _toDateTime;
    List<T> listFiltered;
    if (fromDateTime != null && toDateTime != null) {
      listFiltered = _listData.list.where((element) {
        final event = element as DsDataPoint;
        return DateTime.parse(event.timestamp).isAfter(fromDateTime) &&
          DateTime.parse(event.timestamp).isBefore(toDateTime.add(Duration(days: 1)));
      }).toList();
    } else if (fromDateTime != null) {
      listFiltered = _listData.list.where((element) {
        final event = element as DsDataPoint;
        return DateTime.parse(event.timestamp).isAfter(fromDateTime);
      }).toList();
    } else if (toDateTime != null) {
      listFiltered = _listData.list.where((element) {
        final event = element as DsDataPoint;
        return DateTime.parse(event.timestamp).isBefore(toDateTime.add(Duration(days: 1)));
      }).toList();
    } else {
      return _listData.list;
    }
    _listData.loadOnFiltered(listFiltered.length);
    return listFiltered;
  }
  ///
  void _onCancel() {
    _stateSubscription.cancel();
  }
  /// Поток состояний для ListWiew.builder:
  ///   - 0 (новое событие)
  Stream<int> get stateStream {
    _stateController = StreamController<int>(onCancel: _onCancel);
    _stateSubscription = _listData.stateStream.listen((event) {
      _stateController.add(event);
    },);
    return _stateController.stream;
  }
  ///
  /// Текстовый контроллер для фильтации списка по тексту
  // TextEditingController get filterControllet => _listData.filterController;
  ///
  /// Квитирует событие, если оно перешло в неаварийное значение (0)
  void onAcknowledged(T point) => _listData.onAcknowledged(point);
  /// If after filtering list less then [listCount]
  /// then loading additional event from the database
  loadOnFiltered(int listLength) {
    _listData.loadOnFiltered(listLength);
  }
  ///
  void dispose() {
    _stateController.close();
    _listData.dispose();
  }
}