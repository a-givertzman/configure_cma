import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final Color? color;
  final Color borderColor;
  final List values;
  final List<int> flex;
  const RowWidget({
    super.key,
    required this.color,
    required this.borderColor,
    required this.values,
    required this.flex,
  });
  ///
  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values.map((value) {
        return CellWidget(
          flex: flex[index],
          color: color,
          borderColor: borderColor,
          data: value,
        );
      },).toList(),
    );
  }
}
