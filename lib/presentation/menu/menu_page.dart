import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:configure_cma/presentation/core/widgets/button/circular_fab_widget.dart';
import 'package:configure_cma/presentation/core/widgets/right_icon_widget.dart';
import 'package:configure_cma/presentation/menu/widgets/menu_body.dart';
import 'package:configure_cma/presentation/nav/app_nav.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
/// Главное меню приложения
class MenuPage extends StatefulWidget {
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  ///
  const MenuPage({
    Key? key,
    required AppUserStacked users,
    required AppThemeSwitch themeSwitch,
  }) : 
    _users = users,
    _themeSwitch = themeSwitch,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<MenuPage> createState() => _MenuPageState(
    users: _users,
    themeSwitch: _themeSwitch,
  );
}


class _MenuPageState extends State<MenuPage> {
  static const _debug = true;
  final AppUserStacked _users;
  final AppThemeSwitch _themeSwitch;
  ///
  _MenuPageState({
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
  }
  ///
  @override
  Widget build(BuildContext context) {
    final user = _users.peek;
    log(_debug, '[_MenuPageState.build] user: ', user);
    // final userGroup = AppUserGroup('${user['group']}');
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final dw = (width - AppUiSettings.displaySize.width) / 2;
    final dh = (height - AppUiSettings.displaySize.height) / 2;
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
        body: MenuBody(
          users: _users,
          themeSwitch: _themeSwitch,
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
            key: UniqueKey(),
            buttonSize: AppUiSettings.floatingActionButtonSize,
            icon: const Icon(Icons.menu, size: floatingActionIconSize),
            // onPressed: () {
            // },
            children: [
              // FloatingActionButton(
              //   key: UniqueKey(),
              //   heroTag: 'FloatingActionButtonHome', 
              //   child: const Icon(Icons.home, size: floatingActionIconSize),
              //   onPressed: () {
              //   },
              // ),
              FloatingActionButton(
                key: UniqueKey(),
                heroTag: 'FloatingActionButtonTheme', 
                child: const Icon(Icons.color_lens_outlined, size: floatingActionIconSize),
                onPressed: () {
                  final theme = _themeSwitch.theme == AppTheme.light
                    ? AppTheme.dark 
                    : AppTheme.light;
                  _themeSwitch.toggleTheme(theme);
                },
              ),
              FloatingActionButton(
                heroTag: 'FloatingActionButtonUserAccount', 
                child: const Icon(Icons.account_circle_outlined, size: floatingActionIconSize),
                onPressed: () {               
                },
              ),
              FloatingActionButton(
                heroTag: 'FloatingActionButtonHomeLogout', 
                child: const Icon(Icons.logout, size: floatingActionIconSize),
                onPressed: () {
                  _users.clear();
                  AppNav.logout(context);
                },
              ),
            ],
          ),
        // CircularFabWidget(
        //     key: UniqueKey(),
        //     icon: const Icon(
        //       Icons.account_circle_outlined, 
        //       size: AppUiSettings.floatingActionButtonSize,
        //     ),
        //     children: [],
        // ),
        Positioned(
          right: 0,
          child: RightIconWidget(
            users: _users,
            // dsClient: _dsClient,
          ),
        ),
      ],
    );
  }
}
