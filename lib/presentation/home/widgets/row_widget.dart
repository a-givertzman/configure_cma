import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final List<RowWidgetItem> items;
  final Color? color;
  final Color borderColor;
  const RowWidget({
    super.key,
    required this.items,
    required this.color,
    required this.borderColor,
  });
  ///
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        return CellWidget(
          data: item.value,
          flex: item.flex ?? 1,
          tooltip: item.tooltip,
          color: color,
          borderColor: borderColor,
          onChanged: item.onChanged,
        );
      },).toList(),
    );
  }
}


class RowWidgetItem {
  final dynamic value;
  final int? flex;
  final String? tooltip;
  final void Function(String)? onChanged;
  const RowWidgetItem({
    required this.value,
    required this.flex,
    this.tooltip,
    this.onChanged,
  });  
}