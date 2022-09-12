import 'package:crane_monitoring_app/domain/core/entities/value_object.dart';
import 'package:crane_monitoring_app/domain/core/entities/value_validation.dart';

class ValueString extends ValueObject<String> {
  final List<ValueValidation>? _validationList;
  const ValueString(
    String value,
    {List<ValueValidation>? validationList,}
  ):
    _validationList = validationList,
    super(value);
  @override
  String toString() {
    return super.value;
  }
  bool isEmpty() {
    return super.value.isEmpty;
  }
  bool isNotEmpty() {
    return super.value.isNotEmpty;
  }
  String valid() {
    final _vList = _validationList;
    if (_vList == null) {
      return '';
    }
    return _vList.map(
      (_validation) => _validation.validate(value),
    ).join('; ') ;
  }
  @override
  ValueObject<String> toDomain(String v) {
    return ValueString(v);
  }
}
