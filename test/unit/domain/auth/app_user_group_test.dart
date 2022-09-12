import 'package:crane_monitoring_app/domain/auth/app_user_group.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUserGroup', () {
    setUp(() {
    },);
    test('create', () {
      expect(AppUserGroup(UserGroupList.admin), isInstanceOf<AppUserGroup>());
    });
    test('value', () {
      expect(AppUserGroup(UserGroupList.admin).value, equals(UserGroupList.admin));
      expect(AppUserGroup(UserGroupList.operator).value, equals(UserGroupList.operator));
    });
    test('text()', () {
      expect(AppUserGroup(UserGroupList.admin).text(), equals('Администратор'));
      expect(AppUserGroup(UserGroupList.operator).text(), equals('Оператор'));
    });
    test('textOf()', () {
      expect(AppUserGroup(UserGroupList.operator).textOf(UserGroupList.admin), equals('Администратор'));
      expect(AppUserGroup(UserGroupList.admin).textOf(UserGroupList.operator), equals('Оператор'));
    });    
  },);
}
