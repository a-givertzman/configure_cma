import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/edit_field/network_edit_field.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

class SettingsRotaryBoomTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const SettingsRotaryBoomTab({
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
    log(_debug, '[$SettingsRotaryBoomTab.build]');
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
                name: 'Settings.RotaryBoom.SpeedDown1PumpFactor',
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
                name: 'Settings.RotaryBoom.SlowSpeedFactor',
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
                name: 'Settings.RotaryBoom.SpeedDown2AxisFactor',
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
                name: 'Settings.RotaryBoom.SpeedAccelerationTime',
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
                name: 'Settings.RotaryBoom.SpeedDecelerationTime',
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
                name: 'Settings.RotaryBoom.FastStoppingTime',
              ),
              labelText: const AppText('Quick Stop time').local,
              unitText: const AppText('ms').local,
              width: 350,
            ),
          ],
        ),
        const SizedBox(width: blockPadding * 8,),
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
                name: 'Settings.RotaryBoom.SpeedDownMaxPos',
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
                name: 'Settings.RotaryBoom.SpeedDownMaxPosFactor',
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
                name: 'Settings.RotaryBoom.SpeedDownMinPos',
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
                name: 'Settings.RotaryBoom.SpeedDownMinPosFactor',
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
