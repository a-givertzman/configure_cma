
import 'package:configure_cma/domain/auth/app_user_group.dart';
import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/core/theme/color_utils.dart';
import 'package:configure_cma/presentation/core/widgets/sps_icon_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/status_indicator_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
class RightIconWidget extends StatefulWidget {
  final AppUserStacked? _users;
  final DsClient? _dsClient;
  ///
  const RightIconWidget({
    Key? key,
    AppUserStacked? users,
    DsClient? dsClient,
  }) :
    _users = users,
    _dsClient = dsClient,
    super(key: key);
  ///
  @override
  State<RightIconWidget> createState() => _RightIconWidgetState(
    users: _users,
    dsClient: _dsClient,
  );
}

///
class _RightIconWidgetState extends State<RightIconWidget> with TickerProviderStateMixin {
  static const _debug = true;
  final AppUserStacked? _users;
  final DsClient? _dsClient;
  bool _hovered = false;
  ///
  _RightIconWidgetState({
    required AppUserStacked? users,
    required DsClient? dsClient,
  }) :
    _users = users,
    _dsClient = dsClient;
  ///
  @override
  Widget build(BuildContext context) {
    final dsClient = _dsClient;
    const padding = AppUiSettings.padding;
    final stateColors = Theme.of(context).stateColors;
    return Row(
      children: [
        /// Индикатор | Связь
        if (dsClient != null)
          StatusIndicatorWidget(
            alignment: Alignment.center,
            indicator: SpsIconIndicator(
              trueIcon: Icon(Icons.account_tree_sharp, color: stateColors.on),
              falseIcon: Icon(Icons.account_tree_outlined, color: stateColors.invalid),
              stream: _dsClient?.streamBool('Local.System.Connection')
                .map((event) {
                  log(_debug, '[$_RightIconWidgetState] Local.System.Connection: ', event.value);
                  return event;
                }),
            ), 
            caption: SizedBox.shrink(),//Text(const AppText('Connection').local), 
          ),
        if (dsClient != null && _users != null)
          const SizedBox(width: padding),
        _buildUserIconWidget(),
      ],
    );
  }
  ///
  Widget _buildUserIconWidget() {
    final user = _users?.peek;
    final userGroup = user?.userGroup();
    final userGroupTextColor = _buildUserGroupTextColor(userGroup);
    if (_users != null) {
      return MouseRegion(
        onEnter: (event) {
          setState(() => _hovered = true);
        },
        onExit: (event) {
          setState(() => _hovered = false);
        },
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.5 * 0.9 * 0.95 * AppUiSettings.floatingActionButtonSize),
            ),
            child: Padding(
              padding: EdgeInsets.all(0.5 * 0.9 * 0.95 * 0.25 * AppUiSettings.floatingActionButtonSize),
              child: Row(
                children: [
                  if (_hovered) ...[
                    const SizedBox(width: AppUiSettings.padding),
                    Column(
                      children: [
                        Text(user?['name'].value),
                        Text(
                          '${userGroup?.value}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: userGroupTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                  Icon(
                    Icons.account_circle_outlined, 
                    size: 0.9 * 0.95 * 0.75 * AppUiSettings.floatingActionButtonSize,
                    color: userGroupTextColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
  ///
  Color _buildUserGroupTextColor(AppUserGroup? userGroup) {
    final group = userGroup?.value;
    if (group != null) {
      if (group == UserGroupList.guest) {
        return colorShiftLightness(Theme.of(context).colorScheme.onBackground, 0.6);
      }
      if (group == UserGroupList.operator) {
        return Theme.of(context).colorScheme.primary;
      }
      if (group == UserGroupList.admin) {
        return Theme.of(context).colorScheme.secondary;
      }
    }
    return Theme.of(context).colorScheme.primary;
  }
}
