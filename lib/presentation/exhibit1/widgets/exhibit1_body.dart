import 'package:configure_cma/domain/core/entities/ds_data_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/infrastructure/stream/stream_mearged.dart';
import 'package:configure_cma/presentation/core/widgets/sps_icon_indicator.dart';
import 'package:configure_cma/presentation/core/widgets/status_indicator_widget.dart';
import 'package:configure_cma/presentation/core/widgets/live_chart_widget.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class Exhibit1Body extends StatelessWidget {
  static const _debug = true;
  final DsClient _dsClient;
  final List<double> _trace1 = [];
  final List<double> _trace2 = [];
  /// 
  /// Builds home body using current user
  Exhibit1Body({
    Key? key,
    required DsClient dsClient,
  }) : 
    _dsClient = dsClient,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$Exhibit1Body.build]');
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    _dsClient.requestAll();
    return StreamBuilder<DsDataPoint<double>>(
      stream: StreamMerged<DsDataPoint<double>>([
        _dsClient.streamReal('HookPosition.x'),
        _dsClient.streamReal('HookPosition.y'),
      ]).stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final point = snapshot.data;
          if (point != null) {
            if (point.name == 'HookPosition.x') {
              _trace1.add(point.value);
            }
            if (point.name == 'HookPosition.y') {
              _trace2.add(point.value);
            }
          }
        }
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
                Padding(
                  padding: const EdgeInsets.all(padding),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(width: 94.0),
                      const Expanded(child: Text('')),
                      Image.asset(
                        'assets/img/brand_icon.png',
                        scale: 9.0,
                        opacity: const AlwaysStoppedAnimation<double>(0.5),
                      ),
                      const Expanded(child: Text('')),
                      // Expanded(child: Text(const AppText('Demo').local,)),
                      /// Кнопки управления режимом
                      const SizedBox(width: blockPadding,),
                      // TextIndicatorWidget(
                      //   indicator: TextIndicator(
                      //     stream: _dsClient.streamReal('HookPosition.x'),
                      //   ), 
                      //   caption: const Text('HookPosition.x'), 
                      //   alignment: Alignment.topCenter,
                      // ),
                      const SizedBox(width: blockPadding,),
                      /// Индикатор | Связь
                      StatusIndicatorWidget(
                        indicator: SpsIconIndicator(
                          trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
                          falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).backgroundColor),
                          stream: _dsClient.streamBool('Local.System.Connection'),
                        ), 
                        caption: Text(const AppText('Connection').local), 
                      ),
                    ],
                  ),
                ),
                // Row 3
                Expanded(
                  child: Card(
                    child: LiveChartWidget(
                      caption: 'Показания с датчика',
                      yInterval: 0.5,
                      xInterval: 2000.0,
                      minY: -0.5, 
                      maxY: 0.5,
                      stream: _dsClient.streamReal('Drive.positionFromMru'),
                      axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    ),
                  ),
                ),
                const SizedBox(height: blockPadding,),
                // Row 3
                Expanded(
                  child: Card(
                    child: LiveChartWidget(
                      caption: 'Показания с лебедки',
                      yInterval: 1.0,
                      xInterval: 2000.0,
                      minY: 0.0, 
                      maxY: 3.0,
                      stream: _dsClient.streamReal('Drive.positionFromHoist'),
                      axisColor: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                    ),
                  ),
                ),
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
