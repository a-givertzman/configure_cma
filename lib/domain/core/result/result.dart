import 'package:configure_cma/domain/core/error/failure.dart';

/// 
/// Результат выполнения операции
class Result<T> {
  final T? _data;
  final Failure? _error;
  ///
  Result({
    T? data,
    Failure? error,
  }):
    _data = data, 
    _error = error;
  ///
  T? get data => _data;
  ///
  String? get message => _error?.message;
  ///
  Failure? get error => _error;
  ///
  bool get hasData => _data != null;
  ///
  bool get hasError => _error != null;
  ///
  @override
  String toString() {
    String str = '$runtimeType {';
    str += '\n\tdata: $_data,';
    str += '\n\terror: $_error,';
    return str;
  }
}
