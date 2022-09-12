import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/drive/ac_drive_widget.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
/// Насос с приводом
class HpuPumpWidget extends StatelessWidget {
  final Stream<DsDataPoint<int>>? _stream;
  final Widget _caption;
  final String _driveCaption;
  final String _pumpCaption;
  ///
  const HpuPumpWidget({
    Key? key,
    Stream<DsDataPoint<int>>? stream,
    required Widget caption,
    required String driveCaption,
    required String pumpCaption,
  }) : 
    _stream = stream,
    _caption = caption,
    _driveCaption = driveCaption,
    _pumpCaption = pumpCaption,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    const padding = AppUiSettings.padding;
    // const blockPadding = AppUiSettings.blockPadding;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 100.0,
          child: Center(child: _caption),
        ),
        const SizedBox(height: padding,),
        const SizedBox(height: 50.0,),
        const SizedBox(height: padding,),
        AcDriveWidget(
          stream: _stream,
          caption: _driveCaption,
        ),
        const SizedBox(height: padding,),
        Padding(
          padding: const EdgeInsets.all(padding),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/icons/pump-left-var-left.png',
                // scale: 4.0,
                width: 100.0 - padding * 2,
                height: 100.0 - padding * 2,
                color: Theme.of(context).colorScheme.tertiary,
                opacity: const AlwaysStoppedAnimation<double>(0.5),
              ),
              Text(_pumpCaption, textAlign: TextAlign.center),
            ],
          ),
        ),
        const SizedBox(height: padding,),
        const SizedBox(height: 100.0,),
      ],
    );
  }
}
