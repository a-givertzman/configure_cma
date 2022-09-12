class Response<T> {
  final int _errCount;
  final String _errDump;
  final T? _data;
  const Response({
    required int errCount,
    required String errDump,
    T? data,
  }):
    _errCount = errCount,
    _errDump = errDump,
    _data = data;
  bool hasData() {
    return _data != null;
  }
  bool hasError() {
    return _errCount > 0;
  }
  String errorMessage() {
    return _errDump;
  }
  int errorCount() {
    return _errCount;
  }
  T? data() {
    return _data;
  }
  @override
  String toString() {
    return 'data: $_data\nerrCount: $_errCount\nerrDump: "$_errDump"';
  }
}
