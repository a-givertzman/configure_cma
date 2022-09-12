import 'package:configure_cma/domain/translate/app_lang.dart';
import 'package:configure_cma/domain/translate/app_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppText', () {
    const wrongValue = 'such term doesn`t exists in the dictionary';
    final values = [
      'Apply',
      'Next',
      'Welcome',
      'Loading...',
      'Please authenticate to continue...',
      'Please enter your login',
    ];
    final valuesLc = [
      'apply',
      'next',
      'welcome',
      'loading...',
      'please authenticate to continue...',
      'please enter your login',
    ];
    final valuesTranslated = [
      'Применить',
      'Далее',
      'Добро пожаловать',
      'Загружаю...',
      'Авторизуйтесь что бы продолжить...',
      'Введите ваш логин',
    ];
    setUp(() {
    },);
    test('create', () {
      expect(const AppText(''), isInstanceOf<AppText>());
      const appText = AppText('Next');
      const appText1 = AppText('Next');
      expect(appText == appText1, equals(true));
    });
    test('AppText.to()', () {
      expect(const AppText(wrongValue).to(AppLang.en), equals(wrongValue));
      values.asMap().forEach((i, v) {
        final tr = valuesTranslated[i];
        expect(AppText(v).to(AppLang.en), equals(v));
        expect(AppText(v).to(AppLang.ru), equals(tr));
      });
      valuesLc.asMap().forEach((i, v) {
        final tr = valuesTranslated[i];
        expect(AppText(v).to(AppLang.en).toLowerCase(), equals(v));
        expect(AppText(v).to(AppLang.ru), equals(tr));
      });
    });
    test('AppText.tr()', () {
      expect(AppText.tr(wrongValue, lng: AppLang.en), equals(wrongValue));
      values.asMap().forEach((i, v) {
        final tr = valuesTranslated[i];
        expect(AppText.tr(v, lng: AppLang.en), equals(v));
        expect(AppText.tr(v, lng: AppLang.ru), equals(tr));
      });
      valuesLc.asMap().forEach((i, v) {
        final tr = valuesTranslated[i];
        expect(AppText.tr(v, lng: AppLang.en).toLowerCase(), equals(v));
        expect(AppText.tr(v, lng: AppLang.ru), equals(tr));
      });
    });
    test('AppText.local', () {
      expect(const AppText(wrongValue).local, equals(wrongValue));
      values.asMap().forEach((i, v) {
        final tr = valuesTranslated[i];
        expect(AppText(v).local, equals(tr));
      });
      valuesLc.asMap().forEach((i, v) {
        final tr = valuesTranslated[i];
        expect(AppText(v).local, equals(tr));
      });    });    
  },);
}
