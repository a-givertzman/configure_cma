import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/entities/ds_config.dart';
import 'package:configure_cma/domain/core/entities/network_operation_state.dart';
import 'package:configure_cma/domain/core/entities/s7_line.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/home/widgets/s7_line_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_dir_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  final AppUserStacked _users;
  final DsClient? _dsClient;
  /// 
  /// Builds home body using current user
  const HomeBody({
    Key? key,
    required AppUserStacked users,
    DsClient? dsClient,
  }) : 
    _users = users,
    _dsClient = dsClient,
    super(key: key);
  ///
  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  static const _debug = true;
  final _state = NetworkOperationState();
  final ScrollController _scrollController = ScrollController();
  final DSConfig _dsConfig = DSConfig();
  String? _cmaAppPath;
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
                        _cmaAppPath = value;
                      },
                      icon: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      log(_debug, '[$_HomeBodyState.build] SAVING to flutter app');
                      if (_state.isSaving || _state.isLoading) {
                        return;
                      }
                      setState(() => _state.setSaving());
                      _dsConfig.writeCmaConfig(
                        cmaPath: _cmaAppPath,
                        lines: _lines,
                        backup: true,
                      ).whenComplete(() {
                        setState(() => _state.setSaved());
                      });
                    }, 
                    icon: Tooltip(
                      child: Icon(Icons.file_upload, color: Theme.of(context).colorScheme.primary),
                      message: 'Save config',
                    ),
                  ),
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
                    onComplete: (path) {
                      if (_state.isSaving || _state.isLoading) {
                        return;
                      }
                      setState(() {
                        _lines = {};
                        _state.setLoading();
                      });
                      _dsConfig.read(path).then((lines) {
                        if (lines.isNotEmpty) {
                          setState(() {
                            _lines = lines;
                            log(_debug, '[_HomeBodyState.build] lines count: ', _lines.length);
                          });
                        }
                      }).whenComplete(() {
                        setState(() => _state.setLoaded());
                      });
                    },
                    icon: Icon(Icons.more_horiz, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    log(_debug, '[$_HomeBodyState.build] SAVING');
                    if (_state.isSaving || _state.isLoading) {
                      return;
                    }
                    setState(() => _state.setSaving());
                    _dsConfig.write(
                      lines: _lines,
                      bacup: true,
                    ).whenComplete(() {
                      setState(() => _state.setSaved());
                    });
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
    } else if (_state.isSaving) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Text('Saving...'),
        ],
      );
    } else if (_lines.isNotEmpty) {
      return S7LineWidget(
        dsClient: widget._dsClient,
        lines: _lines.values.toList(),
      );
    } else {
      return Center(child: Text('Now data'));
    }    
  }
}


