
import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/presentation/core/widgets/button/control_button/control_button_indicator.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  final Stream<DsDataPoint<num>>? _stream;
  final List<String> _stateValues;
  final void Function()? _onPressed;
  // final Widget? _child;
  final double? _width;
  final double? _height;
  final String? _caption;
  ///
  const ControlButton({
    Key? key,
    Stream<DsDataPoint<num>>? stream,
    required List<String> stateValues,
    required void Function()? onPressed,
    double? width,
    double? height,
    String? caption,
    // required Widget? child,
  }) : 
    _stream = stream,
    _stateValues = stateValues,
    _onPressed = onPressed,
    _width = width,
    _height = height,
    _caption = caption,
    // _child = child,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: ElevatedButton(
        onPressed: _onPressed,
        child: ControlButtonIndicator(
          caption: _caption,
          stream: _stream,
          stateValues: _stateValues,
        ),
      ),
    );
  }
}
