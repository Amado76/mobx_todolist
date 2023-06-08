import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class UserCredentialMock extends Mock implements UserCredential {
  @override
  User get user => UserMock();
}

class UserMock extends Mock implements User {
  @override
  String? get email => 'teste@gmail.com';
  @override
  String get uid => '1976';
  @override
  Future<String> getIdToken([bool forceRefresh = false]) {
    return Future.value('token');
  }
}

class EmailAuthProviderMock extends Mock implements EmailAuthProvider {}

class AuthCredentialMock extends Mock implements AuthCredential {}
