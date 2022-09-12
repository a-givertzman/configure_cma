import 'dart:async';

import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/event/event_list_data.dart';
import 'package:flutter/material.dart';

///
/// Filtering [EventListData] by tag path and name
class EventListDataFilteredByText<T> implements EventListData<T> {
  static const _debug = true;
  late StreamController<int> _stateController;
  late StreamSubscription _stateSubscription;
  final EventListData<T> _listData;
  final TextEditingController _filterController;
  String _filterText = '';
  ///
  EventListDataFilteredByText({
    required EventListData<T> listData,
    required TextEditingController filterController,
  }) :
    _listData = listData,
    _filterController = filterController
  {
    _filterController.addListener(() {
      log(_debug, '[$EventListDataFilteredByText._updateListWith] filter: ${_filterController.text}');
      if (_filterController.text != _filterText) {
        _filterText = _filterController.text;
        _stateController.add(0);
      }
    });
  }
  ///
  /// Список элементов для ListView
  List<T> get list {
    final regexp = RegExp('.*${_filterController.text}.*', caseSensitive: false);
    if (_filterController.text.isEmpty) {
      return _listData.list;
    }
    final listFiltered = _listData.list.where((element) {
      final event = element as DsDataPoint;
      return regexp.hasMatch(event.path) || regexp.hasMatch(event.name);
    }).toList();
    log(_debug, '[$EventListDataFilteredByText.list] listLength: ${listFiltered.length}');
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
  TextEditingController get filterController => _filterController;
  ///
  /// Квитирует событие, если оно перешло в неаварийное значение (0)
  void onAcknowledged(T point) => _listData.onAcknowledged(point);
  ///
  /// Call this method if [From] date modified
  void onDateFromSubmitted(DateTime? dateTime) {
      log(_debug, '[$EventListDataFilteredByText.onDateFromSubmitted] From date: ${dateTime}');
      _listData.onDateFromSubmitted(dateTime);
  }
  ///
  /// Call this method if [To] date modified
  void onDateToSubmitted(DateTime? dateTime) {
      log(_debug, '[$EventListDataFilteredByText.onDateToSubmitted] To date: ${dateTime}');
      _listData.onDateToSubmitted(dateTime);
  }
  /// If after filtering list less then [listCount]
  /// then loading additional event from the database
  loadOnFiltered(int listLength) {
    _listData.loadOnFiltered(listLength);
  }
  ///
  void dispose() {
    _stateController.close();
    _filterController.dispose();
    _listData.dispose();
  }
}