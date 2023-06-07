import 'package:configure_cma/domain/core/log/log.dart';

class S7PointFr {
  static const _debug = true;
  late List<int>? _trip = null;
  late int? _nomConst = null;
  late String? _nomPoint = null;
  late Map<String, double>? _threshold = null;
  late double? _integralFactor = null;
  ///
  S7PointFr({
    List<int>? trip,
    int? nomConst,
    String? nomPoint,
    Map<String, double>? threshold,
    double? integralFactor,
  }) : 
    _trip = trip,
    _nomConst = nomConst,
    _nomPoint = nomPoint,
    _threshold = threshold,
    _integralFactor = integralFactor;
  ///
  factory S7PointFr.fromMap(Map? config) {
    if (config != null) {
      log(_debug, '[$S7PointFr.fromMap] fr config: ', config);
      final nom = config['nom'];
      if (nom != null) {
        log(_debug, '[$S7PointFr.fromMap] fr nom: ', nom);
        if (nom is int) {
          log(_debug, '[$S7PointFr.fromMap] fr nom is int: ', nom);
        } else if (nom is String) {
          log(_debug, '[$S7PointFr.fromMap] fr nom: is String ', nom);
        } else {
          log(_debug, '[$S7PointFr.fromMap] Uncnown type of nom: ', nom);
        }
      }
      log(_debug, '[$S7PointFr.fromMap] config["threshold"]: ', config['threshold']);
      return S7PointFr(
        trip: (config['trip'] as List<dynamic>?)?.map((e) => int.parse('$e')).toList(),
        nomConst: (nom != null && nom is int) ? nom : null,
        nomPoint: (nom != null && nom is String) ? nom : null,
        threshold: config['threshold'] != null ? Map<String, double>.from(config['threshold']) : null,
        integralFactor: config['integralFactor']
      );
    }
    return S7PointFr();
  }
  ///
  bool get isEmpty {
    return _trip == null && _nomConst == null && (_nomPoint == null || (_nomPoint != null && _nomPoint!.isEmpty));
  }
  ///
  bool get isNotEmpty => !isEmpty;
  ///
  Map<String, dynamic> toJson() {
    log(_debug, '[$S7PointFr.toJson] _trip: ', _trip);
    log(_debug, '[$S7PointFr.toJson] _nomConst: ', _nomConst);
    log(_debug, '[$S7PointFr.toJson] _nomTag: ', _nomPoint);
    final result = {
      if (_trip != null) 'trip': _trip,
      if (_nomConst != null) 'nom': _nomConst,
      if (_nomPoint != null && _nomPoint!.isNotEmpty) 'nom': _nomPoint,
      if (_threshold != null) 'threshold': _threshold,
      if (_integralFactor != null) 'integralFactor': _integralFactor,
    };
    log(_debug, '[$S7PointFr.toJson] fr: ', result);
    return result;
  }
  ///
  @override
  bool operator ==(Object other) =>
    other is S7PointFr 
    // && other.runtimeType == runtimeType
    && other.act == _trip
    && other._nomConst == _nomConst
    && other.nomPoint == _nomPoint
    && other.threshold == _threshold
    && other.integralFactor == _integralFactor;
  ///
  List<int>? get act => _trip;
  int? get nomConst => _nomConst;
  String? get nomPoint => _nomPoint;
  Map<String, double>? get threshold => _threshold;
  double? get integralFactor => _integralFactor;
  ///
  void setTrip(String value) {
    _trip = value.split(',').map((vStr) => int.parse(vStr)).toList();
  }
  ///
  void setNomConst(int value) {
    _nomConst = value;
  }
  ///
  void setNomPoint(String value) {
    _nomPoint = value;
  }
  ///
  void setThreshol(Map<String, double> value) {
    _threshold = value;
  }
  ///
  void setIntegralFactor(String value) {
    _integralFactor = double.tryParse(value);
  }
  ///
  @override
  String toString() {
    if (_trip != null) {
      return 'trip: $_trip';
    } else if (_nomConst != null) {
      return 'nom: $_nomConst;  threshold: $_threshold;  integralFactor: $_integralFactor';
    } else if (_nomPoint != null) {
      return 'nom: $_nomPoint;\n\tthreshold: $_threshold;  integralFactor: $_integralFactor';
    }
    return '';
  }
}
