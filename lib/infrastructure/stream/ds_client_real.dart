import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:configure_cma/domain/core/entities/ds_command.dart';
import 'package:configure_cma/domain/core/entities/ds_data_class.dart';
import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/domain/core/entities/ds_data_type.dart';
import 'package:configure_cma/domain/core/entities/ds_status.dart';
import 'package:configure_cma/domain/core/entities/ds_timestamp.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/infrastructure/api/response.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/infrastructure/stream/stream_mearged.dart';


///
/// Клиент подключения к DataServer
class DsClientReal implements DsClient{
  static const _debug = true;
  bool _isActive = false;
  bool _isConnected = false;
  bool _cancel = false;
  final Map<String, StreamController<DsDataPoint>> _receivers = {};
  final String _ip;
  final int _port;
  // late StreamController<DsDataPoint> _streamController;
  late Socket _socket;
  ///
  DsClientReal({
    required String ip,
    required int port,
  }):
    _ip = ip,
    _port = port;
  ///
  /// текущее состояние подключения к серверу
  @override
  bool isConnected() {
    return _isConnected;
  }
  ///
  void _onCancel(StreamController<DsDataPoint>? controller) {
    log(_debug, '[$DsClientReal.onCancel] ');
    _receivers.removeWhere((key, value) => value == controller);
    if (controller != null) {
      controller.close();
    }
    controller = null;
  }
  ///
  Stream<DsDataPoint<T>> _stream<T>(String name) {
    if (T == bool) {
      return _streamToBool(_setupStreamController(name).stream) as Stream<DsDataPoint<T>>;
    }
    if (T == int) {
      return _streamToInt(_setupStreamController(name).stream) as Stream<DsDataPoint<T>>;
    }
    if (T == double) {
      return _streamToDouble(_setupStreamController(name).stream) as Stream<DsDataPoint<T>>;
    }
    return _setupStreamController(name).stream as Stream<DsDataPoint<T>>;
  }
  ///
  /// Вернет StreamController с именем [name] из Map<String, StreamContoller> _receivers
  /// если такой есть, если нет, то создаст.
  StreamController<DsDataPoint> _setupStreamController(String name) {
    // StreamController<DsDataPoint> streamController;
    if (!_receivers.containsKey(name)) {
      final streamController = StreamController<DsDataPoint>.broadcast(
        onListen: () {
          if (!_isActive) {
            _isActive = true;
            log(_debug, '[$DsClientReal._setupStreamController] before _run');
            _run();
            log(_debug, '[$DsClientReal._setupStreamController] after _run');
          }
        },
      );
      streamController.onCancel = () => _onCancel(streamController);
      _receivers[name] = streamController;
      log(_debug, '[$DsClientReal._setupStreamController] value: $name,   streamCtrl: $streamController');
      return streamController;
    } else {
      if (_receivers.containsKey(name)) {
        final streamController = _receivers[name];
        if (streamController != null) {
          // log(_debug, '[$DsClientReal._setupStreamController] value: $name,   streamCtrl: $streamController');
          return streamController;
        } else {
          log(_debug, 'Ошибка в методе $DsClientReal._setupStreamController: streamController could not be null');
          throw Exception('Ошибка в методе $DsClientReal._setupStreamController: streamController could not be null');
        }
      } else {
        log(_debug, 'Ошибка в методе $DsClientReal._setupStreamController: name not found: $name');
        throw Exception('Ошибка в методе $DsClientReal._setupStreamController: name not found: $name');
      }
    }    
  }
  ///
  Stream<DsDataPoint<bool>> _streamToBool(Stream<DsDataPoint> stream, {bool inverse = false}) {
    return stream
      .map((event) {
        // log(_debug, '[$DsClientReal.streamBool.map] event: ', event.name, '\t', event.value);
        bool value = false;
        DsStatus status = event.status;
        if (event.value.runtimeType == bool) {
          value = event.value ^ inverse;
        } else {
          final parsedValue = int.tryParse('${event.value}');
          if (parsedValue != null) {
            value = (parsedValue > 0) ^ inverse;
          } else {
            log(_debug, '[$DsClientReal._streamToBool] bool.parse error for event: $event');
            status = DsStatus.invalid();
          }
        }
        return DsDataPoint<bool>(
          type: DsDataType.bool(),
          path: event.path,
          name: event.name,
          value: value,
          status: status,
          timestamp: event.timestamp,
        );
      });
  }

