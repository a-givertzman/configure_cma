import 'package:configure_cma/domain/core/entities/s7_point.dart';
import 'package:configure_cma/domain/core/log/log.dart';
import 'package:configure_cma/presentation/home/widgets/point_row_widget.dart';
import 'package:configure_cma/presentation/home/widgets/row_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_marked.dart';
import 'package:flutter/material.dart';

class S7PointWidget extends StatefulWidget {
  final Map<String, S7PointMarked> points;
  final Map<String, S7Point>? _newPoints;
  final Map<String, int>? _flex;
  ///
  S7PointWidget({
    Key? key,
    required this.points,
    Map<String, S7Point>? newPoints,
    Map<String, int>? flex,
  }) : 
    _newPoints = newPoints,
    _flex = flex,
    super(key: key);
  ///
  @override
  State<S7PointWidget> createState() => _S7PointWidgetState();
}

///
class _S7PointWidgetState extends State<S7PointWidget> {
  static const _debug = true;
  ///
  bool _isDeleted(String key, Map<String, S7Point>? newPoints) {
    if (newPoints == null) {
      return false;
    } else if (newPoints.isEmpty) {
      return true;
    } else {
      if (!newPoints.containsKey(key)) log(_debug, '[_S7PointWidgetState._isDeleted] deleted: ', key);
      return !newPoints.containsKey(key);
    }
  }
  ///
  bool _isNew(String key, Map<String, S7Point> points) {
    if (!points.keys.contains(key)) log(_debug, '[_S7PointWidgetState._buildPointList] NEW: ', key);
    return ! points.keys.contains(key);
  }
  ///
  void _buildPointList() {
    // final Map<String, S7PointMarked> oldPoints = Map.from(widget._points);
    final newPoints = widget._newPoints;
    if (newPoints != null) {
      newPoints.forEach((key, value) {
        // log(_debug, '[_S7PointWidgetState._buildPointList] check for new: $key: ', value);
        if (_isNew(key, widget.points)) {
          widget.points[key] = S7PointMarked(value, isNew: true);
        }
      });

      widget.points.forEach((key, point) {
        if (_isDeleted(key, newPoints)) {
          point.setIsDeleted();
        }
      });
    }
  }
  ///
  @override
  Widget build(BuildContext context) {
    _buildPointList();
    final points = widget.points.values.toList();
    points.sort((a, b) => a.offset.compareTo(b.offset));
    Color? color = null;
    final flex = widget._flex ?? {'v': 2, 'name': 20, 'type': 5, 'offset': 3, 'bit': 3, 'threshold': 3, 'h': 3, 'a': 3, 'comment': 15};
    const borderColor = Colors.white10;
    log(_debug, '[$_S7PointWidgetState.build] _points: ');
    return Column(
      children: [
        RowWidget(
          color: color,
          borderColor: borderColor,
          values: ['v', 'name', 'type', 'offset', 'bit', 'threshold', 'h', 'a', 'comment'],
          flex: [flex['v']!, flex['name']!, flex['type']!, flex['offset']!, flex['bit']!, flex['threshold']!, flex['h']!, flex['a']!, flex['comment']!],
          tooltips: [
            'Виртуальный сигнал, в контроллере отсутствует, используется в DataServer для диагностики и математики',
            'Имя тега, читается из конфигурации контроллера',
            'Тип тэга, читается из конфигурации контроллера',
            'Адрес тэга, читается из конфигурации контроллера',
            'Номер бита для тэгов типа Bool, читается из конфигурации контроллера',
            'Threshold - Порог нечувствительности тэга',
            'Атрибут записи в историю, активируется если 1, отключается если не указан',
            'Класс аварии, активируется если от 1 до 15, отключается если не указан',
            'Комментарий, может читаться из конфигурации контроллера, если указан',
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: points.length,
          itemBuilder: ((context, index) {
              final pointMarked = points.elementAt(index);
              final key = pointMarked.name;
              final newPoint = widget._newPoints?[key];
              // color = null;
              log(_debug, pointMarked);
              return PointRowWidget(
                color: null,
                borderColor: borderColor,
                point: pointMarked,
                newPoint: newPoint,
                flex: widget._flex,
              );
          })
        ),
      ],
    );
  }
}



