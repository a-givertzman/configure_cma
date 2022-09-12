import 'dart:async';

import 'package:configure_cma/domain/alarm/event_list_point.dart';
import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/domain/core/entities/state_constatnts.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/event/event_list.dart';
import 'package:configure_cma/domain/event/event_list_data.dart';
import 'package:configure_cma/presentation/event/widgets/position_controller.dart';
import 'package:flutter/material.dart';

class EventListDataSource<T> implements EventListData<T> {
  static const _debug = true;
  // final StreamController<int> _streamController = StreamController();
  final List<StreamController<int>> _stateControllers = [];
  final TextEditingController _filterController;
  final EventList<EventListPoint>? _eventList;
  final int _listCount;
  final List<T> _list = [];
  // final double _cacheExtent;
  final int _loadingCount;
  final int _newEventsReadDelay;
  late PositionController _positionController;
  DateTime? _fromDateTime;
  DateTime? _untilDateTime;
  bool _isLoading = false;
  bool _allLoaded = false;
  bool _isAuto = true;
  ///
  EventListDataSource({
    required TextEditingController filterController,
    required PositionController positionController,
    EventList<EventListPoint>? eventList,
    required int listCount,
    double? cacheExtent,
    int newEventsReadDelay = 500,
  }) :
    _filterController = filterController,
    _positionController = positionController,
    _eventList = eventList,
    _listCount = listCount,
    // _cacheExtent = cacheExtent ?? 100.0,
    _loadingCount = listCount,
    _newEventsReadDelay = newEventsReadDelay
  {
    _fetchNewEvents();
    _setupPositionControllerListen();
    // _filterController.addListener(() {
    // });
  }
  ///
  void _stateAdd(int state) {
    for (final controller in _stateControllers) {
      controller.add(state);
    }
  }
  ///
  /// Слушает события из PositionController
  /// [onTop], [onBottom], [onDown], [onAuto], [onManual]
  void _setupPositionControllerListen() {
    _positionController.listen(
      onTop: (double dYdT) {
        // _fetchUp();
        log(_debug, '[$EventListDataSource.listen] topPos');
      },
      onBottom: (double dYdT) {
        log(_debug, '[$EventListDataSource.listen] bottomPos');
        final lastEventId = _list.isNotEmpty ? (_list.last as EventListPoint).id : '';
        _fetchDown(lastEventId: lastEventId);
      },
      onDown: (dYdT) {
        if (_list.length > _listCount * 10) {
          _list.removeRange(0, (dYdT * 1.5).round());
          _stateAdd(0);
        }
      },
      onAuto: () {
        if (_fromDateTime == null && _untilDateTime == null) {
          _isAuto = true;
          _fetchNewEvents();
        }
      },
      onManual: () {
        _isAuto = false;
      },
    );
  }
  /// 
  /// Получает новые события из базы данных
  void  _fetchNewEvents() async {
    log(_debug, '[$EventListDataSource._fetchNewEvents] loading down...');
    final filterText = _filterController.text.toLowerCase();
    log(_debug, '[$EventListDataSource._fetchNewEvents] using filter: ${filterText}');
    while (_isAuto) {
      final lastEventId = _list.isNotEmpty ? (_list.first as EventListPoint).id : '';
      _fetchUp(lastEventId: lastEventId)
        .then((value) {
          if (_list.length > _listCount) {
            _list.removeRange(_list.length - _listCount, _list.length);
          }
        });
      await Future.delayed(Duration(milliseconds: _newEventsReadDelay));
    }
  }
  ///
  void _onCancel(StreamController<int>? controller) {
    log(_debug, '[$EventListDataSource.onCancel] ');
    _stateControllers.remove(controller);
    if (controller != null) {
      controller.close();
    }
    controller = null;
  }
  /// Поток состояний для ListWiew.builder:
  ///   - stateIsLoading (загрузка)
  ///   - stateIsLoaded (загрузка завершена)
  ///   - 0 (новое событие в режиме Авто)
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
  Future<void> _fetchUp({String lastEventId = ''}) async {
    log(_debug, '[$EventListDataSource._fetchUp] loading up...');
    final filterText = _filterController.text;
    log(_debug, '[$EventListDataSource._fetchUp] using filter: ${filterText}');
    // log(_debug, '[$EventListDataSource._fetchUp] loading up($_loadingCount)');
    if (!_isLoading) {
      _isLoading = true;
      _stateAdd(stateIsLoading);
      // final loadingCount = (_loadingCount / 2).round();
      final fromDateTime = _fromDateTime;
      final untilDateTime = _untilDateTime;
      return _fetchWith(
        params: {
          if (filterText.isNotEmpty) 'where': [
            {'operator': 'where (', 'field': 'name', 'cond': 'COLLATE UTF8_GENERAL_CI like', 'value': '%$filterText%'},
            {'operator': 'or', 'field': 'path', 'cond': 'COLLATE UTF8_GENERAL_CI like', 'value': '%$filterText%', 'sufix': ')'},
              if (fromDateTime != null)
                {'operator': 'and', 'field': 'timestamp', 'cond': '>=', 'value': fromDateTime.toIso8601String()},
              if (untilDateTime != null) 
                {'operator': 'and', 'field': 'timestamp', 'cond': '<=', 'value': untilDateTime.toIso8601String()},
              if (lastEventId.isNotEmpty) 
                {'operator': 'and', 'field': 'id', 'cond': '>', 'value': lastEventId},
          ] else if (lastEventId.isNotEmpty) 'where': [
            {'operator': 'where', 'field': 'id', 'cond': '>', 'value': lastEventId},
          ],
          'orderBy': ['timestamp'],
          'order': 'DESC',
          'limit': [_loadingCount],
        },
      ).then((loadedList) {
        // log(_debug, '[$EventListDataSource._fetchUp] loadedList: $loadedList');
        log(_debug, '[$EventListDataSource._fetchUp] loadedList.length: ${loadedList.length}');
        // _allLoaded = loadedList.length < loadingCount;
          _list.insertAll(0, loadedList as List<T>);
        // log(_debug, '[$EventListDataSource._fetchUp] list.length: ${_list.length}');
      }).whenComplete(() {
        _isLoading = false;
        _stateAdd(stateIsLoaded);
      });
    }
  }
  ///
  Future<void> _fetchDown({String lastEventId = ''}) async {
    log(_debug, '[$EventListDataSource._fetchDown] loading down...');
    final filterText = _filterController.text.toLowerCase();
    log(_debug, '[$EventListDataSource._fetchDown] using filter: ${filterText}');
    if (!_isLoading) {
      _isLoading = true;
      _stateAdd(stateIsLoading);
      final fromDateTime = _fromDateTime;
      final untilDateTime = _untilDateTime;
      return _fetchWith(
        params: {
          if (filterText.isNotEmpty || _fromDateTime != null || _untilDateTime != null) 'where': [
            {'operator': 'where (', 'field': 'name', 'cond': 'COLLATE UTF8_GENERAL_CI like', 'value': '%$filterText%'},
            {'operator': 'or', 'field': 'path', 'cond': 'COLLATE UTF8_GENERAL_CI like', 'value': '%$filterText%', 'sufix': ')'},
              if (fromDateTime != null) 
                {'operator': 'and', 'field': 'timestamp', 'cond': '>=', 'value': fromDateTime.toIso8601String()},
              if (untilDateTime != null) 
                {'operator': 'and', 'field': 'timestamp', 'cond': '<=', 'value': untilDateTime.toIso8601String()},
              if (lastEventId.isNotEmpty) 
                {'operator': 'and', 'field': 'id', 'cond': '<', 'value': lastEventId},
          ] else if (lastEventId.isNotEmpty) 'where': [
            {'operator': 'where', 'field': 'id', 'cond': '<', 'value': lastEventId},
          ],
          'orderBy': ['timestamp'],
          'order': 'DESC',
          'limit': [_loadingCount],
        },
      ).then((loadedList) {
        // log(_debug, '[$c._fetchDown] loadedList: $loadedList');
        log(_debug, '[$EventListDataSource._fetchDown] loadedList.length: ${loadedList.length}');
        // _allLoaded = loadedList.length < _loadingCount;
        _list.addAll(loadedList as List<T>);
        // log(_debug, '[$EventListDataSource._fetchDown] list.length: ${_list.length}');
      }).whenComplete(() {
        _isLoading = false;
        _stateAdd(stateIsLoaded);
      });
    }
  }
  ///
  /// Загружает события из базы даннх
  Future<List<DsDataPoint<dynamic>>> _fetchWith({
    required Map<String, dynamic> params,
  }) {
    log(_debug, '[$EventListDataSource._fetchWith] loading...');
    final eventList = _eventList;
    if (eventList != null) {
      return eventList.fetchWith(
        params: params,
      ).then((loadedList) {
        // log(_debug, '[$EventListDataSource._fetchWith] loadedList: $loadedList');
        log(_debug, '[$EventListDataSource._fetchWith] loadedList.length: ${loadedList.length}');
        return loadedList;
        // _list.removeRange(0, _loadingCount);
        // log(_debug, '[$EventListDataSource._fetchWith] list.length: ${_list.length}');
      }).onError((error, stackTrace) {
        log(_debug, '[$EventListDataSource._fetchWith] error: $error\nstackTrace: $stackTrace');
        return [];
      });
    }
    return Future.value([]);
  }
  ///
  /// Текстовый контроллер для фильтации списка по тексту
  TextEditingController get filterControllet => _filterController;
  ///
  /// Call this method if [From] date modified
  void onDateFromSubmitted(DateTime? dateTime) {
      log(_debug, '[$EventListDataSource.onDateFromSubmitted] From date: ${dateTime}');
      _isAuto = false;
      _fromDateTime = dateTime;
      _untilDateTime = dateTime != null ? dateTime.add(Duration(days: 1)) : dateTime;
      _list.clear();
      _fetchDown();
      _allLoaded = false;
  }
  ///
  /// Call this method if [To] date modified
  void onDateToSubmitted(DateTime? dateTime) {
      log(_debug, '[$EventListDataSource.onDateToSubmitted] To date: ${dateTime}');
      _isAuto = false;
      _fromDateTime = dateTime;
      _untilDateTime = dateTime != null ? dateTime.add(Duration(days: 1)) : dateTime;
      _list.clear();
      _fetchDown();
      _allLoaded = false;
  }
  /// Is not in use in this case
  @override
  void onAcknowledged(T point) {
  }
  /// If after filtering list less then [listCount]
  /// then loading additional event from the database
  loadOnFiltered(int listLength) {
    if (!_isLoading && !_allLoaded) {
      _allLoaded = true;
      if (listLength < _listCount) {
        final lastEventId = _list.isNotEmpty ? (_list.last as EventListPoint).id : '';
        _fetchDown(lastEventId: lastEventId);
      }
    }
  }
  ///
  void dispose() {
    for (final controller in _stateControllers) {
      controller.close();
    }
    _isAuto = false;
  }
}
