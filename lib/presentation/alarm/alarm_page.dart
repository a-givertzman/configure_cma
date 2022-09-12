import 'dart:io';

import 'package:crane_monitoring_app/domain/alarm/alarm_list_point.dart';
import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/event/event_list_data.dart';
import 'package:crane_monitoring_app/infrastructure/datasource/data_source.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/alarm/widgets/alarm_body.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme_switch.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/button/circular_fab_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/right_icon_widget.dart';
import 'package:crane_monitoring_app/presentation/nav/app_nav.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';


class AlarmPage extends StatefulWidget {
  final DataSource dataSource;
  final AppUserStacked _users;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _listData;
  final AppThemeSwitch _themeSwitch;
  ///
  const AlarmPage({
    Key? key,
    required this.dataSource,
    required AppUserStacked users,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    required AppThemeSwitch themeSwitch,
  }) : 
    _dsClient = dsClient,
    _listData = listData,
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<AlarmPage> createState() => _AlarmPageState(
    dsClient: _dsClient,
    listData: _listData,
    users: _users,
    themeSwitch: _themeSwitch,
  );
}


class _AlarmPageState extends State<AlarmPage> {
  static const _debug = true;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _listData;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  // late List<String> _statusList;
  // late ViewFilter _viewFilter;
  ///
  _AlarmPageState({
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _dsClient = dsClient,
    _listData = listData,
    _users = users,
    _themeSwitch = themeSwitch,
    super();
  ///
  @override
  void initState() {
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    log(_debug, '[_AlarmPageState.build] user: ', user);
    // final userGroup = AppUserGroup('${user['group']}');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final dw = (width - AppUiSettings.displaySize.width) / 2;
    final dh = (height - AppUiSettings.displaySize.height) / 2;
    // TODO fix for release
    if (Platform.isLinux || Platform.isMacOS) {
      return _buildScaffold(context);
    } else {
      // TODO Remove Container & SafeArea on release
      return Container(
        color: Theme.of(context).backgroundColor.withOpacity(0.7),
        child: SafeArea(
          minimum: EdgeInsets.symmetric(
            horizontal: dw,
            vertical: dh,
          ),
          child: _buildScaffold(context),
        ),
      );
    } 
  }
  ///
  Widget _buildScaffold(BuildContext context) {
    // const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(blockPadding),
          child: _buildMenuWidget(context),
        ),
        body: AlarmBody(
          // users: _users,
          dsClient: _dsClient,
          listData: _listData,
        ),
      ),
    );
  }
  ///
  Stack _buildMenuWidget(BuildContext context) {
    const floatingActionIconSize = AppUiSettings.floatingActionIconSize;
    return Stack(
      children: [
        CircularFabWidget(
          buttonSize: AppUiSettings.floatingActionButtonSize,
          icon: Icon(Icons.menu, size: floatingActionIconSize),
          // onPressed: () {
          // },
          children: [
            FloatingActionButton(
              heroTag: 'FloatingActionButtonHome', 
              child: Icon(Icons.home, size: floatingActionIconSize),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            FloatingActionButton(
              heroTag: 'FloatingActionButtonTheme', 
              child: Icon(Icons.color_lens_outlined, size: floatingActionIconSize),
              onPressed: () {
                final theme = _themeSwitch.theme == AppTheme.light
                  ? AppTheme.dark 
                  : AppTheme.light;
                _themeSwitch.toggleTheme(theme);
              },
            ),
            // FloatingActionButton(
            //   heroTag: 'FloatingActionButtonUserAccount', 
            //   child: Icon(Icons.account_circle_outlined, size: floatingActionIconSize),
            //   onPressed: () {
            //   },
            // ),
            FloatingActionButton(
              heroTag: 'FloatingActionButtonHomeLogout', 
              child: Icon(Icons.logout, size: floatingActionIconSize),
              onPressed: () {
                 _users.clear();
                AppNav.logout(context);
              },
            ),
          ],
        ),
        Positioned(
          right: 0,
          child: RightIconWidget(
            users: _users,
            dsClient: _dsClient,
          ),
        ),        
      ],
    );
  }
}
