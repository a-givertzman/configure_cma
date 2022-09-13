import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/settings/common_settings.dart';
import 'package:flutter/material.dart';

class CellWidget<T> extends StatefulWidget {
  final T _data;
  final int _flex;
  final Color? _color;
  final Color _borderColor;
  final void Function(T value)? _onChanged;
  CellWidget({
    Key? key,
    int flex = 1,
    Color? color,
    Color borderColor = Colors.white10,
    required T data,
    void Function(T value)? onChanged,
  }) : 
    _data = data,
    _flex = flex,
    _color = color,
    _borderColor = borderColor,
    _onChanged = onChanged,
    super(key: key);

  @override
  State<CellWidget<T>> createState() => _CellWidgetState<T>();
}

class _CellWidgetState<T> extends State<CellWidget<T>> {
  static const _debug = true;
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
          onChanged: (value) {
            final onChacnged = widget._onChanged;
            if (onChacnged != null) {
              if (T == int) {
                onChacnged(int.parse(value) as T);
              } else if (T == String) {
                onChacnged(value as T);
              } else {
                log(_debug, 'Ошибка в методе onChanged класса $runtimeType: тип $T не поддерживается.');
              }
            }
          },
        ),
      ),
    );
  }
}
