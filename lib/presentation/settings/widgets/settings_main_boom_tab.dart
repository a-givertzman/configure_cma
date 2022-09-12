import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/entities/ds_point_path.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/widgets/edit_field/network_edit_field.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class SettingsMainBoomTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const SettingsMainBoomTab({
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
    log(_debug, '[$SettingsMainBoomTab.build]');
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedDown1PumpFactor',
              ),
              labelText: const AppText('Speed deceleration on one pump').local,
              unitText: const AppText('%').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SlowSpeedFactor',
              ),
              labelText: const AppText('Speed limit for slow types of work').local,
              unitText: const AppText('%').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedDown2AxisFactor',
              ),
              labelText: const AppText('Speed limit at > 2 movement').local,
              unitText: const AppText('%').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedAccelerationTime',
              ),
              labelText: const AppText('Linear acceleration time').local,
              unitText: const AppText('ms').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedDecelerationTime',
              ),
              labelText: const AppText('Linear deceleration time').local,
              unitText: const AppText('ms').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.FastStoppingTime',
              ),
              labelText: const AppText('Quick stop time').local,
              unitText: const AppText('ms').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.PositionOffshore',
              ),
              labelText: const AppText('Position of switching to mode').local + ' "' + AppText('Offshore').local + '"',
              unitText: const AppText('mm').local,
              width: 350,
            ),
          ],
        ),
        SizedBox(width: blockPadding * 8),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppText('Speed limit at the maximum position').local + ':',
            ),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedDownMaxPos',
              ),
              labelText: const AppText('Speed deceleration position').local,
              unitText: const AppText('º').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedDownMaxPosFactor',
              ),
              labelText: const AppText('Speed limit to').local,
              unitText: const AppText('%').local,
              width: 350,
            ),
            SizedBox(height: blockPadding),
            Text(
              AppText('Speed limit at the minimum position').local + ':',
            ),
            // SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedDownMinPos',
              ),
              labelText: const AppText('Speed deceleration position').local,
              unitText: const AppText('º').local,
              width: 350,
            ),
            SizedBox(height: padding),
            NetworkEditField<int>(
              allowedGroups: ['guest', 'admin'],
              users: _users,
              dsClient: _dsClient,
              writeTagName: DsPointPath(
                path: 'line1.ied12.db902_panel_controls', 
                name: 'Settings.MainBoom.SpeedDownMinPosFactor',
              ),
              labelText: const AppText('Speed limit to').local,
              unitText: const AppText('%').local,
              width: 350,
            ),
          ],
        ),
      ],
    );
  }
}
