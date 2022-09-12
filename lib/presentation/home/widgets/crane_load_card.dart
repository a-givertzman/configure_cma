import 'package:crane_monitoring_app/domain/swl/swl_data.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/common_container_widget.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/crane_load_widget.dart';
import 'package:flutter/material.dart';

class CraneLoadCard extends StatelessWidget {
  final DsClient _dsClient;
  final SwlData _swlData = SwlData(assetPath: 'assets/swl', count: 2);
  ///
  CraneLoadCard({
    Key? key,
    required DsClient dsClient,
  }) : 
    _dsClient = dsClient, 
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    const loadChartOpacity = 0.7;
    return CommonContainerWidget(
      children: [
        CraneLoadWidget(
          swlIndexStream: _dsClient.streamInt('CraneMode.LoadIndex'),
          xStream: _dsClient.streamReal('Hook.x'),
          yStream: _dsClient.streamReal('Hook.y'),
          width: 450.0, 
          height: 450.0, 
          rawWidth: 20.0, 
          rawHeight: 27.0, 
          xAxisValue: 5.0, 
          yAxisValue: 5.0, 
          showGrid: true, 
          swlData: _swlData, 
          swlLimitSet: const [4999.0, 5000.0, 20000.0],
          // swlLimitSet: const [4999.0, 5000.0, 19999.0, 20000.0],
          // swlLimitSet: const [5000.0, 7500.0, 12500.0, 23000.0,],
          swlColorSet: [
            // Theme.of(context).colorScheme.primary.withOpacity(loadChartOpacity),
            Colors.grey[400]!.withOpacity(loadChartOpacity * 0.6),
            // Colors.purple[300]!.withOpacity(loadChartOpacity),
            Colors.blue[300]!.withOpacity(loadChartOpacity),
            Colors.green[300]!.withOpacity(loadChartOpacity),
            Colors.orange[400]!.withOpacity(loadChartOpacity),
          ],
          axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          pointSize: 1.0,
        ),
      ],
    );
  }
}
