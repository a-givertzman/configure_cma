import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/entities/ds_point_path.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/widgets/edit_field/network_edit_field.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class SettingsBasicProtectionsTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const SettingsBasicProtectionsTab({
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
    log(_debug, '[$SettingsBasicProtectionsTab.build]');
    const padding = AppUiSettings.padding;
    // const blockPadding = AppUiSettings.blockPadding;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NetworkEditField<double>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(path: 'line1.ied12.db902_panel_controls', name: 'Settings.Art.TorqueLimit'),
          labelText: const AppText('ART Torque limitation').local,
          unitText: const AppText('%').local,
          fractionDigits: 1,
          width: 350,
        ),
        SizedBox(height: padding),
        NetworkEditField<double>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(path: 'line1.ied12.db902_panel_controls', name: 'Settings.AOPS.RotarionLimit1'),
          labelText: const AppText('AOPS Rotation angle limit 5/7.5t').local,
          unitText: const AppText('º').local,
          fractionDigits: 1,
          width: 350,
        ),
        SizedBox(height: padding),
        NetworkEditField<double>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(path: 'line1.ied12.db902_panel_controls', name: 'Settings.AOPS.RotarionLimit2'),
          labelText: const AppText('AOPS Rotation angle limit 20/23t').local,
          unitText: const AppText('º').local,
          fractionDigits: 1,
          width: 350,
        ),
      ],
    );
  }
}
