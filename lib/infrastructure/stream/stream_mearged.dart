import 'dart:async';

import 'package:configure_cma/domain/core/log/log.dart';

/// Поток объединяющий события из нескольких потоков без трансформации
class StreamMerged<T> {
  static const _debug = true;
  final List<bool> _closed = [];
  final List<Stream<T>>_streams;
  final T Function(List<T?> values)? _handler;
  final StreamController<T> _streamController = StreamController<T>();
  final Completer _completer = Completer();
  final List<T?> _lastEvents = [];
  ///
  StreamMerged(
    List<Stream<T>> streams, {
    T Function(List<T?> values)? handler,
  }) : 
    _streams = streams,
    _handler = handler,
    super();
  ///
  Stream<T> get stream {
    _streamController.onListen = _onListen;
    return _streamController.stream;
  }
  ///
  void _onListen() {
    final handler = _handler;
    if (handler != null) {
      _streams.asMap().forEach((index, stream) { 
        _closed.add(false);
        _lastEvents.add(null);
        log(_debug, '[$StreamMerged._onListen] stream: ', stream);
        stream.listen(
          (event) {
            _lastEvents[index] = event;
            final e = handler(_lastEvents);
            _streamController.add(e);
          },
          onError: (Object error, StackTrace stackTrace) {
            _streamController.addError(error, stackTrace);
          },
          onDone: () {
            if (_closed.isNotEmpty) {
              _closed.removeLast();
              if (_closed.isEmpty) {
                _streamController.close();
                _completer.complete();
              }
            }
            log(_debug, '[$StreamMerged.onDone] _closed: ', _closed);
          },
        );
      });
    } else {
      for (final stream in _streams) {
        _closed.add(false);
        log(_debug, '[$StreamMerged._onListen] stream: ', stream);
        stream.listen(
          (event) {
            _streamController.add(event);
          },
          onError: (Object error, StackTrace stackTrace) {
            _streamController.addError(error, stackTrace);
          },
          onDone: () {
            if (_closed.isNotEmpty) {
              _closed.removeLast();
              if (_closed.isEmpty) {
                _streamController.close();
                _completer.complete();
              }
            }
            log(_debug, '[$StreamMerged.onDone] _closed: ', _closed);
          },
        );
      }
    }
  }
  ///
  /// Событие завершения обединенного потока
  /// возникает когда все входящие потоки завершены
  Future get done => _completer.future;
}
