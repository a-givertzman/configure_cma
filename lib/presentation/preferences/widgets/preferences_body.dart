import 'package:configure_cma/domain/auth/app_user_group.dart';
import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class PreferencesBody extends StatelessWidget {
  static const _debug = true;
  final AppUserStacked _users;
  // final DsClient _dsClient;
  /// 
  /// Builds home body using current user
  const PreferencesBody({
    Key? key,
    required AppUserStacked users,
    required DsClient dsClient,
  }) : 
    _users = users,
    // _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$PreferencesBody.build]');
    final user = _users.peek;
    // const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    // const dropDownControlButtonWidth = 118.0;
    // const dropDownControlButtonHeight = 44.0;
    if (user.userGroup() == UserGroupList.admin) {
      
    }
    return StreamBuilder<List<dynamic>>(
      // stream: dataStream,
      builder: (context, snapshot) {
        return RefreshIndicator(
          displacement: 20.0,
          onRefresh: () {
            return Future<List<String>>.value([]);
            // return source.refresh();
          },
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Row 1
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(const AppText('Preferences page').local),
                    /// Кнопки управления режимом
                    const SizedBox(width: blockPadding,),
                    const SizedBox(width: blockPadding,),
                  ],
                ),
                const SizedBox(height: blockPadding,),
                /// Row 2
                // const SizedBox(height: blockPadding,),
                /// Row 3
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //   ],
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
