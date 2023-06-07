import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class CellWidget<T> extends StatefulWidget {
  final T? _data;
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
    int flex = 1,
    Color? color,
    Color? borderColor,
    void Function(String value)? onChanged,
    bool readOnly = false,
    String? tooltip,
  }) : 
    _data = data,
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
  // static const _debug = true;
  final TextEditingController _editingController = TextEditingController();
  bool _isEditing = false;
  ///
  @override
  void initState() {
    super.initState();
    _editingController.text = widget._data != null ? '${widget._data}' : '';
  }
  ///
  @override
  Widget build(BuildContext context) {
    const padding = AppUiSettings.padding;
    Color? color = widget._color;
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
          child: buildEditField(padding),
        ),
      ),
    );
  }
  ///
  Widget buildEditField(double padding) {
    if (_isEditing) {
      return RepaintBoundary(
        child: TextField(
          readOnly: widget._readOnly,
          controller: _editingController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.1),
          ),
          maxLines: 1,
          onChanged: _onValueChanged,
          onTapOutside: (event) {
            setState(() {_isEditing = false;});
          },
          onEditingComplete: () {
            setState(() {_isEditing = false;});
          },
        ),
      );
    } else { 
      return InkWell(
        child: Text(
          _editingController.value.text,
          softWrap: false,
        ),
        onTap: () {
          setState(() {_isEditing = true;});
        },
      );
    }
  }
  ///
  void _onValueChanged(String value) {
    final onChacnged = widget._onChanged;
    if (onChacnged != null) {
      onChacnged(value);
    }
  }
}
