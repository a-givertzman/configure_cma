import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class CellWidget<T> extends StatefulWidget {
  final T? _data;
  final T? _newData;
  final int _flex;
  final Color? _color;
  final Color _borderColor;
  final void Function(String value)? _onChanged;
  final bool _readOnly;
  final String _tooltip;
  ///
  CellWidget({
    Key? key,
    T? data,
    T? newData,
    int flex = 1,
    Color? color,
    Color? borderColor,
    void Function(String value)? onChanged,
    bool readOnly = false,
    String? tooltip,
  }) : 
    _data = data,
    _newData = newData,
    _flex = flex,
    _color = color,
    _borderColor = borderColor ?? Colors.white10,
    _onChanged = onChanged,
    _readOnly = readOnly,
    _tooltip = tooltip ?? '',
    super(key: key);
  ///
  @override
  State<CellWidget<T>> createState() => _CellWidgetState<T>();
}

///
class _CellWidgetState<T> extends State<CellWidget<T>> {
  static const _debug = true;
  final TextEditingController _editingController = TextEditingController();
  ///
  @override
  void initState() {
    super.initState();
  }
  ///
  @override
  Widget build(BuildContext context) {
    const padding = AppUiSettings.padding;
    final newData = widget._newData;
    Color? color = widget._color;
    if (newData != null) {
      if (widget._data != newData) {
        color = Colors.yellow.withAlpha(100);
      }
    }
    _editingController.text = widget._data != null ? '${widget._data}' : '';
    return Expanded(
      flex: widget._flex,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: widget._borderColor),
        ),
        child: Tooltip(
          message: widget._tooltip,
          child: TextFormField(
            readOnly: widget._readOnly,
            controller: _editingController,
            decoration: InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.1),
            ),
            maxLines: 1,
            onChanged: (value) {
              final onChacnged = widget._onChanged;
              if (onChacnged != null) {
                onChacnged(value);
              }
            },
          ),
        ),
      ),
    );
  }
}
