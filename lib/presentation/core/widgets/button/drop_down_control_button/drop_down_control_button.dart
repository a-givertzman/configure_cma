import 'dart:async';

import 'package:crane_monitoring_app/domain/core/entities/ds_data_stream_extract.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/core/entities/network_operation_state.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_client.dart';
import 'package:crane_monitoring_app/infrastructure/stream/ds_send.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:crane_monitoring_app/settings/common_settings.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

///
/// Кнопка посылает значение bool / int / real в DsClient
class DropDownControlButton extends StatefulWidget {
  final Stream<bool>? _disabledStream;
  final Map<int, Stream<bool>>? _itemsDisabledStreams;
  final double? _width;
  final double? _height;
  final DsClient? _dsClient;
  final DsPointPath? _writeTagName;
  final String? _responseTagName;
  final Map<int, String> _items;
  final String? _tooltip;
  final String? _label;
  ///
  const DropDownControlButton({
    Key? key,
    Stream<bool>? disabledStream,
    Map<int, Stream<bool>>? itemsDisabledStreams,
    double? width,
    double? height,
    DsClient? dsClient,
    DsPointPath? writeTagName,
    String? responseTagName,
    required Map<int, String> items,
    String? tooltip,
    String? label,
  }) : 
    _disabledStream = disabledStream,
    _itemsDisabledStreams = itemsDisabledStreams,
    _width = width,
    _height = height,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _items = items,
    _tooltip = tooltip,
    _label = label,
    super(key: key);
  ///
  @override
  // ignore: no_logic_in_create_state
  State<DropDownControlButton> createState() => _DropDownControlButtonState(
    isDisabledStream: _disabledStream,
    itemsDisabledStreams: _itemsDisabledStreams,
    width: _width,
    height: _height,
    dsClient: _dsClient,
    writeTagName: _writeTagName,
    responseTagName: _responseTagName,
    items: _items,
    tooltip: _tooltip,
    label: _label,
  );
}

