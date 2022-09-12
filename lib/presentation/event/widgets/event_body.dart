import 'package:crane_monitoring_app/domain/alarm/event_list_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_data_point.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/event/event_list.dart';
import 'package:crane_monitoring_app/domain/event/event_list_data_filterd_by_date.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/domain/event/event_list_data_filterd_by_text.dart';
import 'package:crane_monitoring_app/infrastructure/datasource/app_data_source.dart';
import 'package:crane_monitoring_app/infrastructure/event/event_list_data_source.dart';
import 'package:crane_monitoring_app/presentation/core/widgets/edit_field/date_edit_field.dart';
import 'package:crane_monitoring_app/presentation/event/widgets/event_list_row_widget.dart';
import 'package:crane_monitoring_app/presentation/event/widgets/position_controller.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
class EventBody extends StatefulWidget {
  static const _debug = true;
  // final AppUserStacked _users;
  // final DsClient _dsClient;
  final bool _reverse;
  /// 
  /// Builds event body using current user
  const EventBody({
    Key? key,
    // required AppUserStacked users,
    // required DsClient dsClient,
    bool? reverse,
  }) : 
    // _users = users,
    // _dsClient = dsClient,
    _reverse = reverse ?? false,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<EventBody> createState() => _EventBodyState(
    // dsClient: _dsClient,
    reverse: _reverse,
  );
}

///
class _EventBodyState extends State<EventBody> {
  // static const _debug = true;
  static const _listCount = 100;
  static const _cacheExtent = 500.0;
  // final DsClient _dsClient;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _filterController = TextEditingController();
  final bool _reverse;
  late EventListDataFilteredByText<DsDataPoint> _listData;
  bool isLoading = false;
  bool isLoaded = false;
  ///
  _EventBodyState({
    // required DsClient dsClient,
    required bool reverse,
  }) :
    // _dsClient = dsClient,
    _reverse = reverse,
    super();
  ///
  @override
  void initState() {
    super.initState();
    _listData = EventListDataFilteredByText<DsDataPoint>(
      filterController: _filterController,
      listData: EventListDataFilteredByDate<DsDataPoint>(
        listData: EventListDataSource<DsDataPoint>(
          newEventsReadDelay: 3000,
          listCount: _listCount,
          cacheExtent: _cacheExtent,
          filterController: _filterController,
          positionController: PositionController(controller: _scrollController),
          eventList: EventList<EventListPoint>(
            remote: dataSource.dataSet('history'),
            dataMaper: (row) {
              return EventListPoint(
                id: row['id'],
                point: DsDataPoint.fromRow(row),
              );
            },
          ),
        ), 
      ),
    );
  }
  /// 
  @override
  Widget build(BuildContext context) {
    log(EventBody._debug, '[$EventBody.build]');
    const padding = AppUiSettings.padding;
    const blockPadding = AppUiSettings.blockPadding;
    // final firstDate = DateTime.parse('1970-01-01');
    // final lastDate = DateTime.now();
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
                  onChanged: (value) {
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
                  onChanged: (value) {
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
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    bool highlite = false;
                    // if (index > 0) {
                    //   final prev = double.parse('${_listData.list[index - 1].value}');
                    //   final next = double.parse('${_listData.list[index].value}');
                    //   if ((prev - next) != 1.0) {
                    //     highlite = true;
                    //   }
                    // }
                    return EventListRowWidget(
                      key: UniqueKey(),
                      point: _listData.list[index],
                      highlite: highlite,
                    );
                  },
                );
              } else {
                return Center(child: Text(const AppText('No events').local));
              }
            },
          ),
        ),
      ],
    );
  }
  @override
  void dispose() {
    _listData.dispose();
    // _filterController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
