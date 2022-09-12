import 'package:configure_cma/domain/core/log/log.dart';

abstract class Failure<T> {
  static const _debug = true;
  late T message;
///
/// Ganeral Failures
  factory Failure({
    required T message, 
    required StackTrace stackTrace,
  }) {
    // TODO: implement error reporting here
    log(_debug, message);
    log(_debug, stackTrace);
    throw UnimplementedError(message.toString());
  }
  //
  // dataSource failure
  factory Failure.dataSource({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // dataObject failure
  factory Failure.dataObject({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // dataCollection failure
  factory Failure.dataCollection({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // auth failure
  factory Failure.auth({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // convertion failure
  factory Failure.convertion({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // Connection failure
  factory Failure.connection({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  // Translation failure
  factory Failure.translation({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
  //
  // Unexpected failure
  factory Failure.unexpected({
    required T message,
    required StackTrace stackTrace,
  }) => Failure(message: message, stackTrace: stackTrace);
}
