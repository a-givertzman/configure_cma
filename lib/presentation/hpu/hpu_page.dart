import 'dart:io';

import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/infrastructure/datasource/data_source.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:configure_cma/presentation/core/widgets/button/circular_fab_widget.dart';
import 'package:configure_cma/presentation/core/widgets/right_icon_widget.dart';
import 'package:configure_cma/presentation/hpu/widgets/hpu_body.dart';
import 'package:configure_cma/presentation/nav/app_nav.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';


class HpuPage extends StatefulWidget {
  final DataSource dataSource;
  final AppUserStacked _users;
  final DsClient _dsClient;
  final AppThemeSwitch _themeSwitch;
  ///
  const HpuPage({
    Key? key,
    required this.dataSource,
    required AppUserStacked users,
    required DsClient dsClient,
    required AppThemeSwitch themeSwitch,
  }) : 
    _dsClient = dsClient,
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<HpuPage> createState() => _HpuPageState(
    dsClient: _dsClient,
    users: _users,
    themeSwitch: _themeSwitch,
  );
}


class _HpuPageState extends State<HpuPage> {
  static const _debug = true;
  final DsClient _dsClient;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  // late List<String> _statusList;
  // late ViewFilter _viewFilter;
  ///
  _HpuPageState({
    required DsClient dsClient,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _dsClient = dsClient,
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
    log(_debug, '[_HpuPageState.build] user: ', user);
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
        // appBar: _appBar(userGroup),
        body: HpuBody(
          users: _users,
          dsClient: _dsClient,
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
