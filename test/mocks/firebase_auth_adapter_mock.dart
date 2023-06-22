import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx_todolist/adapter/auth_adapter.dart';
import 'package:mobx_todolist/store/auth_user_model.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_user_mock.dart';
import 'firebase_auth_mock.dart';

class FirebaseAuthAdapterMock extends Mock implements FirebaseAuthAdapter {
  @override
  FirebaseAuth get firebaseAuth => FirebaseAuthMock();
  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    return AuthUserMock();
  }

  @override
  getLoggedUser() async {
    return AuthUserMock();
  }

  @override
  Future<AuthUser> register(
      {required String email, required String password}) async {
    return AuthUserMock();
  }
}
