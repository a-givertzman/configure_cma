import 'package:crane_monitoring_app/domain/core/entities/ds_point_path.dart';
import 'package:crane_monitoring_app/domain/core/log/log.dart';
import 'package:crane_monitoring_app/domain/translate/app_lang.dart';
// ignore_for_file: avoid_classes_with_only_static_members

class EventText {
  static const _debug = true;
  final DsPointPath _value;
  static final _mapPath = <String, List<String>>{
    '/server/line1/ied11/db899_drive_data_exhibit': ['Exhibit', 'Выставка'],
    '/server/line1/ied12/db902_panel_controls': ['Settings', 'Уставки'],
    '/server/line1/ied13/db905_visual_data_hast': ['Visual data fast', 'Visual data fast'],
    '/server/line1/ied14/db906_visual_data': ['Visual data', 'Visual data'],
    // '/server/line1//': ['', ''],
    // '/server/line1//': ['', ''],
    // '/server/line1//': ['', ''],

  };
  static final _mapName = <String, List<String>>{
    'HPU.Pump1.Active': ['HPU.Pump1.Active', 'HPU.Pump1.Active',],
    'HPU.Pump1.Alarm': ['HPU.Pump1.Alarm', 'HPU.Pump1.Alarm'],
    'HPU.Pump2.Active': ['HPU.Pump2.Active', 'HPU.Pump2.Active'],
    'HPU.Pump2.Alarm': ['HPU.Pump2.Alarm', 'HPU.Pump2.Alarm'],
    'HPU.OilTemp': ['HPU.Oil Temp', 'HPU.Температура масла'],
    // '': ['', ''],
    // '': ['', ''],
    // '': ['', ''],
    // '': ['', ''],
    // '': ['', ''],
    // '': ['', ''],
    // '': ['', ''],
    // '': ['', ''],
    // '': ['', ''],
  };
  ///
  const EventText(DsPointPath value):
    _value = value;
  ///
  /// returns translations to the current [AppLang]
  DsPointPath get local => to(appLng);
  DsPointPath to(AppLang lng) {
    return DsPointPath(
      path: tr(
        _mapPath,
        _value.path,
        lng: lng,
      ), 
      name: tr(
        _mapName,
        _value.name,
        lng: lng,
      ),
    );
  }
  ///
  /// returns translations ov [value] to the current [lng]
  static String tr(Map<String, List<String>> map, String value, {AppLang? lng}) {
    final AppLang _lng = lng ?? appLng;
    // log(_debug, '[EventText.tr] value: "$value"');
    if (map.containsKey(value)) {
      log(_debug, '[EventText.tr] value exists in dict');
      final translations = map[value];
      if (translations != null) {
        if (_lng.index < translations.length) {
          return translations[_lng.index];
        } else {
          return value;
        }
      }
    } else {
      // log(_debug, '[EventText.tr] value does not exists in dict');
      final _value = value.toLowerCase().trim();
      // log(_debug, '[EventText.tr] trying to find value: "$_value"');
      final _key = map.keys.firstWhere(
        (key) {
          if (key.toLowerCase().trim() == _value) {
            return true;
          }
          return false;
        },
        orElse: () => '',
      );
      if (_key.isNotEmpty) {
        final translations = map[_key];
        if (translations != null) {
          if (_lng.index < translations.length) {
            return translations[_lng.index];
          } else {
            return value;
          }
        }
      }
      return value;
    }
    // throw Failure.translation(
    //   message: "[EventText] '$text' - перевод отсутствует",
    //   stackTrace: StackTrace.current,
    // );
    log(_debug, '[EventText.tr] нет перевода для "$value"');
    return value;
  }
}
