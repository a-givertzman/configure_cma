import 'dart:io';

import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/infrastructure/datasource/data_source.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/infrastructure/stream/ds_client_real.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:configure_cma/presentation/core/widgets/button/circular_fab_widget.dart';
import 'package:configure_cma/presentation/core/widgets/right_icon_widget.dart';
import 'package:configure_cma/presentation/home/widgets/home_body.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:configure_cma/settings/communication_settings.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  final DataSource dataSource;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  ///
  const HomePage({
    Key? key,
    required this.dataSource,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) : 
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<HomePage> createState() => _HomePageState(
    users: _users,
    themeSwitch: _themeSwitch,
  );
}


class _HomePageState extends State<HomePage> {
  static const _debug = true;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  late DsClient _dsClient;
  // late List<String> _statusList;
  // late ViewFilter _viewFilter;
  ///
  _HomePageState({
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) :
    _users = users,
    _themeSwitch = themeSwitch,
    super();
  ///
  @override
  void initState() {
    super.initState();
    _dsClient = DsClientReal(
      ip: AppCommunicationSettings.dsClientIp, 
      port: AppCommunicationSettings.dsClientPort,
      );    
  }
  ///
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    log(_debug, '[_HomePageState.build] user: ', user);
    // final userGroup = AppUserGroup('${user['group']}');
    return _buildScaffold(context);
  }
  ///
  Widget _buildScaffold(BuildContext context) {
    const blockPadding = AppUiSettings.blockPadding;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(blockPadding),
          child: _buildMenuWidget(context),
        ),
        body: HomeBody(
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
          icon: Icon(Icons.menu, size: floatingActionIconSize,),
          // onPressed: () {
          // },
          children: [
            // FloatingActionButton(
            //   heroTag: 'FloatingActionButtonHome', 
            //   child: Icon(Icons.home, size: floatingActionIconSize,),
            //   onPressed: () {
            //     Navigator.of(context).pop(false);
            //   },
            // ),
            FloatingActionButton(
              heroTag: 'FloatingActionButtonTheme', 
              child: Icon(Icons.color_lens_outlined, size: floatingActionIconSize,),
              onPressed: () {
                final theme = _themeSwitch.theme == AppTheme.light
                  ? AppTheme.dark 
                  : AppTheme.light;
                _themeSwitch.toggleTheme(theme);
              },
            ),
            // FloatingActionButton(
            //   heroTag: 'FloatingActionButtonUserAccount', 
            //   child: Icon(Icons.account_circle_outlined, size: floatingActionIconSize,),
            //   onPressed: () {
            //   },
            // ),
            FloatingActionButton(
              heroTag: 'FloatingActionButtonHomeLogout', 
              child: Icon(Icons.close, size: floatingActionIconSize,),
              onPressed: () {
                exit(0);
                //  _users.clear();
                // AppNav.logout(context);
              },
            ),
          ],
        ),
        Positioned(
          right: 0,
          child: RightIconWidget(
            users: _users,
          ),
        ),
      ],
    );
  }
  ///
  @override
  void dispose() {
    super.dispose();
  }
}
