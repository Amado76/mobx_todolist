import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx_todolist/store/auth_user_model.dart';

sealed class IAuthAdapter {
  Future<AuthUser> login({required String email, required String password});
  Future<void> logout();
  Future<bool> isUserLoggedIn();
  Future<AuthUser> getLoggedUser();
  Future<AuthUser> register({required String email, required String password});
  Future<void> deleteAccount();
  Future<void> reautenticateAUser(
      {required String email, required String password});
}

class FirebaseAuthAdapter implements IAuthAdapter {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthAdapter({required this.firebaseAuth});

  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    UserCredential userCredential = await firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    AuthUser authUser = await getAuthUserFromUser(userCredential.user!);
    return authUser;
  }

  @override
  Future<void> deleteAccount() async {
    await firebaseAuth.currentUser!.delete();
  }

  @override
  Future<AuthUser> getLoggedUser() async {
    AuthUser authUser;
    if (firebaseAuth.currentUser == null) {
      throw Exception('No user logged in');
    }
    User firebaseUser = firebaseAuth.currentUser!;
    authUser = await getAuthUserFromUser(firebaseUser);
    return authUser;
  }

  @override
  Future<bool> isUserLoggedIn() async {
    bool isUserLoggedIn = false;
    if (firebaseAuth.currentUser != null) {
      isUserLoggedIn = true;
    }
    return isUserLoggedIn;
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<void> reautenticateAUser(
      {required String email, required String password}) async {
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);
    await firebaseAuth.currentUser?.reauthenticateWithCredential(credential);
  }

  @override
  Future<AuthUser> register(
      {required String email, required String password}) async {
    await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    AuthUser authUser = await getLoggedUser();
    return authUser;
  }

  @visibleForTesting
  Future<AuthUser> getAuthUserFromUser(User user) async {
    AuthUser authUser;
    authUser = AuthUser(
        userId: user.uid,
        email: user.email ?? '',
        token: await user.getIdToken());
    return authUser;
  }
}
