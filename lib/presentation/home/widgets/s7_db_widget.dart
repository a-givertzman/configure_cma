
import 'package:configure_cma/domain/core/entities/s7_db.dart';
import 'package:configure_cma/infrastructure/stream/ds_client.dart';
import 'package:configure_cma/presentation/core/theme/app_theme.dart';
import 'package:configure_cma/presentation/home/widgets/cell_widget.dart';
import 'package:configure_cma/presentation/home/widgets/s7_point_widget.dart';
import 'package:configure_cma/presentation/home/widgets/select_file_widget.dart';
import 'package:flutter/material.dart';

class S7DbWidget extends StatefulWidget {
  final DsClient? dsClient;
  final List<S7Db> _dbs;
  ///
  S7DbWidget({
    Key? key,
    this.dsClient,
    required List<S7Db> dbs,
  }) : 
    _dbs = dbs,
    super(key: key);
  ///
  @override
  State<S7DbWidget> createState() => _S7DbWidgetState();
}

//
class _S7DbWidgetState extends State<S7DbWidget> {
  // static const _debug = true;
  ///
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget._dbs.length,
      itemBuilder: ((context, index) {
        final db = widget._dbs[index];
        final color = Theme.of(context).colorScheme.primary.withAlpha(50);
        const borderColor = Colors.white10;
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CellWidget(
                  flex: 10,
                  color: color,
                  borderColor: borderColor,
                  data: db.name,
                  tooltip: 'Точное имя DB-блока как в контроллере, может содержать цифры, латинские буквы и подчерк',
                ),
                CellWidget(
                  flex: 15,
                  color: color,
                  borderColor: borderColor,
                  data: db.description,
                  tooltip: 'Пользовательское наименование',
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.number,
                  tooltip: 'Номер DB-блока, из конфигурации контроллера',
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.offset,
                  tooltip: 'Начало адресного пространства DB-блока, offset первого тега',
                ),
                CellWidget(
                  flex: 5,
                  color: db.sizeIsUpdated ? Colors.yellow.withAlpha(200) : color,
                  borderColor: borderColor,
                  data: db.size,
                  readOnly: true,
                  tooltip: 'Длина адресного пространства DB-блока, offset + size последнего тега',
                ),
                CellWidget(
                  flex: 5,
                  color: color,
                  borderColor: borderColor,
                  data: db.delay,
                  tooltip: 'Период опроса DB-блока, мс',
                ),
                FittedBox(
                  child: SelectFileWidget(
                    allowedExtensions: ['db', 'txt'],
                    onComplete: (path) {
                      db.updateFromDbFile(path).then((result) {
                        if (result.hasData) {
                          setState(() {});
                        }
                      });
                    },
                    icon: Tooltip(
                      child: Icon(Icons.file_download, color: Theme.of(context).colorScheme.primary),
                      message: 'Update DB config from file',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    setState(() {
                      db.newPoint();
                    });
                  }, 
                  icon: Tooltip(
                    child: Icon(Icons.add_circle_outline, color: Theme.of(context).stateColors.on,),
                    message: 'Add new tag to the current DB',
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    db.points.removeWhere((key, point) => point.isSelected);
                    db.updateDbSize;
                    setState(() {});
                  }, 
                  icon: Tooltip(
                    child: Icon(Icons.highlight_remove_outlined, color: Theme.of(context).colorScheme.error),
                    message: 'Remove selected tags from current DB',
                  ),
                ),
              ],
            ),
            S7PointWidget(
              flex: {'value': 3, 'v': 2, 'name': 20, 'type': 5, 'offset': 3, 'bit': 3, 'threshold': 3, 'h': 3, 'a': 3, 'fr': 3, 'comment': 15},
              points: db.points,
              newPoints: db.newPoints,
              dsClient: widget.dsClient,
            ),
          ],
        );
      })
    );
  }
}
