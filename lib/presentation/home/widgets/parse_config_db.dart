import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';

const structOpenRegexPattern = r'\bSTRUCT\b|\b.+:.+\bStruct\b';
const structCloseRegexPattern = r'\bEND_STRUCT\b';

///
class ParseConfigDb {
  static const _debug = true;
  final List<String> _lines;
  final String _path;
  ParseState _state = ParseState.initial;
  ///
  ParseConfigDb(String path, List<String> lines) :
    _path = path,
    _lines = lines;
  ///
  Map<String, dynamic> parse() {
    // log(_debug, '[$ParseConfigDb.parse] _lines:\n', _lines);
    final Map<String, dynamic> result = {};
    int index = 0;
    // final lines = List.from(_lines);
    while (_lines.isNotEmpty) {
      final line = _lines.first;
      final matchStructOpen = _matchStructOpen(line);
      final matchStructClose = _matchStructClose(line);
      log(_debug, '$_path match: ', matchStructOpen);
      log(_debug, '$_path match: ', matchStructClose);      
      if (_state == ParseState.initial) {
        if (matchStructOpen != null) {
          _state = ParseState.structOpen;
          log(_debug, '$_path: OPEN');
        }
      } else 
      if (_state == ParseState.structOpen) {
        final lineItems = line.trim().split(' ');
        final name = lineItems[0];
        if (matchStructOpen != null) {
          result['$name'] = ParseConfigDb(
            '$_path$name.', 
            _lines,
          ).parse();
        } else
        if (matchStructClose != null) {
          _state = ParseState.structClose;
          log(_debug, '$_path: CLOSE');
        } else {
          result['$_path$name'] = lineItems[2];
          log(_debug, '$_path | ', line.trim());
        }
      }
      if (_state == ParseState.structClose) {
        log(_debug, '$_path: closed');
        return result;
      }
      _lines.removeAt(index);
    }
    throw Failure.convertion(
      message: 'Struct "$_path" wath not closed', 
      stackTrace: StackTrace.current
    );
  }
  ///
  String? _matchStructOpen(String line) {
    return RegExp(structOpenRegexPattern).firstMatch(line)?[0];
  }
  ///
  String? _matchStructClose(String line) {
    return RegExp(structCloseRegexPattern).firstMatch(line)?[0];
  }
}

enum ParseState {
  initial(0),
  structOpen(1),
  structClose(2);
  const ParseState(this.value);
  final int value;
}


