/// 
/// Результат выполнения сетевой операции DsClient
class DsResult {
  final bool _success;
  final String _message;
  final Exception? _error;
  ///
  DsResult({
    required bool authenticated,
    required String message,
    Exception? error,
  }):
    _success = authenticated, 
    _message = message,
    _error = error;
  ///
  bool get authenticated => _success;
  ///
  String get message => _message;
  ///
  Exception? get error => _error;
  ///
  @override
  String toString() {
    String str = '$DsResult {';
    str += '\n\tauthenticated: $_success,';
    str += '\n\tmessage: $_message,';
    str += '\n\terror: $_error,';
    return str;
  }
}
