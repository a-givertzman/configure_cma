import 'dart:convert';
import 'dart:io';

import 'package:configure_cma/domain/core/entities/s7_line.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:path/path.dart';
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

class DSConfig {
  static const _debug = false;
  late String? _path = null;
  late String? _cmaPath = null;
  late Map<String, dynamic> _config;
  ///
  /// Конфигурация DataServer
  DSConfig();
  ///
  Future<Map<String, S7Line>> read(String? path) {
    if (path != null) {
      _path = path;
      return _readYaml(path).then((config) {
        // log(_debug, value);
        _config = config;
        if (_config.containsKey('data_source')) {
          final Map<String, dynamic> dataSource = _config['data_source'];
          if (dataSource.containsKey('lines')) {
            final Map<String, dynamic> lines = dataSource['lines'];
            return lines.map((key, line) {
              return MapEntry(
                key, 
                S7Line(key, line),
              );
            });
          }
        }
        return {};
      });
    }
    return Future.value({});
  }
  ///
  Future<Map<String, dynamic>> _readYaml(String path) {
      final file = File(path);
      return file.readAsString().then((value) {
        return (loadYaml(value) as YamlMap).toMap();
      });
  }
  ///
  // Future<Map<String, dynamic>> _readJson(String path) {
  //     final file = File(path);
  //     return file.readAsString().then((value) {
  //       // log(_debug, value);
  //       return json.decode(value);
  //     });
  // }
  /// Make a backup of the file
  Future<void> _backupFile(String path) async {
    final dir = dirname(path);
    final name = basename(path);
    final backupFile = File(path);
    if (backupFile.existsSync()) {
      final t = DateTime.now();
      final timeTag = '${t.year}.${t.month}.${t.day}_${t.hour}.${t.minute}.${t.second}_';
      await backupFile.rename(join(dir, '$timeTag$name'));
    }
  }
  ///
  Future<void> write({required Map<String, S7Line> lines, bool bacup = false}) async {
    final path = _path;
    if (path != null && path.isNotEmpty) {
      _config['data_source']['lines'] = lines;
      await _backupFile(path);
      await _writeYaml(path,_config);
    }
  }
  ///
  Future<void> _writeYaml(String path, Map<String, dynamic> config) async {
      final file = File(path);
      if (!file.existsSync()) {
        await file.create(recursive: true);
      }
      var yamlWriter = YAMLWriter(indentSize: 4);
      final yamlDoc = yamlWriter.write(config);
      log(_debug, "[DSConfig._writeYaml] yamlDoc: $yamlDoc");
      await file.writeAsString(yamlDoc);
  }  ///
  Future<void> _writeJson(String path, Map<String, dynamic> config) async {
      final file = File(path);
      if (!file.existsSync()) {
        await file.create(recursive: true);
      }
      final encoder = new JsonEncoder.withIndent("    ");
      final jsonDoc = encoder.convert(config);
      await file.writeAsString(jsonDoc);
  }
  ///
  Future<void> writeCmaConfig({required String? cmaPath, required Map<String, S7Line> lines, bool backup = false}) async {
    _cmaPath = cmaPath;
    if (cmaPath != null && cmaPath.isNotEmpty) {
      final dir = join(dirname(cmaPath), 'assets/alarm/');
      final alarmListName = 'alarm-list.json';
      final path = join(dir, alarmListName);
      await _backupFile(path);
      final file = File(path);
      if (!file.existsSync()) {
        await file.create(recursive: true);
      }
      final encoder = new JsonEncoder.withIndent("    ");
      final alarmList = {};
      lines.forEach((key, line) {
        line.ieds.forEach((key, ied) {
          ied.dbs.forEach((key, db) {
            db.updateDbSize();
            db.points.forEach((key, point) {
              final alarm = point.a;
              if (alarm != null && alarm > 0) {
                alarmList.addAll({
                  point.name: {'class': point.a},
                });
              }
            });
          });
        },);
      });
      final json = encoder.convert(alarmList);
      await file.writeAsString(json);
    }
  }
}


extension YamlMapConverter on YamlMap {
  ///
  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return (v).toMap();
    }
    else if (v is YamlList) {
      var list = <dynamic>[];
      v.forEach((e) { list.add(_convertNode(e)); });
      return list;
    }
    else {
      return v;
    }
  }
  ///
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    this.nodes.forEach((k, v) {
      map[(k as YamlScalar).value.toString()] = _convertNode(v.value);
    });
    return map;
  }
}