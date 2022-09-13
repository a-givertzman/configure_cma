// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:configure_cma/app_widget.dart';
import 'package:configure_cma/domain/alarm/alarm_list_point.dart';
import 'package:configure_cma/infrastructure/alarm/alarm_list_data_source.dart';
// import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client_real.dart';
import 'package:configure_cma/presentation/core/theme/app_theme_switch.dart';
import 'package:configure_cma/settings/communication_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'SignInPage', 
    (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final _dsClient = DsClientReal(
      // ip = '192.168.0.100';
      ip: AppCommunicationSettings.dsClientIp, 
      port: AppCommunicationSettings.dsClientPort,
    );
    final _appThemeSwitch = AppThemeSwitch();
    await tester.pumpWidget(
      AppWidget(
          themeSwitch: _appThemeSwitch,
      ),
    );

    // await tester.pump(const Duration(seconds: 3));
    // Wait for refresh indicator to stop spinning
    // await tester.pumpAndSettle();
    // await Future.delayed(const Duration(seconds: 3));
    // Verify that our counter starts at 0.
    // expect(find.text(const AppText('Authentication').local), findsOneWidget);
    // expect(find.text(const AppText('Crane monitoring').local), findsOneWidget);
    // expect(find.text(const AppText('Welcome').local), findsOneWidget);
    // expect(find.text(const AppText('Please authenticate to continue...').local), findsOneWidget);
    // expect(find.text(const AppText('Your login').local), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
