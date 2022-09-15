import 'package:configure_cma/domain/core/entities/ds_data_type.dart';
import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/domain/core/log/log.dart';

const structOpenRegexPattern = r'\bSTRUCT\b|\b.+:.+\bStruct\b';
const structCloseRegexPattern = r'\bEND_STRUCT\b';

///
class ParseConfigDb {
  static const _debug = true;
  final List<String> _lines;
  final String _path;
  ParseOffset _offset;
  ParseState _state = ParseState.initial;
  ///
  ParseConfigDb({
    String path = '', 
    required ParseOffset offset,
    required List<String> lines,
  }) :
    _path = path,
    _offset = offset,
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
        final tagName = RegExp(r'\b\w+\b').firstMatch(line)?[0];
        final tagType = RegExp(r':\s(\b\w+\b)').firstMatch(line)?[1];
        if (matchStructOpen != null) {
          result['$tagName'] = ParseConfigDb(
            path: '$_path$tagName.', 
            offset: _offset,
            lines: _lines,
          ).parse();
        } else
        if (matchStructClose != null) {
          _state = ParseState.structClose;
          log(_debug, '$_path: CLOSE');
        } else {
          result['$_path$tagName'] = {'type': tagType, 'offset': _offset.value};
          log(_debug, '$_path | ', {'type': tagType, 'offset': _offset.value});
          _offset.add(DsDataType.fromString('$tagType').length);
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

class ParseOffset {
  int _v;
  ParseOffset(int value) : _v = value;
  add(int value) {
    _v += value;
  }
  int get value => _v;
}