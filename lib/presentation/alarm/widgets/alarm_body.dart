import 'package:configure_cma/domain/alarm/alarm_list_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/event/event_list_data.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/alarm/widgets/alarm_list_widget.dart';
import 'package:flutter/material.dart';

class AlarmBody extends StatelessWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _listData;
  /// 
  /// Builds home body using current user
  const AlarmBody({
    Key? key,
    // required AppUserStacked users,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
  }) : 
    // _users = users,
    _dsClient = dsClient,
    _listData = listData,
    super(key: key);
  /// 
  /// Builds home body widget
  @override
  Widget build(BuildContext context) {
    log(_debug, '[$AlarmBody.build]');
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        _dsClient.requestAll();
      },
    );
    return AlarmListWidget(
      dsClient: _dsClient,
      listData: _listData,
    );
  }
}
