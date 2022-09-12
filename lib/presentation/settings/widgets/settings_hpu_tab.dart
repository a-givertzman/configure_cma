import 'package:crane_monitoring_app/domain/auth/app_user_stacked.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/edit_field/network_edit_field.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/edit_field/network_dropdown_field.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

class SettingsHpuTab extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  SettingsHpuTab({
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
    log(_debug, '[$SettingsHpuTab.build]');
    log(_debug, '[$SettingsHpuTab.build _users: ${_users.toList()}');
    log(_debug, '[$SettingsHpuTab.build _user: ${_users.peek}');
    const padding = AppUiSettings.padding;
    // const blockPadding = AppUiSettings.blockPadding;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NetworkDropdownFormField(
          // onAuthRequested: _authenticate,
          allowedGroups: ['admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(
            path: 'line1.ied12.db902_panel_controls', 
            name: 'Settings.HPU.OilType',
          ),
          labelText: AppText('Oil Type').local,
          width: 350,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(
            path: 'line1.ied12.db902_panel_controls', 
            name: 'Settings.HPU.AlarmLowOilLevel',
          ),
          labelText: const AppText('Emergency low oil level').local,
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
            name: 'Settings.HPU.LowOilLevel',
          ),
          labelText: const AppText('Low oil level').local,
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
            name: 'Settings.HPU.HighOilTemp',
          ),
          labelText: const AppText('High oil temperature').local,
          unitText: const AppText('℃').local,
          width: 350,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(
            path: 'line1.ied12.db902_panel_controls', 
            name: 'Settings.HPU.AlarmHighOilTemp',
          ),
          labelText: const AppText('Emergency high oil temperature').local,
          unitText: const AppText('℃').local,
          width: 350,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(
            path: 'line1.ied12.db902_panel_controls', 
            name: 'Settings.HPU.LowOilTemp',
          ),
          labelText: const AppText('Low oil temperature').local,
          unitText: const AppText('℃').local,
          width: 350,
        ),
        SizedBox(height: padding),
        // TODO from Oleg: следующие поля убрать,
        //                 дополнительно вывести текущие значеения:
        //                   - давления
        //                   - температуры
        //                   - вычисленное значение перепада температуры
        NetworkEditField<int>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(
            path: 'line1.ied12.db902_panel_controls', 
            name: 'Settings.HPU.OilCooling',
          ),
          labelText: const AppText('Oil cooling').local,
          unitText: const AppText('℃').local,
          width: 350,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(
            path: 'line1.ied12.db902_panel_controls', 
            name: 'Settings.HPU.OilTempHysteresis',
          ),
          labelText: const AppText('Oil temperature hysteresis').local,
          unitText: const AppText('℃').local,
          width: 350,
        ),
        SizedBox(height: padding),
        NetworkEditField<int>(
          allowedGroups: ['guest', 'admin'],
          users: _users,
          dsClient: _dsClient,
          writeTagName: DsPointPath(
            path: 'line1.ied12.db902_panel_controls', 
            name: 'Settings.HPU.WaterFlowTrackingTimeout',
          ),
          labelText: const AppText('Water flow tracking timeout').local,
          unitText: const AppText('ms').local,
          width: 350,
        ),
      ],
    );
  }
}
