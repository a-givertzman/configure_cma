import 'package:crane_monitoring_app/domain/core/entities/validation_result.dart';
import 'package:crane_monitoring_app/domain/translate/app_text.dart';

/// Класс хранит login пользователя
/// метод validate() возвращает положительный ValidationResult 
/// если длина 5...255 символов из ряда ^[A-Za-z][A-Za-z0-9_\.\-]{4,254}$
class UserLogin {
  final String _value;
  ///
  const UserLogin({
    required String value,
  }): 
    _value = value;
  ///
  ValidationResult validate() {
    final regex = RegExp(r"^[A-Za-z0-9_\-.]{5,254}$");
    final _valid = regex.hasMatch(_value);
    return ValidationResult(
      valid: _valid,
      message: _valid ? null : const AppText('Login must be..').local,
    );
  }
  /// возвращает текст логина
  String value() => _value;
}
