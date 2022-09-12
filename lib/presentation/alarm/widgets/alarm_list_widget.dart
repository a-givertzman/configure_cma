import 'package:configure_cma/domain/alarm/alarm_list_point.dart';
import 'package:configure_cma/domain/event/event_list_data.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/domain/event/event_list_data_filterd_by_date.dart';
import 'package:configure_cma/domain/event/event_list_data_filterd_by_text.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/alarm/widgets/alarm_list_row_widget.dart';
import 'package:configure_cma/presentation/core/widgets/edit_field/date_edit_field.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class AlarmListWidget extends StatefulWidget {
  final DsClient _dsClient;
  final EventListData<AlarmListPoint> _listData;
  final bool _reverse;
  ///
  AlarmListWidget({
    Key? key,
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    bool reverse = false,
  }) : 
    _dsClient = dsClient,
    _listData = listData,
    _reverse = reverse,
    super(key: key);
  ///
  @override
  State<AlarmListWidget> createState() => _AlarmListWidgetState(
    dsClient: _dsClient,
    listData: _listData,
    reverse: _reverse,
  );
}

///
///
class _AlarmListWidgetState extends State<AlarmListWidget> {
  // static const _debug = true;
  // final DsClient _dsClient;
  final EventListDataFilteredByText _listData;
  final bool _reverse;
  final TextEditingController _fromDateControlle = TextEditingController();
  final TextEditingController _untilDateControlle = TextEditingController();
  ///
  _AlarmListWidgetState({
    required DsClient dsClient,
    required EventListData<AlarmListPoint> listData,
    required bool reverse,
  }) : 
    // _dsClient = dsClient,
    _listData = EventListDataFilteredByText<AlarmListPoint>(
      listData: EventListDataFilteredByDate<AlarmListPoint>(
        listData: listData,
      ),
      filterController: TextEditingController(),
    ),
    _reverse = reverse,
    super();
  ///
  @override
  Widget build(BuildContext context) {
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    // final firstDate = DateTime.parse('1970-01-01');
    // final lastDate = DateTime.now().add(Duration(days: 1));
    return Column(
      children: [
        // Row 1
        Padding(
          padding: const EdgeInsets.all(padding),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('')),
              SizedBox(
                width: 100, 
                height: 48, 
                child: DateEditField(
                  label: const AppText('Date from').local,
                  onComplete: (value) {
                    _listData.onDateFromSubmitted(value);
                  },
                ),
              ),
              const SizedBox(width: blockPadding),
              SizedBox(
                width: 100, 
                height: 48, 
                child: DateEditField(
                  label: const AppText('To').local,
                  onComplete: (value) {
                    _listData.onDateToSubmitted(value);
                  },
                ),
              ),
              const SizedBox(width: 64.0),
              Image.asset(
                'assets/img/brand_icon.png',
                scale: 9.0,
                opacity: const AlwaysStoppedAnimation<double>(0.5),
              ),
              const SizedBox(width: 64.0),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TextFormField(
                    controller: _listData.filterController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.search),
                      labelText: const AppText('Find').local,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 64.0 + 150.0),
              /// Индикатор | Связь
              // StatusIndicatorWidget(
              //   indicator: SpsIconIndicator(
              //     trueIcon: Icon(Icons.account_tree_sharp, color: Theme.of(context).primaryColor),
              //     falseIcon: Icon(Icons.account_tree_outlined, color: Theme.of(context).backgroundColor),
              //     stream: _dsClient.streamBool('Local.System.Connection'),
              //   ), 
              //   caption: Text(const AppText('Connection').local), 
              // ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<int>(
            stream: _listData.stateStream,
            builder: (context, snapshot) {
              if (_listData.list.isNotEmpty) {
                return ListView.builder(
                  reverse: _reverse,
                  // cacheExtent: _cacheExtent,
                  itemCount: _listData.list.length,
                  // controller: _scrollController,
                  itemBuilder: (context, index) {
                    bool highlite = false;
                    if (index > 0) {
                      // final prev = double.parse('${_listData.list[index - 1].value}');
                      // final next = double.parse('${_listData.list[index].value}');
                      // if ((prev - next) != 1.0) {
                      //   highlite = true;
                      // }
                    }
                    return AlarmListRowWidget(
                      key: UniqueKey(),
                      point: _listData.list[index],
                      onAcknowledgment: _listData.onAcknowledged,
                      highlite: highlite,
                    );
                  },
                );
              } else {
                return Center(child: Text(const AppText('No alarms').local));
              }
            },
          ),
        ),
      ],
    );
  }
  @override
  void dispose() {
    _fromDateControlle.dispose();
    _untilDateControlle.dispose();
    _listData.dispose();
    super.dispose();
  }
}