///
class _DropDownControlButtonState extends State<DropDownControlButton> with TickerProviderStateMixin {
  static const _debug = true;
  final _state = NetworkOperationState(isLoading: true);
  final double? _width;
  final double? _height;
  final DsClient? _dsClient;
  final DsPointPath? _writeTagName;
  final String? _responseTagName;
  final Map<int, String> _items;
  final String? _tooltip;
  final String? _label;
  final Stream<bool>? _isDisabledStream;
  final Map<int, Stream<bool>>? _itemsDisabledStreams;
  final List<StreamSubscription> _itemDisabledSuscriptions = [];
  final Map<int, bool> _itemsDisabled = {};
  late AnimationController _animationController;
  int _lastSelectedValue = -1;
  ///
  _DropDownControlButtonState({
    required Stream<bool>? isDisabledStream,
    required Map<int, Stream<bool>>? itemsDisabledStreams,
    required double? width,
    required double? height,
    required DsClient? dsClient,
    required DsPointPath? writeTagName,
    required String? responseTagName,
    required Map<int, String> items,
    required String? tooltip,
    required String? label,
  }) :
    _isDisabledStream = isDisabledStream,
    _itemsDisabledStreams = itemsDisabledStreams,
    _width = width,
    _height = height,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _items = items,
    _tooltip = tooltip,
    _label = label,
    super();
  ///
  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 100),
      vsync: this,
    );    
    final itemsDisabledStreams = _itemsDisabledStreams;
    if (itemsDisabledStreams != null) {
      itemsDisabledStreams.forEach((index, itemDisabledStream) {
        final itemDisabledSuscription = itemDisabledStream.listen((event) {
          log(_debug, '[$_DropDownControlButtonState.initState] index: $index\tevent: $event');
          _itemsDisabled[index] = event;
        });
        _itemDisabledSuscriptions.add(itemDisabledSuscription);
      });
    }
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    final width = _width;
    final height = _height;
    final dsClient = _dsClient;
    final responseTagName = _buildResponseTagName(_responseTagName,  _writeTagName);
    final backgroundColor = Theme.of(context).colorScheme.primary;
    final textColor = Theme.of(context).colorScheme.onPrimary;
    final isDisabledStream = _isDisabledStream ?? Stream.empty();
    return StreamBuilder2<DsDataPointExtracted<int>, bool>(
      streams: StreamTuple2(
        DsDataStreamExtract<int>(
          stream: (dsClient != null && responseTagName != null) 
            ? dsClient.streamInt(responseTagName) 
            : null,
          stateColors: Theme.of(context).stateColors,
        ).stream,
        isDisabledStream,
      ),
      builder: (context, snapshots) {
        int? value = null;
        bool isDisabled = false;
        if (snapshots.snapshot1.hasData) {
          final point = snapshots.snapshot1.data;
          if (point != null) {
            value = point.value;
            _lastSelectedValue = value;
            if (_state.isLoading) Future.delayed(
              Duration.zero,
              () => setState(() {
                _state.setLoaded();
              }),
            );
          }
        }
        if (snapshots.snapshot2.hasData) {
          isDisabled = snapshots.snapshot2.data ?? false;
        }        
        log(_debug, '$_DropDownControlButtonState.build isDisabled: ', isDisabled);
        return PopupMenuButton<int>(
          // color: backgroundColor,
          offset: Offset(width != null ? width * 0.7 : 100, height != null ? height : 0),
          enabled: !isDisabled,
          tooltip: _tooltip,
          child: Stack(
            children: [
              ColorFiltered(
                colorFilter: AppUiSettings.colorFilterDisabled(context, isDisabled),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  width: _width,
                  height: _height,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return _buildButtonIcon(value, textColor, _animationController.value);
                    }
                  ),
                ),
              ),
              if (_state.isLoading || _state.isSaving) Positioned.fill(
                child: Container(
                  color: Theme.of(context).backgroundColor.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).backgroundColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          itemBuilder: (context) {
            return _items.map((index , item) {
              return MapEntry(
                index, 
                PopupMenuItem<int>(
                  key: UniqueKey(),
                  value: index,
                  enabled: !_itemIsDisabled(index),
                  onTap: () {
                  },
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: _itemIsDisabled(index)
                        ? textColor.withOpacity(0.3)
                        : textColor,
                    ),
                  ),
                ),
              );
            }).values.toList();
          },
          onCanceled: () {
            log(_debug, '[$_DropDownControlButtonState] onCanceled');
          },
          onSelected: (value) {
            log(_debug, '[$_DropDownControlButtonState] onSelected: ', value);
            if (_items.containsKey(value)) {
              final sendValue = value;
              if (sendValue != _lastSelectedValue) {
                _sendValue(_dsClient, _writeTagName, _responseTagName, sendValue);
              }
            }
          },
        );
      }
    );
  }
  ///
  bool _itemIsDisabled(index) {
    return _itemsDisabled.containsKey(index) ? _itemsDisabled[index] ?? false : false;
  }
  ///
  Widget _buildButtonIcon(int? value, Color color, double animationValue) {
    final label = _label;
    final selectedItem = _items[value];
    if (selectedItem == null) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    return Stack(
      children: [
        if (label != null) Transform.scale(
              scale: 1 - 0.2 * animationValue,
              child: Transform.translate(
                offset: Offset(0.0, - (Theme.of(context).textTheme.titleMedium?.fontSize ?? 18) * 0.07 * animationValue),
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.apply(
                    color: color.withOpacity(1 - 0.2 * animationValue)
                  ),
                ),
              ),
            ),
        if (selectedItem != null) Center(

          child: Text(
            selectedItem,
            style: Theme.of(context).textTheme.titleMedium!.apply(
              color: color,
            ),
          ),
        ),
      ],
    );
        // return Text(
        //   '${_items[value]}',
        //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
        //     color: color,
        //   ),
        // );
      // }
    // }
    // return Text(
    //   '$_label',
    //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
    //     color: color,
    //   ),
    // );
  }
  ///
  String? _buildResponseTagName(String? responseTagName, DsPointPath? writeTagName) {
    if (responseTagName != null) {
      return responseTagName;
    }
    if (writeTagName != null) {
      return writeTagName.name;
    }
    return null;
  }
  ///
  void _sendValue(DsClient? dsClient, DsPointPath? writeTagName, String? responseTagName, int? newValue) {
    final value = newValue;
    if (dsClient != null && writeTagName != null && value != null) {
      setState(() {
        _state.setSaving();
      });
      DsSend<int>(
        dsClient: dsClient, 
        pointPath: writeTagName, 
        response: responseTagName,
      )
        .exec(value)
        .then((responseValue) {
          setState(() {
            _state.setSaved();
          });
        });
    }
  }  
  ///
  @override
  void dispose() {
    _itemDisabledSuscriptions.forEach((suscription) {
      suscription.cancel();
    });
    super.dispose();
  }
}
