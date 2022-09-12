import 'package:crane_monitoring_app/domain/alarm/alarm_list_point.dart';
import 'package:crane_monitoring_app/domain/auth/authenticate.dart';
import 'package:crane_monitoring_app/domain/event/event_list_data.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/auth/sign_in/widgets/sign_in_form.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme_switch.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _alarmListData;
  final Authenticate auth;
  final AppThemeSwitch themeSwitch;
  ///
  const SignInPage({
    Key? key,
    required this.auth,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> alarmListData,
    required this.themeSwitch,
  }) : 
    _dsClient = dsClient,
    _alarmListData = alarmListData,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          title: Text(const AppText('Authentication').local),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: SignInForm(
            auth: auth,
            dsClient: _dsClient,
            alarmListData: _alarmListData,
            themeSwitch: themeSwitch,
          ),
        ),
      ),
    );
  }
}
