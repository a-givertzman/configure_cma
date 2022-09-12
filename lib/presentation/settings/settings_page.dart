import 'dart:io';

import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/datasource/data_source.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme_switch.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/button/circular_fab_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/right_icon_widget.dart';
import 'package:crane_monitoring_app/presentation/nav/app_nav.dart';
import 'package:crane_monitoring_app/presentation/settings/widgets/settings_basic_protections_tab.dart';
import 'package:crane_monitoring_app/presentation/settings/widgets/settings_hpu_tab.dart';
import 'package:crane_monitoring_app/presentation/settings/widgets/settings_main_boom_tab.dart';
import 'package:crane_monitoring_app/presentation/settings/widgets/settings_main_winch_tab.dart';
import 'package:crane_monitoring_app/presentation/settings/widgets/settings_rotary_boom_tab.dart';
import 'package:crane_monitoring_app/presentation/settings/widgets/settings_rotation_tab.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
class SettingsPage extends StatefulWidget {
  final DataSource dataSource;
  final AppUserStacked _users;
  final DsClient _dsClient;
  final AppThemeSwitch _themeSwitch;
  ///
  const SettingsPage({
    Key? key,
    required this.dataSource,
    required AppUserStacked users,
    required DsClient dsClient,
    required AppThemeSwitch themeSwitch,
  })  : _dsClient = dsClient,
        _users = users,
        _themeSwitch = themeSwitch,
        super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<SettingsPage> createState() => _SettingsPageState(
        dsClient: _dsClient,
        users: _users,
        themeSwitch: _themeSwitch,
      );
}

///
class _SettingsPageState extends State<SettingsPage>
    with TickerProviderStateMixin {
  static const _debug = true;
  final DsClient _dsClient;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  late TabController _tabController;
  int _prevTabIndex = -1;
  // late List<String> _statusList;
  // late ViewFilter _viewFilter;
  ///
  _SettingsPageState({
    required DsClient dsClient,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  })  : _dsClient = dsClient,
        _users = users,
        _themeSwitch = themeSwitch,
        super();
  ///
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });
    _tabController = TabController(
      initialIndex: 0,
      length: 6,
      vsync: this,
    );
    _tabController.addListener(() {
      if (_prevTabIndex != _tabController.index) {
        _prevTabIndex = _tabController.index;
        log(_debug,
            '[$_SettingsPageState._tabController.addListener] tabIndex: $_prevTabIndex');
        if (_dsClient.isConnected()) {
          _dsClient.requestAll();
        }
      }
    });
  }
  ///
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    log(_debug, '[_SettingsPageState.build] user: ', user);
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
    final tabTextStyle = Theme.of(context).textTheme.bodyMedium;
    final tabIconColor = Theme.of(context).colorScheme.onBackground;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(blockPadding),
          child: _buildMenuWidget(context),
        ),
        body: _buildTabControllerWidget(tabTextStyle, tabIconColor),
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
              child:
                  Icon(Icons.color_lens_outlined, size: floatingActionIconSize),
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
  ///
  DefaultTabController _buildTabControllerWidget(
      TextStyle? tabTextStyle, Color tabIconColor) {
    return DefaultTabController(
      length: 6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: AppUiSettings.floatingActionButtonSize * 2,
                  right: AppUiSettings.floatingActionButtonSize * 2),
              child: _buildTabBar(tabTextStyle, tabIconColor)),
          Flexible(
            child: _buildTabBarView(),
          ),
        ],
      ),
    );
  }
  ///
  TabBarView _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        SettingsBasicProtectionsTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsHpuTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsMainWinchTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsMainBoomTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsRotaryBoomTab(
          users: _users,
          dsClient: _dsClient,
        ),
        SettingsRotationTab(
          users: _users,
          dsClient: _dsClient,
        ),
      ],
    );
  }
  ///
  TabBar _buildTabBar(TextStyle? tabTextStyle, Color tabIconColor) {
    return TabBar(
      controller: _tabController,
      tabs: [
        Tab(
          child: Text(
            AppText('Basic protections').local,
            textAlign: TextAlign.center,
            style: tabTextStyle,
          ),
          icon: Icon(Icons.settings_outlined, color: tabIconColor),
        ),
        Tab(
          child: Text(
            AppText('HPU').local,
            textAlign: TextAlign.center,
            style: tabTextStyle,
          ),
          icon: Icon(Icons.settings_outlined, color: tabIconColor),
        ),
        Tab(
          child: Text(
            AppText('Winch 1').local,
            textAlign: TextAlign.center,
            style: tabTextStyle,
          ),
          icon: ImageIcon(Image.asset('assets/icons/winch.png').image,
              color: tabIconColor),
          // icon: Icon(Icons.settings_outlined, color: tabIconColor),
        ),
        Tab(
          child: Text(
            AppText('Main boom').local,
            textAlign: TextAlign.center,
            style: tabTextStyle,
          ),
          icon: ImageIcon(Image.asset('assets/icons/main-boom.png').image,
              color: tabIconColor),
          // icon: Icon(Icons.settings_outlined, color: tabIconColor),
        ),
        Tab(
          child: Text(
            AppText('Knuckle jib').local,
            textAlign: TextAlign.center,
            style: tabTextStyle,
          ),
          icon: ImageIcon(Image.asset('assets/icons/rotary-boom.png').image,
              color: tabIconColor),
          // icon: Icon(Icons.settings_outlined, color: tabIconColor),
        ),
        Tab(
          child: Text(
            AppText('Rotarion').local,
            textAlign: TextAlign.center,
            style: tabTextStyle,
          ),
          icon: Icon(Icons.settings_outlined, color: tabIconColor),
        ),
      ],
    );
  }
  ///
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
