import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final Color? color;
  final Color borderColor;
  final List values;
  final List<int?> flex;
  final List<String?>? tooltips;
  const RowWidget({
    super.key,
    required this.color,
    required this.borderColor,
    required this.values,
    required this.flex,
    this.tooltips,
  });
  ///
  @override
  Widget build(BuildContext context) {
    int index = -1;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values.map((value) {
        index++;
        return CellWidget(
          flex: flex[index] ?? 1,
          tooltip: tooltips != null ? ((index < tooltips!.length) ? tooltips![index] : null) : null,
          color: color,
          borderColor: borderColor,
          data: value,
        );
      },).toList(),
    );
  }
}
