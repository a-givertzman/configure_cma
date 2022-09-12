
import 'package:configure_cma/domain/auth/app_user_group.dart';
import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/widgets/sps_icon_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/status_indicator_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class DiagnosticBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const DiagnosticBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    _users = users,
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$DiagnosticBody.build]');
    final user = _users.peek;
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    // final width = MediaQuery.of(context).size.width;
    // final height = MediaQuery.of(context).size.height;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dsClient.isConnected()) {
        _dsClient.requestAll();
      }
    });
    if (user.userGroup() == UserGroupList.admin) {
      // 
    }
    return Column(
      children: [
        // Row 1
        Padding(
          padding: const EdgeInsets.all(padding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 250.0),
              const Expanded(child: Text('')),
              const SizedBox(width: 64.0),
              Image.asset(
                'assets/img/brand_icon.png',
                scale: 9.0,
                opacity: const AlwaysStoppedAnimation<double>(0.5),
              ),
              const SizedBox(width: 64.0),
              const Expanded(child: Text('')),
              /// Индикатор | Связь
              StatusIndicatorWidget(
                indicator: SpsIconIndicator(
                  trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                  falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).backgroundColor),
                  stream: _dsClient.streamBool('Local.System.Connection'),
                ), 
                caption: Text(const AppText('Connection').local), 
              ),
            ],
          ),
        ),
        const SizedBox(height: blockPadding,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                StatusIndicatorWidget(
                  indicator: SpsIconIndicator(
                    trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                    falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).backgroundColor),
                    stream: _dsClient.streamBool('system.db899_drive_data_exhibit.status'),
                    // !.map((event) {
                    //   log(_debug, 'system.db899.status: ', event);
                    //   return DsDataPoint(
                    //     type: DsDataType.bool(), 
                    //     path: event.path, 
                    //     name: event.name, 
                    //     value: event.value == 0, 
                    //     status: event.status, 
                    //     timestamp: event.timestamp,
                    //   );
                    // }),
                  ), 
                  caption: Text(const AppText('IED11.db899_drive_data_exhibit').local), 
                ),
                StatusIndicatorWidget(
                  indicator: SpsIconIndicator(
                    trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                    falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).backgroundColor),
                    stream: _dsClient.streamBool('system.db902_panel_controls.status'),
                    // !.map((event) {
                    //   log(_debug, 'system.db902_panel_controls.status: ', event);
                    //   return DsDataPoint(
                    //     type: DsDataType.bool(), 
                    //     path: event.path, 
                    //     name: event.name, 
                    //     value: event.value == 0, 
                    //     status: event.status, 
                    //     timestamp: event.timestamp,
                    //   );
                    // }),
                  ), 
                  caption: Text(const AppText('IED11.db902_panel_controls').local), 
                ),
                StatusIndicatorWidget(
                  indicator: SpsIconIndicator(
                    trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                    falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).backgroundColor),
                    stream: _dsClient.streamBool('system.db906_visual_data.status'),
                    // !.map((event) {
                    //   log(_debug, 'system.db906_visual_data.status: ', event);
                    //   return DsDataPoint(
                    //     type: DsDataType.bool(), 
                    //     path: event.path, 
                    //     name: event.name, 
                    //     value: event.value == 0, 
                    //     status: event.status, 
                    //     timestamp: event.timestamp,
                    //   );
                    // }),
                  ), 
                  caption: Text(const AppText('IED11.db906_visual_data').local), 
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
