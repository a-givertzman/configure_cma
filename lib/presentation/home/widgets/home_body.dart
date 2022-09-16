import 'dart:convert';
import 'dart:io';

import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/entities/network_operation_state.dart';
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
  final _state = NetworkOperationState();
  final ScrollController _scrollController = ScrollController();
  String? _dataServerConfigPath;
  Map<String, S7Line> _lines = {};
  List<bool> _resetNewPoints = [];
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
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width,
        maxHeight: height,
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Row 1
          SizedBox(
            width: width * 0.8,
            child: Padding(
              padding: const EdgeInsets.only(top: padding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image.asset(
                  //   'assets/img/brand_icon.png',
                  //   scale: 4.0,
                  //   opacity: const AlwaysStoppedAnimation<double>(0.2),
                  // ),
                  /// Путь к flutter проекту
                  Expanded(
                    child: SelectDirWidget(
                      labelText: 'Path to flutter application',
                      onComplete: (value) {
                        
                      },
                      icon: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  IconButton(onPressed: null, icon: Icon(null)),
                ],
              ),
            ),
          ),
          // const SizedBox(height: blockPadding,),
          /// Путь к файлу конфигурации DataServer
          SizedBox(
            width: width * 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SelectFileWidget(
                    editable: true,
                    labelText: 'Path to DataServer config file',
                    allowedExtensions: ['conf', 'cfg', 'json'],
                    onComplete: (value) {
                      setState(() {
                        _lines = {};
                        _state.setLoading();
                      });
                      _dataServerConfigPath = value;
                      _readConfigFile(value).then((lines) {
                        if (lines.isNotEmpty) {
                          setState(() {
                            _lines = lines;
                            _resetNewPoints.add(true);
                            log(_debug, '[_HomeBodyState.build] lines count: ', _lines.length);
                          });
                        }
                        setState(() => _state.setLoaded());
                      });
                    },
                    icon: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    log(_debug, '[$_HomeBodyState.build] SAVING');
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
                    setState(() {});
                  }, 
                  icon: Tooltip(
                    child: Icon(Icons.file_upload, color: Theme.of(context).colorScheme.primary),
                    message: 'Save config',
                  ),
                ),                  
              ],
            ),
          ),
          const SizedBox(height: blockPadding,),
          /// Row 2
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: padding,
                  right: padding,
                  bottom: padding,
                ),
                child: Scrollbar(
                  controller: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    children: [
                      _buildListViewWidget(),
                    ]
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildListViewWidget() {
    if (_state.isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('Loading...'),
        ],
      );
    } else if (_lines.isNotEmpty) {
      return S7LineWidget(
        lines: _lines.values.toList(),
        resetNewPoints: _resetNewPoints,
      );
    } else {
      return Center(child: Text('Now data'));
    }    
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