  Stream<DsDataPoint<int>> _streamToInt(Stream<DsDataPoint> stream, {int offset = 0}) {
    return stream
      .map((event) {
        // log(_debug, '[$DsClientReal.streamInt.map] event: ', event.name, '\t', event.value);
        int value = 0;
        DsStatus status = event.status;
        final parsedValue = int.tryParse('${event.value}');
        if (parsedValue != null) {
          value = parsedValue + offset;
        } else {
          log(_debug, 'int.parse error for event: $event');
          status = DsStatus.invalid();
        }
        return DsDataPoint<int>(
          type: DsDataType.int(),
          path: event.path,
          name: event.name,
          value: value,
          status: status,
          timestamp: event.timestamp,
        );
      });
  }
  ///
  Stream<DsDataPoint<double>> _streamToDouble(Stream<DsDataPoint> stream, {double offset = 0.0}) {
    return stream
      .map((event) {
        // if (event.name == 'Capacitor.Capacity') {
        //   log(_debug, '[$DsClientReal.streamReal.map] event: ', event.name, '\t', event.value);
        // }
        double value = 0;
        DsStatus status = event.status;
        final parsedValue = double.tryParse('${event.value}');
        // if (event.name == 'Capacitor.Capacity') {
        //   log(_debug, '[$DsClientReal.streamReal.map] parsedValue: ', parsedValue);
        // }
        if (parsedValue != null) {
          value = parsedValue + offset;
        } else {
          log(_debug, 'double.parse error for event: $event');
          status = DsStatus.invalid();
        }
        return DsDataPoint<double>(
          type: DsDataType.real(),
          path: event.path,
          name: event.name,
          value: value,
          status: status,
          timestamp: event.timestamp,
        );
      });
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint
  @override
  Stream<DsDataPoint<T>> stream<T>(String name) {
    return _stream(name);
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<bool>
  @override
  Stream<DsDataPoint<bool>> streamBool(String name, {bool inverse = false}) {
    return _streamToBool(_stream(name), inverse: inverse);
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>
  @override
  Stream<DsDataPoint<int>> streamInt(String name, {int offset = 0}) {
    return _streamToInt(_stream(name), offset: offset);
  }
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint<int>
  @override
  Stream<DsDataPoint<double>> streamReal(String name, {double offset = 0.0}) {
    return _streamToDouble(_stream(name), offset: offset);
  }
  ///
  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint
  @override
  Stream<DsDataPoint> streamMerged(List<String> names) {
    final List<Stream<DsDataPoint>> streams = [];
    for (final name in names) {
      streams.add(
        _stream(name),
      );
    }
    return StreamMerged(streams).stream;
  }
  ///
  /// Слушает socket, 
  /// раскидывает полученные события по подписчикам
  void _socketListen(Socket socket) {
    socket.listen((event) {
        // log(_debug, 'event: $event');
        final str = String.fromCharCodes(event);
        // log(_debug, 'str: $str');
        final rawPoints = str.split('|||');
        for (final rawPoint in rawPoints) {
          if (rawPoint.isNotEmpty) {
            final dataPint = DsDataPoint.fromJson(rawPoint);
              // log(_debug, '_receivers: $_receivers');
            if (_receivers.keys.contains(dataPint.name)) {
              // log(_debug, '[$DsClientReal._run] dataPint: $dataPint');
              final receiver = _receivers[dataPint.name];
              if (receiver != null) {
                if (!receiver.isClosed) {
                  // log(_debug, '[$DsClientReal._run] receiver: ${receiver}');
                  receiver.add(dataPint);
                }
              }
            }
          }
        }
      },
      onError: (e) {
        log(_debug, '[$DsClientReal._run] error: $e');
        _sendLocalBoolPoint(
          name: 'Local.System.Connection',
          value: 0,
        );
        // _socket.close();
      },
      onDone: () {
        log(_debug, '[$DsClientReal] done');
        _isConnected = false;
        _socket.close();
        _sendLocalBoolPoint(
          name: 'Local.System.Connection',
          value: 0,
        );
      },   
    );
  }
  /// 
  /// Запускает DsClient в работу
  /// Подключается к DataServer
  Future<void> _run() async {
    log(_debug, '[$DsClientReal._run]');
    _isActive = true;
    while (!_cancel) {
      if (!_isConnected) {
        await Socket.connect(_ip, _port, timeout: const Duration(seconds: 3))
        .then((socket) {
          _isConnected = true;
          _socket = socket;
          Future.delayed(
            const Duration(milliseconds: 3000),
            () {
              requestAll();
            },
          );
          _sendLocalBoolPoint(
            name: 'Local.System.Connection',
            value: 1,
          );
          log(_debug, '[$DsClientReal._run] connected socket addr: ', socket.address, '\tport', socket.port);
          _socketListen(socket);
        })
        .onError((error, stackTrace) {
          log(_debug, '[$DsClientReal._run] error: $error');
          log(_debug, '[$DsClientReal._run] stackTrace: $stackTrace');
          _isConnected = false;
          _sendLocalBoolPoint(
            name: 'Local.System.Connection',
            value: 0,
          );
        });
      }
      // _socket.add(
      //   utf8.encode('start'),
      // );
      await Future.delayed(const Duration(seconds: 20));
    }
    _isActive = false;
  }
  ///
  /// Локальная посылка для диагностических сигналов
  void _sendLocalBoolPoint({required String name, required int value}) {
    log(_debug, '[$DsClientReal._sendLocalBoolPoint] name: $name');
    if (_receivers.containsKey(name)) {
      final receiver = _receivers[name];
      if (receiver != null) {
        if (!receiver.isClosed) {
          log(_debug, '[$DsClientReal._sendLocalBoolPoint] receiver: $receiver');
          receiver.add(
            DsDataPoint<bool>(
              type: DsDataType.bool(), 
              path: '/Local/', 
              name: name, 
              value: value > 0,
              status: DsStatus.ok(),
              timestamp: DateTime.now().toIso8601String(),
            ),
          );
        }
      }
    } else {
      log(_debug, '[$DsClientReal._sendLocalBoolPoint] error uncnown name: $name');
    }
  }
  ///
  /// Посылает команду сервеер S7 DataServer
  /// Если команда запрашивает данные, 
  /// то они прийдут в текущем активном подключении 
  /// в потоке Stream<DsDataPoint> stream
  /// В качестве результата Result<bool> получает результат записи в socket
  @override
  Response<bool> send({
    required DsDataClass dsClass,
    required DsDataType type,
    required String path,
    required String name,
    required dynamic value,
    required DsStatus status,
    required DsTimeStamp timestamp,
  }) {
    final dsCommand = DsCommand(
      dsClass: dsClass, 
      type: type, 
      path: path, 
      name: name, 
      value: value, 
      status: status,
      timestamp: timestamp,
    );
    log(_debug, '[$DsClientReal.send] dsCommand: $dsCommand');
    try {
      _socket.add(
        utf8.encode(dsCommand.toJson()),
      );
      return const Response<bool>(
        errCount: 0,
        errDump: '',
        data: true,
      );
    } catch (error) {
      log(_debug, '[$DsClientReal.send] error: $error');
      return Response<bool>(
        errCount: 1,
        errDump: '$error',
        data: false,
      );      
    }
  }
  ///
  /// Отправляет в общий поток все локальные точки данных
  void _requestAllLocal() {
    _sendLocalBoolPoint(
      name: 'Local.System.Connection',
      value: _isConnected ? 1 : 0,
    );
  }
  ///
  /// Делает запрос на S7 DataServer что бы получить все точки данных
  /// что бы сервер прочитал и прислал значения всех точек в потоке.
  /// Данные не ждем, они прийдут в потоке
  @override
  Response<bool> requestAll() {
    _requestAllLocal();
    return send(
      dsClass: DsDataClass.requestAll(),
      type: DsDataType.bool(),
      path: '',
      name: '',
      value: 1,
      status: DsStatus.ok(),
      timestamp: DsTimeStamp.now(),
    );
  }
  ///
  /// Делает запрос на S7 DataServer в виде списка имен точек данных
  /// что бы сервер прочитал и прислал значения запрошенных точек в потоке.
  /// Данные не ждем, они прийдут в потоке
  @override
  Response<bool> requestNamed(List<String> names) {
    return send(
      dsClass: DsDataClass.requestList(),
      type: DsDataType.bool(),
      path: '',
      name: '',
      value: names,
      status: DsStatus.ok(),
      timestamp: DsTimeStamp.now(),
    );
  }
  ///
  /// Останавливаем цикл обработки входящего потока данных от S7 DataServer
  Future<bool> cancel() {
    _cancel = true;
    return Future.doWhile(() => _isActive) as Future<bool>;
  }
  ///
  ///
  /// ====================================================================
  /// Методы работающие только в режиме эмуляции для удобства тестирования
  /// ====================================================================
  ///
  /// поток данных отфильтрованный по имени точки данных DsDataPoint
  @override
  Stream<DsDataPoint<double>> streamEmulated(
    String filterByValue, {
    int delay = 100, 
    double min = 0, 
    double max = 100, 
    int firstEventDelay = 0,
  }) {
    throw Failure.unexpected(
      message: '[$DsClientReal.streamEmulated] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }

  ///

  /// поток данных отфильтрованный по массиву имен точек данных DsDataPoint

  @override
  StreamMerged<DsDataPoint> streamMergedEmulated(List<String> names) {
    throw Failure.unexpected(
      message: '[$DsClientReal.streamMergedEmulated] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// Посылает команду сервеер S7 DataServer
  /// Если команда запрашивает данные, 
  /// то они прийдут в текущем активном подключении 
  /// в потоке Stream<DsDataPoint> stream
  /// В качестве результата Result<bool> получает результат записи в socket
  @override
  Response<bool> sendEmulated({
    required DsDataClass dsClass,
    required DsDataType type,
    required String path,
    required String name,
    required dynamic value,
    required DateTime timestamp,
  }) {
    throw Failure.unexpected(
      message: '[$DsClientReal.sendEmulated] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  ///
  /// Делает запрос на S7 DataServer в виде списка имен точек данных
  /// что бы сервер прочитал и прислал значения запрошенных точек в потоке
  /// В качестве результата Result<bool> получает результат чтения из S7 
  /// данные не ждем, они прийдут в потоке
  @override
  Response<bool> requestNamedEmulated(List<String> names) {
    throw Failure.unexpected(
      message: '[$DsClientReal.requestNamedEmulated] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  
  @override
  Stream<DsDataPoint<bool>> streamBoolEmulated(String filterByValue, {int delay = 100}) {
    throw Failure.unexpected(
      message: '[$DsClientReal.streamBoolEmulated] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  
  @override
  Stream<DsDataPoint<double>> streamRequestedEmulated(String filterByValue, {int delay = 500, double min = 0, double max = 100}) {
    throw Failure.unexpected(
      message: '[$DsClientReal.streamRequestedEmulated] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }
  
  @override
  Stream<DsDataPoint<int>> streamEmulatedInt(String filterByValue, {int delay = 100, double min = 0, double max = 100, int firstEventDelay = 0}) {
    throw Failure.unexpected(
      message: '[$DsClientReal.streamEmulatedInt] method not implemented, used only for emulation in the test mode', 
      stackTrace: StackTrace.current,
    );
  }  
}
