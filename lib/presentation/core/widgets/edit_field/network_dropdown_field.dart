import 'dart:core';

import 'package:another_flushbar/flushbar_helper.dart';
import 'package:configure_cma/domain/auth/app_user_stacked.dart';
import 'package:configure_cma/domain/auth/auth_result.dart';
import 'package:configure_cma/domain/core/entities/ds_point_path.dart';
import 'package:configure_cma/domain/core/entities/ds_data_stream_extract.dart';
import 'package:configure_cma/domain/core/entities/network_operation_state.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/domain/settings/oil-data.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:configure_cma/infrastructure/auth/network_field_authenticate.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/infrastructure/stream/ds_send.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

///
class NetworkDropdownFormField extends StatefulWidget {
  // final Future<AuthResult> Function(BuildContext context)? _onAuthRequested;
  final List<String> _allowedGroups;
  final AppUserStacked? _users;
  final DsClient? _dsClient;
  final DsPointPath? _writeTagName;
  final String? _responseTagName;
  final String? _labelText;
  final double _width;
  ///
  const NetworkDropdownFormField({
    Key? key,
    // Future<AuthResult> Function(BuildContext context)? onAuthRequested,
    List<String> allowedGroups = const [],
    AppUserStacked? users,
    DsClient? dsClient,
    DsPointPath? writeTagName,
    String? responseTagName,
    String? labelText,
    double width = 350.0,
  }) : 
    // _onAuthRequested = onAuthRequested,
    _allowedGroups = allowedGroups,
    _users = users,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _labelText = labelText,
    _width = width,
    super(key: key);
  ///
  @override
  State<NetworkDropdownFormField> createState() => _NetworkDropdownFormFieldState(
    // onAuthRequested: _onAuthRequested,
    allowedGroups: _allowedGroups,
    users: _users,
    dsClient: _dsClient,
    writeTagName: _writeTagName,
    responseTagName: _responseTagName,
    labelText: _labelText,
    width: _width,
  );
}

///
class _NetworkDropdownFormFieldState extends State<NetworkDropdownFormField> {
  static const _debug = true;
    final dropdownState = GlobalKey<FormFieldState>();
  final _state = NetworkOperationState(isLoading: true);
  final OilData _oilData = OilData(assetName: 'assets/settings/oil-list.json');
  // final Future<AuthResult> Function(BuildContext context)? _onAuthRequested;
  final List<String> _allowedGroups;
  late AppUserStacked? _users;
  final DsClient? _dsClient;
  final DsPointPath? _writeTagName;
  final String? _responseTagName;
  final String? _labelText;
  final double _width;
  bool _accessAllowed = false;
  int? _dropdownValue;
  int? _initValue;
  List<String> _oilNames = [];
  ///
  _NetworkDropdownFormFieldState({
    // required Future<AuthResult> Function(BuildContext context)? onAuthRequested,
    required List<String> allowedGroups,
    required AppUserStacked? users,
    required DsClient? dsClient,
    required DsPointPath? writeTagName,
    required String? responseTagName,
    required String? labelText,
    required double width,
  }) :
    // _onAuthRequested = onAuthRequested,
    _allowedGroups = allowedGroups,
    _users = users,
    _dsClient = dsClient,
    _writeTagName = writeTagName,
    _responseTagName = responseTagName,
    _labelText = labelText,
    _width = width,
    super();
  ///
  @override
  void initState() {
    super.initState();
    _oilData.names()
      .then((value) {
        setState(() {
          _oilNames = value;
        });
      });
  }
  ///
  @override
  Widget build(BuildContext context) {
    final width = _width;
    final _dropMenuItemWidth = width * 0.7;
    final stateColors = Theme.of(context).stateColors;
    final dsClient = _dsClient;
    final responseTagName = _buildResponseTagName(_responseTagName,  _writeTagName);
    return SizedBox(
      width: _width,
      child: StreamBuilder<DsDataPointExtracted<int>>(
        stream: DsDataStreamExtract<int>(
          stream: (dsClient != null && responseTagName != null) 
            ? dsClient.streamInt(responseTagName) 
            : null,
          stateColors: stateColors,
        ).stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
          } else if (snapshot.hasData) {
            final point = snapshot.data;
            if (point != null) {
              _initValue = point.value;
              _dropdownValue = _initValue;
              _state.setLoaded();
            }
          }
          return DropdownButtonFormField<int>(
            key: dropdownState,
            value: _dropdownValue,
            onChanged: (newValue) {
              log(_debug, '[$_NetworkDropdownFormFieldState.onChanged] value: $newValue');
              if (newValue != _initValue) {
                dropdownState.currentState?.didChange(_initValue);
              }
              _requestAccess().then((value) {
                if (_accessAllowed) {
                  _sendValue(_dsClient, _writeTagName, _responseTagName, newValue);
                }
              });
            },
            decoration: InputDecoration(
              labelText: _labelText,
              labelStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: Theme.of(context).textTheme.labelLarge!.fontSize,
              ),
              suffixIcon: _buildSufixIcon(),
              filled: true,
              fillColor: Theme.of(context).backgroundColor,
            ),
            alignment: AlignmentDirectional.centerEnd,
            items: _buildDropdownMenuItems(context, _oilNames, _dropMenuItemWidth), 
          );
        },
      ),
    );
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
  List<DropdownMenuItem<int>> _buildDropdownMenuItems(BuildContext context, List<String> oilNames, double width) {
    return oilNames.asMap().map((index, name) {
      log(_debug, '[$_NetworkDropdownFormFieldState._buildDropdownMenuItems]');
      return MapEntry(
        index, 
        DropdownMenuItem<int>(
          value: index,
          child: SizedBox(width: width, child: Text(name, textAlign: TextAlign.center)),
          alignment: Alignment.center,
        ),
      );
    }).values.toList();
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
  Widget? _buildSufixIcon() {
    if (_state.isLoading || _state.isSaving) {
      return _buildProgressIndicator(); 
    }
    if (_state.isChanged) {
      return const Icon(Icons.info_outline);
    }
    if (_state.isSaved) {
      return Icon(Icons.check, color: Theme.of(context).primaryColor);
    }
    return null;
  }
  ///
  Widget _buildProgressIndicator() {
    return const SizedBox(
      width: 13, height: 13,
      child: Padding(
        padding: EdgeInsets.all(9.0),
        child: CircularProgressIndicator(strokeWidth: 3,),
      ),
    );
  }
  /// Проверяет наличие доступа у текущего пользователя 
  /// на редактирования данного поля
  Future<void> _requestAccess() async {
    if (_allowedGroups.isEmpty) {
      _accessAllowed = true;
      return;
    }
    final users = _users;
    if (users != null) {
      final user = users.peek;
      if (user.exists()) {
        if (_allowedGroups.contains(user.userGroup().value)) {
          _accessAllowed = true;
          return;
        }
      }
      networkFieldAuthenticate(context, users).then((AuthResult authResult) {
        if (authResult.authenticated) {
          setState(() {
            _accessAllowed = true;
            return;
          });
        }
      });
    }
    final message = AppText('Editing is not permitted for current user').local;
    FlushbarHelper.createError(
      duration: AppUiSettings.flushBarDurationMedium,
      message: message,
    ).show(context);
    _accessAllowed = false;
  }
}
