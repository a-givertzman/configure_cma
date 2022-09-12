import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/swl/swl_data.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/crane_load_chart/crane_load_chart.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/crane_position_chart/crane_position_chart.dart';
import 'package:flutter/material.dart';

///
class CraneLoadWidget extends StatelessWidget {
  final Stream<DsDataPoint<int>>? _swlIndexStream;
  final Stream<DsDataPoint<double>> _xStream;
  final Stream<DsDataPoint<double>> _yStream;
  final double _width;
  final double _height;
  final double _rawWidth;
  final double _rawHeight;
  final double _xAxisValue;
  final double _yAxisValue;
  final bool _showGrid;
  final SwlData _swlData;
  final List<double> _swlLimitSet;
  final List<Color> _swlColorSet;
  final Color _backgroundColor;
  final Color? _axisColor;
  final double _pointSize;
  ///
  const CraneLoadWidget({
    Key? key,
    Stream<DsDataPoint<int>>? swlIndexStream,
    required Stream<DsDataPoint<double>> xStream,
    required Stream<DsDataPoint<double>> yStream,
    required double width,
    required double height,
    required double rawWidth,
    required double rawHeight,
    required double xAxisValue,
    required double yAxisValue,
    bool showGrid = false,
    required SwlData swlData,
    required List<double> swlLimitSet,
    required List<Color> swlColorSet,
    Color backgroundColor = Colors.transparent,
    Color? axisColor,
    double pointSize = 1.0,
  }) : 
    _swlIndexStream = swlIndexStream,
    _xStream = xStream,
    _yStream = yStream,
    _width = width,
    _height = height,
    _rawWidth = rawWidth,
    _rawHeight = rawHeight,
    _xAxisValue = xAxisValue,
    _yAxisValue = yAxisValue,
    _showGrid = showGrid,
    _swlData = swlData,
    _swlLimitSet = swlLimitSet,
    _swlColorSet = swlColorSet,
    _backgroundColor = backgroundColor,
    _axisColor = axisColor,
    _pointSize = pointSize,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CraneLoadChart(
          swlIndexStream: _swlIndexStream,
          width: _width,
          height: _height,
          rawWidth: _rawWidth,
          rawHeight: _rawHeight,
          xAxisValue: _xAxisValue,
          yAxisValue: _yAxisValue,
          showGrid: _showGrid,
          swlData: _swlData,
          swlLimitSet: _swlLimitSet,
          swlColorSet: _swlColorSet,
          backgroundColor: _backgroundColor, 
          axisColor: _axisColor,
          pointSize: _pointSize,
        ),
        CranePositionChart(
          xStream: _xStream,
          yStream: _yStream,
          width: _width, 
          height: _height, 
          rawWidth: _rawWidth, 
          rawHeight: _rawHeight,
        ),
      ],
    );
  }
}
