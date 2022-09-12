import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/app_icons.dart';
import 'package:flutter/material.dart';

class UserAccountPopupMenuBtn extends StatelessWidget {
  static const _debug = false;
  final void Function(BuildContext context)? _onPaswordChangeSelected; 
  final void Function(BuildContext context)? _onLogoutSelected; 
  const UserAccountPopupMenuBtn({
    Key? key,
    void Function(BuildContext context)? onPaswordChangeSelected,
    void Function(BuildContext context)? onLogoutSelected,
  }) : 
    _onPaswordChangeSelected = onPaswordChangeSelected,
    _onLogoutSelected = onLogoutSelected,
    super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          appIcons.accountCircle,
          // const Text('Фильтр',
          //   style: TextStyle(
          //     height: 1.3,
          //     fontSize: 10.5,
          //   ),
          // ),
        ],
      ),
      onSelected: (value) {
        
      },
      itemBuilder: (BuildContext context) {
        return [
          /// Смена пароля
          PopupMenuItem(
            onTap: () => Future(() {
              final _callBack = _onPaswordChangeSelected;
              if (_callBack != null) {
                _callBack(context);
                log(_debug, '[$UserAccountPopupMenuBtn.PopupMenuItem.onTap] смена пароля');
              }
            }),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/lock_settings.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const SizedBox(width: 8.0,),
                Text(const AppText('Change Password').local),
              ],
            ),
          ),
          /// переход в диалог настроек
          // PopupMenuItem(
          //   child: Row(
          //     children: [
          //       Image.asset(
          //         'assets/icons/ic_access_time.png',
          //         width: 32.0,
          //         height: 32.0,
          //         color: Colors.primaries[9],
          //       ),
          //       const Text(AppText.settingsPage),
          //     ],
          //   ),
          //   onTap: () {
          //   },
          // ),
          /// выход из профиля пользователя
          PopupMenuItem(
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/logout.png',
                  width: 32.0,
                  height: 32.0,
                  color: Colors.primaries[9],
                ),
                const SizedBox(width: 8.0,),
                Text(const AppText('User Logout').local),
              ],
            ),
            onTap: () {
              final _callBack = _onLogoutSelected;
              if (_callBack != null) {
                _callBack(context);
                log(_debug, '[$UserAccountPopupMenuBtn.PopupMenuItem.onTap] выход из профиля');
              }
            },
          ),
        ];
      },
    );
  }
}
