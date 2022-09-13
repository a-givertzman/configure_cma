import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/entities/s7_line.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/home/widgets/s7_line_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_dir_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class HomeBody extends StatefulWidget {
  final AppUserStacked _users;
  /// 
  /// Builds home body using current user
  const HomeBody({
    Key? key,
    required AppUserStacked users,
  }) : 
    _users = users,
    super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  static const _debug = true;
  String? _dataServerConfigPath;
  Map<String, S7Line> _lines = {};
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$HomeBody.build]');
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final stateColors = Theme.of(context).stateColors;
    return Transform.scale(
      scale: min(
        width / AppUiSettings.displaySize.width, 
        height / AppUiSettings.displaySize.height,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(blockPadding * 2),
          child: Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /// Row 1
              Row(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/brand_icon.png',
                    scale: 4.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.2),
                  ),
                  /// Путь к flutter проекту
                  Expanded(
                    child: SelectDirWidget(
                      labelText: 'Path to flutter application',
                      onComplete: (value) {
                        
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: blockPadding,),
              /// Путь к файлу конфигурации DataServer
              SelectFileWidget(
                labelText: 'DataServer file',
                allowedExtensions: ['conf', 'cfg', 'json'],
                onComplete: (value) {
                  _dataServerConfigPath = value;
                  _readConfigFile(value)
                  .then((lines) {
                    if (lines.isNotEmpty) {
                      setState(() {
                        _lines = lines;
                        log(_debug, '[_HomeBodyState.build] lines count: ', _lines.length);
                      });
                    }
                  });
                },
              ),
              const SizedBox(height: blockPadding,),
              /// Row 2
              Expanded(
                child: Scrollbar(
                  child: ListView(
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      S7LineWidget(
                        lines: _lines.values.toList(),
                      ),
                    ]
                  ),
                ),
              ),
              const SizedBox(height: blockPadding,),
              /// Row 3
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final dir = dirname(_dataServerConfigPath ?? '');
                      final path = join(dir, 'confNew.json');
                      final file = File(path);
                      if (!file.existsSync()) {
                        await file.create(recursive: true);
                      }
                      final encoder = new JsonEncoder.withIndent("    ");
                      final json = encoder.convert(
                        _lines.map((key, line) {
                          return MapEntry(
                            key, 
                            line,
                          );
                        })
                      );
                      await file.writeAsString(json);
                    }, 
                    child: Text('Update config'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  ///
  Future<Map<String, S7Line>> _readConfigFile(String? path) {
    if (path != null) {
      final file = File(path);
      return file.readAsString().then((value) {
        // log(_debug, value);
        Map<String, dynamic> config = json.decode(value);
        return config.map((key, line) {
          return MapEntry(
            key, 
            S7Line(key, line),
          );
        });
      });
    }
    return Future.value({});
  }
}


