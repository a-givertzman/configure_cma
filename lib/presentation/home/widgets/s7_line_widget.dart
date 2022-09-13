import 'package:configure_cma/domain/core/entities/s7_line.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_ied_widget.dart';
import 'package:flutter/material.dart';

class S7LineWidget extends StatefulWidget {
  final List<S7Line> _lines;
  ///
  S7LineWidget({
    Key? key,
    required List<S7Line> lines,
  }) : 
    _lines = lines,
    super(key: key);
  ///
  @override
  State<S7LineWidget> createState() => _S7LineWidgetState();
}


class _S7LineWidgetState extends State<S7LineWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget._lines.isNotEmpty) {
      return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget._lines.length,
        itemBuilder: ((context, lineIndex) {
            final line = widget._lines[lineIndex];
            final color = Theme.of(context).colorScheme.primary.withAlpha(90);
            const borderColor = Colors.white10;
            return Column(
              children: [
                LineRowWidget(
                  color: color, 
                  borderColor: borderColor, 
                  values: [line.name],
                ),
                S7IedWidget(ieds: line.ieds.values.toList()),
              ],
            );
        })
      );
    } else {
      return Center(child: Text('Now data'));
    }
  }
}

class LineRowWidget extends StatelessWidget {
  final Color? color;
  final Color borderColor;
  final List<String> values;
  const LineRowWidget({
    super.key,
    required this.color,
    required this.borderColor,
    required this.values,
  });
  ///
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CellWidget(
          flex: 5,
          color: color,
          borderColor: borderColor,
          data: values[0],
        ),
      ],
    );
  }
}
