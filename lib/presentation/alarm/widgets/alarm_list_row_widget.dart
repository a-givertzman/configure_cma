import 'package:crane_monitoring_app/domain/alarm/alarm_list_point.dart';
import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/event/event_text.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';
import 'package:crane_monitoring_app/presentation/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AlarmListRowWidget extends StatelessWidget {
  static const _debug = true;
  final AlarmListPoint _point;
  final bool _highlite;
  final void Function(AlarmListPoint)? _onAcknowledgment;
  ///
  const AlarmListRowWidget({
    Key? key,
    required AlarmListPoint point,
    void Function(AlarmListPoint)? onAcknowledgment,
    bool? highlite,
  }) : 
    _point = point,
    _onAcknowledgment = onAcknowledgment,
    _highlite = highlite ?? false,
    super(key: key);
  ///
  @override
  Widget build(BuildContext context) {
    const borderColor = Colors.white10;
    final Color? color = _buildColor(context, _point, _highlite);
    final pointPath = EventText(DsPointPath(path: _point.path, name: _point.name)).local;
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context, 
          builder: (context) {
            return AlertDialog(
              title: Text(
                AppText('Acknowledge the event').local + '?',
              ),
              content: Text(
                pointPath.path + '/' + pointPath.name,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  }, 
                  child: Text(AppText('Cancel').local),
                ),
                TextButton(
                  onPressed: () {
                    final onAcknowledgment = _onAcknowledgment;
                    if (onAcknowledgment != null) {
                      onAcknowledgment(_point);
                    }
                    Navigator.of(context).pop();
                  }, 
                  child: Text(AppText('Ok').local),
                ),
              ],
            );
          },
        );
      },
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: borderColor),
              ),
              child: Text('${_point.alarm}'),
            ),
          ),
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: borderColor),
              ),
              child: Text(_point.timestamp),
            ),
          ),
          Expanded(
            flex: 14,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: borderColor),
              ),
              child: Text('${pointPath.path}/${pointPath.name}'),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: borderColor),
              ),
              child: Text('${_point.value}'),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: color,
                border: Border.all(color: borderColor),
              ),
              child: Text(_point.status.name.name),
            ),
          ),
        ],
      ),
    );
  }
  ///
  Color? _buildColor(BuildContext context, AlarmListPoint point, bool highlite) {
    final ararmColors = Theme.of(context).alarmColors;
    if (highlite) {
      return Theme.of(context).colorScheme.primary.withOpacity(0.4);
    }
    final value = double.tryParse(point.value) ?? 0;
    if (value > 0) {
      if (point.alarm == 1) {
        return ararmColors.class1.withOpacity(0.4);
      }
      if (point.alarm == 2) {
        return ararmColors.class2.withOpacity(0.4);
      }
      if (point.alarm == 3) {
        return ararmColors.class3.withOpacity(0.4);
      }
      if (point.alarm == 4) {
        return ararmColors.class4.withOpacity(0.4);
      }
      if (point.alarm == 5) {
        return ararmColors.class5.withOpacity(0.4);
      }
      if (point.alarm == 6) {
        return ararmColors.class6.withOpacity(0.4);
      }
      log(_debug, 'WARNING: [$AlarmListRowWidget._buildColor] alarm class color index "${point.alarm} not found"');
      return Theme.of(context).errorColor.withOpacity(0.4);
    }
    if (point.acknowledged) {
      return Theme.of(context).backgroundColor.withOpacity(0.4);
    }
    return null;
  }
}
