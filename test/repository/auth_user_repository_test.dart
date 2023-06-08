import 'package:flutter_test/flutter_test.dart';
import 'package:mobx_todolist/adapter/auth_adapter.dart';
import 'package:mobx_todolist/repository/auth_user_repository.dart';
import 'package:mobx_todolist/store/auth_user_store.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/auth_user_mock.dart';
import '../mocks/firebase_auth_adapter_mock.dart';

void main() {
  final FirebaseAuthAdapter firebaseAuthAdapterMock = FirebaseAuthAdapterMock();
  final authUserMock = AuthUserMock();
  final AuthUserRepository authUserRepository =
      AuthUserRepository(authAdapter: firebaseAuthAdapterMock);
  test(
      'should calls authAdapter.reautenticateAUser and authAdapter.deleteAccount when deleteAccount is called',
      () async {
    //Arrange
    when(() => firebaseAuthAdapterMock.reautenticateAUser(
        email: 'email',
        password: 'password')).thenAnswer((invocation) async => authUserMock);
    when(() => firebaseAuthAdapterMock.deleteAccount())
        .thenAnswer((invocation) async => Future.value(null));
    //Act
    await authUserRepository.deleteAccount(
        email: 'email', password: 'password');
    //Assert
    verify(() => firebaseAuthAdapterMock.reautenticateAUser(
        email: 'email', password: 'password')).called(1);
    verify(() => firebaseAuthAdapterMock.deleteAccount()).called(1);
  });

  test('should return [AuthUser] when getLoggedUser is called', () async {
    //Act
    final authUser = await authUserRepository.getLoggedUser();
    //Assert
    expect(authUser, isA<AuthUser>());
    expect(authUser.userId, authUserMock.userId);
  });

  test('should return true when a user is logged', () async {
    //Arrange
    when(() => firebaseAuthAdapterMock.isUserLoggedIn())
        .thenAnswer((_) async => true);
    //Act
    final isLogged = await authUserRepository.isUserLoggedIn();
    //Assert
    expect(isLogged, true);
  });

  test('should return false when a user is not logged', () async {
    //Arrange
    when(() => firebaseAuthAdapterMock.isUserLoggedIn())
        .thenAnswer((_) async => false);
    //Act
    final isLogged = await authUserRepository.isUserLoggedIn();
    //Assert
    expect(isLogged, false);
  });

  test('should return [AuthUser] when login is called', () async {
    //Act
    final authUser =
        await authUserRepository.login(email: 'email', password: 'password');
    //Assert
    expect(authUser, isA<AuthUser>());
    expect(authUser.userId, authUserMock.userId);
  });

  test('should return [AuthUser] when register is called', () async {
    //Act
    final authUser =
        await authUserRepository.register(email: 'email', password: 'password');
    //Assert
    expect(authUser, isA<AuthUser>());
    expect(authUser.userId, authUserMock.userId);
  });

  test('should call authAdapter.logout when logout is called', () async {
    //Arrange
    when(() => firebaseAuthAdapterMock.logout())
        .thenAnswer((invocation) async => Future.value(null));
    //Act
    await authUserRepository.logout();
    //Assert
    verify(() => firebaseAuthAdapterMock.logout()).called(1);
  });
}
