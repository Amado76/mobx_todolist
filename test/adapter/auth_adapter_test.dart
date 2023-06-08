import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobx_todolist/adapter/auth_adapter.dart';
import 'package:mobx_todolist/store/auth_user_store.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/auth_user_mock.dart';
import '../mocks/firebase_auth_mock.dart';

void main() async {
  final FirebaseAuth firebaseAuthMock = FirebaseAuthMock();
  final FirebaseAuthAdapter firebaseAuthAdapter =
      FirebaseAuthAdapter(firebaseAuth: firebaseAuthMock);
  final authUserMock = AuthUserMock();
  final userMock = UserMock();

  group('[FirebaseAuthAdapter]', () {
    test('should return an AuthUser when [login] is called', () async {
      //Assert
      when(() => firebaseAuthMock.signInWithEmailAndPassword(
              email: 'email', password: 'password'))
          .thenAnswer((invocation) async => UserCredentialMock());
      //Act
      final authUser =
          await firebaseAuthAdapter.login(email: 'email', password: 'password');
      //Assert
      expect(authUser, isA<AuthUser>());
      expect(authUser.userId, authUserMock.userId);
    });

    test('should\'t trown an exception when [deleteAccount] is called',
        () async {
      //Assert
      when(() => firebaseAuthMock.currentUser!).thenReturn(userMock);
      when(() => userMock.delete()).thenAnswer((_) => Future.value());
      //Act
      await firebaseAuthAdapter.deleteAccount();
      //Assert
      verify(() => userMock.delete()).called(1);
    });

    group('[getLoggedUser]', () {
      test('should return [AuthUser] when user is logged', () async {
        //Arrange
        when(() => firebaseAuthMock.currentUser!).thenReturn(userMock);
        //Act
        final authUser = await firebaseAuthAdapter.getLoggedUser();
        //Assert
        expect(authUser, isA<AuthUser>());
        expect(authUser.userId, authUserMock.userId);
      });
      test(
          'should return [Exception No user loged] in when [getLoggedUser] is called and no user is logged',
          () {
        //Arrange
        when(() => firebaseAuthMock.currentUser).thenReturn(null);
        //Act
        final call = firebaseAuthAdapter.getLoggedUser();
        //Assert
        expect(call, throwsException);
      });
    });
    group('[isUserLoggedIn]', () {
      test(
          'should return [true], when the user is [logged]',
          () => {
                //Assert
                when(() => firebaseAuthMock.currentUser).thenReturn(userMock),
                //Act
                firebaseAuthAdapter.isUserLoggedIn().then((value) {
                  //Assert
                  expect(value, true);
                })
              });
      test(
          'should return [false], when the user is not [logged]',
          () => {
                //Assert
                when(() => firebaseAuthMock.currentUser).thenReturn(null),
                //Act
                firebaseAuthAdapter.isUserLoggedIn().then((value) {
                  //Assert
                  expect(value, false);
                })
              });
    });

    test('should call firebaseAuth.signOut when [logout] is called', () {
      //Arrange
      when(() => firebaseAuthMock.signOut()).thenAnswer((_) => Future.value());
      //Act
      firebaseAuthAdapter.logout();
      //Assert
      verify(() => firebaseAuthMock.signOut()).called(1);
    });

    test(
        'should call firebaseAuth.currentUser?.reauthenticateWithCredential when [reautenticateAUser] is called',
        () {
      //Arrange
      registerFallbackValue(AuthCredentialMock());
      when(() => firebaseAuthMock.currentUser).thenReturn(userMock);

      when(() => userMock.reauthenticateWithCredential(any()))
          .thenAnswer((_) async => UserCredentialMock());
      //Act
      firebaseAuthAdapter.reautenticateAUser(
          email: 'email', password: 'password');
      //Assert
      verify(() => userMock.reauthenticateWithCredential(any())).called(1);
    });

    test('shoudl return [AuthUser] when a user is [register]', () async {
      //Arrange
      when(() => firebaseAuthMock.createUserWithEmailAndPassword(
          email: 'email',
          password: 'password')).thenAnswer((_) async => UserCredentialMock());
      when(() => firebaseAuthMock.currentUser).thenReturn(userMock);
      //Act
      final authUser = await firebaseAuthAdapter.register(
          email: 'email', password: 'password');
      //Assert
      expect(authUser, isA<AuthUser>());
    });

    test('[getAuthUserFromUser] should return a [AuthUser] from a [User]',
        () async {
      //Act
      final authUser = await firebaseAuthAdapter.getAuthUserFromUser(userMock);
      //Assert
      expect(authUser, isA<AuthUser>());
    });
  });
}
