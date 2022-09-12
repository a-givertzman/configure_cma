import 'package:configure_cma/domain/core/error/failure.dart';
import 'package:configure_cma/infrastructure/datasource/data_set.dart';

class DataSource {
  final Map<String, DataSet> _dataSets;
  const DataSource(this._dataSets);
  DataSet<T> dataSet<T>(String name) {
    if (_dataSets.containsKey(name)) {
      final dataSet = _dataSets[name];
        return dataSet! as DataSet<T>;
    }
    throw Failure.dataSource(
      message: 'Ошибка в методе $runtimeType.dataSet(): $name - несуществующий DataSet',
      stackTrace: StackTrace.current,
    );
  }
}
