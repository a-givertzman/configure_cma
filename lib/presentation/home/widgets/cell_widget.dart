import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class CellWidget<T> extends StatefulWidget {
  final T _data;
  final int _flex;
  final Color? _color;
  final Color _borderColor;
  CellWidget({
    Key? key,
    int flex = 1,
    Color? color,
    Color borderColor = Colors.white10,
    required T data,
  }) : 
    _data = data,
    _flex = flex,
    _color = color,
    _borderColor = borderColor,
    super(key: key);

  @override
  State<CellWidget<T>> createState() => _CellWidgetState<T>();
}

class _CellWidgetState<T> extends State<CellWidget<T>> {
  final TextEditingController _editingController = TextEditingController();
  ///
  @override
  void initState() {
    super.initState();
    _editingController.text = widget._data.toString();
  }
  ///
  @override
  Widget build(BuildContext context) {
    const padding = AppUiSettings.padding;
    return Expanded(
      flex: widget._flex,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: widget._color,
          border: Border.all(color: widget._borderColor),
        ),
        child: TextFormField(
          controller: _editingController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 0.1),
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
