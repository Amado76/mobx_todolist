import 'package:mobx_todolist/store/auth_user_model.dart';
import 'package:mocktail/mocktail.dart';

class AuthUserMock extends Mock implements AuthUser {
  @override
  String get userId => '1976';
  @override
  String get email => 'teste@gmail.com';
  @override
  String get token => 'token';
}
