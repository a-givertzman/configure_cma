import 'dart:async';

import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/crane/crane_main_mode.dart';
import 'package:crane_monitoring_app/domain/crane/crane_mode_state.dart';
import 'package:crane_monitoring_app/domain/crane/crane_wave_height_level.dart';
import 'package:crane_monitoring_app/domain/crane/crane_winch_mode_value.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/button/drop_down_control_button/drop_down_control_button.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
class CraneModeControlWidget extends StatefulWidget {
  final DsClient _dsClient;
  final CraneModeState _craneModeState;
  final double _buttonWidth;
  final double _buttonHeight;
  ///
  const CraneModeControlWidget({
    Key? key,
    required DsClient dsClient,
    required CraneModeState craneModeState,
    required double buttonWidth,
    required double buttonHeight,
  }) : 
    _dsClient = dsClient,
    _craneModeState = craneModeState,
    _buttonWidth = buttonWidth,
    _buttonHeight = buttonHeight,
    super(key: key);
  ///
  @override
  _CraneModeControlWidgetState createState() => _CraneModeControlWidgetState(
    dsClient: _dsClient,
    craneModeState: _craneModeState,
    buttonWidth: _buttonWidth,
    buttonHeight: _buttonHeight,
  );
}

///
class _CraneModeControlWidgetState extends State<CraneModeControlWidget> {
  // static const _debug = true;
  final DsClient _dsClient;
  final CraneModeState _craneModeState;
  final double _buttonWidth;
  final double _buttonHeight;
  ///
  _CraneModeControlWidgetState({
    required DsClient dsClient,
    required CraneModeState craneModeState,
    required double buttonWidth,
    required double buttonHeight,
  }) :
    _dsClient = dsClient,
    _craneModeState = craneModeState,
    _buttonWidth = buttonWidth,
    _buttonHeight = buttonHeight;
  ///
  @override
  Widget build(BuildContext context) {
    const padding = AppUiSettings.padding;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        /// Селектор | Режим работы крана
        DropDownControlButton(
          width: _buttonWidth,
          height: _buttonHeight,
          dsClient: _dsClient,
          writeTagName: DsPointPath(path: 'line1.ied12.db902_panel_controls', name: 'Settings.CraneMode.MainMode'),
          responseTagName: 'CraneMode.MainMode',
          tooltip: const AppText('Select crane mode').local,
          label: const AppText('Mode').local,
          items: {
            CraneMainModeValue.hurbour.value.toInt(): const AppText('Harbour').local,
            CraneMainModeValue.theSea.value.toInt(): const AppText('In sea').local,
          },
        ),
        const SizedBox(height: padding,),
        /// Селектор | Режим работы лебедки
        DropDownControlButton(
          itemsDisabledStreams: {
            CraneWinchModeValue.ahc.value.toInt(): _craneModeState.winch1ModeState.transform<bool>(
              StreamTransformer.fromHandlers(handleData: (event, sink) {
                if (event == CraneWinchModeValue.ahcIsDisabled) sink.add(true);
                if (event == CraneWinchModeValue.ahcIsEnabled) sink.add(false);
              }),
            ),
            CraneWinchModeValue.manriding.value.toInt(): _craneModeState.winch1ModeState.transform<bool>(
              StreamTransformer.fromHandlers(handleData: (event, sink) {
                if (event == CraneWinchModeValue.manridingIsDisabled) sink.add(true);
                if (event == CraneWinchModeValue.manridingIsEnabled) sink.add(false);
              }),
            ),
          },
          width: _buttonWidth,
          height: _buttonHeight,
          dsClient: _dsClient,
          writeTagName: DsPointPath(path: 'line1.ied12.db902_panel_controls', name: 'Settings.CraneMode.Winch1Mode'),
          responseTagName: 'CraneMode.Winch1Mode',
          tooltip: const AppText('Select winch mode').local,
          label: const AppText('Winch').local,
          items: {
            CraneWinchModeValue.freight.value.toInt(): const AppText('Freight').local,
            CraneWinchModeValue.ahc.value.toInt(): const AppText('AHC').local,
            CraneWinchModeValue.manriding.value.toInt(): const AppText('Manriding').local,
          },
        ),
        const SizedBox(height: padding,),
        /// Селектор | Уровень высоты волны
        DropDownControlButton(
          disabledStream: _craneModeState.waveHeightLevelState.transform<bool>(
            StreamTransformer.fromHandlers(handleData: (event, sink) {
              if (event == CraneWaveHeightLevel.isDisabled) sink.add(true);
              if (event == CraneWaveHeightLevel.isEnabled) sink.add(false);                  
            }),
          ),
          width: _buttonWidth,
          height: _buttonHeight,
          dsClient: _dsClient,
          writeTagName: DsPointPath(path: 'line1.ied12.db902_panel_controls', name: 'Settings.CraneMode.WaveHeightLevel'),
          responseTagName: 'CraneMode.WaveHeightLevel',
          tooltip: const AppText('Select wave hight level').local,
          label: const AppText('SWH').local,
          items: {
            CraneWaveHeightLevel.level0.value.toInt(): const AppText('0.1 m').local,
            CraneWaveHeightLevel.level1.value.toInt(): const AppText('1.25 m').local,
            CraneWaveHeightLevel.level2.value.toInt(): const AppText('2.0 m').local,
          },
        ),
      ],
    );
  }
}