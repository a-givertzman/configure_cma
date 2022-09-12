import 'dart:io';

import 'package:crane_monitoring_app/domain/auth/app_user.dart';
import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/crane/crane_mode_state.dart';
import 'package:crane_monitoring_app/infrastructure/datasource/data_source.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme_switch.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/button/circular_fab_widget.dart';
import 'package:crane_monitoring_app/presentation/demo/widgets/demo_body.dart';
import 'package:crane_monitoring_app/presentation/nav/app_nav.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

enum ViewFilter {all, prepare, active, purchase, distribute, archived, canceled}


class DemoPage extends StatefulWidget {
  final DataSource dataSource;
  final AppUserSingle user;
  final DsClient _dsClient;
  final AppThemeSwitch themeSwitch;
  ///
  const DemoPage({
    Key? key,
    required this.dataSource,
    required this.user,
    required DsClient dsClient,
    required this.themeSwitch,
  }) : 
    _dsClient = dsClient,
    super(key: key);
  ///
  @override
  State<DemoPage> createState() => _HomePageState();
}


class _HomePageState extends State<DemoPage> {
  static const _debug = true;
  late AppUserStacked _users;
  late DsClient _dsClient;
  // late List<String> _statusList;
  // late ViewFilter _viewFilter;
  ///
  @override
  void initState() {
    _users = AppUserStacked(
      appUser: widget.user,
    );
    super.initState();
    _dsClient = widget._dsClient;
  }
  ///
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    log(_debug, '[_HomePageState.build] user: ', user);
    // final userGroup = AppUserGroup('${user['group']}');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final dw = (width - AppUiSettings.displaySize.width) / 2;
    final dh = (height - AppUiSettings.displaySize.height) / 2;
    // TODO fix for release
    if (Platform.isLinux) {
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: _buildMenuWidget(context),
        // appBar: _appBar(userGroup),
        body: Center(
          child: DemoBody(
            users: _users,
            dsClient: _dsClient,
            craneModeState: CraneModeState(
              stream: _dsClient.streamMergedEmulated([
              // stream: _dsClient.streamMerged([
                'craneMode.main',
                // 'craneMode.activeWinch',
                // 'craneMode.winch1Mode',
                // 'craneMode.winch2Mode',
                // 'craneMode.winch3Mode',
                // 'craneMode.waveHeightLevel',
                // 'craneMode.constantTensionLevel', ???
                // 'craneMode.constantTensionActive', ???
              ]).stream,
            ),
          ),
        ),
      ),
    );
  }

  ///
  CircularFabWidget _buildMenuWidget(BuildContext context) {
    return CircularFabWidget(
        icon: const Icon(Icons.menu, size: 45.0,),
        // onPressed: () {
        // },
        children: [
          FloatingActionButton(
            heroTag: 'FloatingActionButtonHome', 
            child: const Icon(Icons.home, size: 45.0,),
            onPressed: () {
            },
          ),
          FloatingActionButton(
            heroTag: 'FloatingActionButtonTheme', 
            child: const Icon(Icons.color_lens_outlined, size: 45.0,),
            onPressed: () {
              final theme = widget.themeSwitch.theme == AppTheme.light
                ? AppTheme.dark 
                : AppTheme.light;
              widget.themeSwitch.toggleTheme(theme);
            },
          ),
          // FloatingActionButton(
          //   heroTag: 'FloatingActionButtonUserAccount', 
          //   child: const Icon(Icons.account_circle_outlined, size: 45.0,),
          //   onPressed: () {
          //     Navigator.of(context).pop(true);
          //   },
          // ),
          FloatingActionButton(
            heroTag: 'FloatingActionButtonHomeLogout', 
            child: const Icon(Icons.logout, size: 45.0,),
            onPressed: () {
               _users.clear();
              AppNav.logout(context);
            },
          ),
        ],
      );
  }
  // List<String> _viewStatusList(AppUser user, ViewFilter viewFilter) {
  //   final userGroup = AppUserGroup('${user['group']}').value;
  //   switch (viewFilter) {
  //     case ViewFilter.all:
  //       return [
  //         UserGroupList.operator,
  //       ].contains(userGroup)
  //         ? ['active', 'purchase', 'distribute', 'archived',]
  //         : ['prepare', 'active', 'purchase', 'distribute', 'archived', 'canceled',];
  //     case ViewFilter.prepare:
  //       return ['prepare',];
  //     case ViewFilter.active:
  //       return ['active', 'purchase', 'distribute',];
  //     case ViewFilter.purchase:
  //       return ['purchase',];
  //     case ViewFilter.distribute:
  //       return ['distribute',];
  //     case ViewFilter.archived:
  //       return ['archived',];
  //     case ViewFilter.canceled:
  //       return ['canceled',];
  //     default:
  //       return ['active',];
  //   }
  // }
}
