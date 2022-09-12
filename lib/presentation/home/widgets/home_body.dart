import 'dart:math';

import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/home/widgets/select_dir_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class HomeBody extends StatefulWidget {
  static const _debug = true;
  final AppUserStacked _users;
  /// 
  /// Builds home body using current user
  const HomeBody({
    Key? key,
    required AppUserStacked users,
  }) : 
    _users = users,
    super(key: key);

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  final int _itemCount = 0;
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(HomeBody._debug, '[$HomeBody.build]');
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final stateColors = Theme.of(context).stateColors;
    return Transform.scale(
      scale: min(
        width / AppUiSettings.displaySize.width, 
        height / AppUiSettings.displaySize.height,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(blockPadding * 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Row 1
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/brand_icon.png',
                    scale: 4.0,
                    opacity: const AlwaysStoppedAnimation<double>(0.2),
                  ),
                  /// Путь к flutter проекту
                  Expanded(
                    child: SelectDirWidget(
                      labelText: 'Path to flutter application',
                      onComplete: (value) {
                        
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: blockPadding,),
              /// Путь к файлу конфигурации DataServer
              SelectFileWidget(
                labelText: 'DataServer file',
                onComplete: (value) {
                  
                },
              ),
              const SizedBox(height: blockPadding,),
              /// Row 2
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListView.builder(
                    itemCount: _itemCount,
                    itemBuilder: ((context, index) {
                      return Row(
                        children: [
                          Text(),
                        ],
                      );
                    })
                  ),
                ],
              ),
              const SizedBox(height: blockPadding,),
              /// Row 3
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
