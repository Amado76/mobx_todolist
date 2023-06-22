import 'package:mobx_todolist/adapter/auth_adapter.dart';
import 'package:mobx_todolist/store/auth_user_model.dart';

sealed class IAuthUserRepository {
  final IAuthAdapter authAdapter;

  IAuthUserRepository({required this.authAdapter});
  Future<AuthUser> login({required String email, required String password});
  Future<void> logout();
  Future<bool> isUserLoggedIn();
  Future<AuthUser> getLoggedUser();
  Future<AuthUser> register({required String email, required String password});
  Future<void> deleteAccount({required String email, required String password});
}

class AuthUserRepository extends IAuthUserRepository {
  AuthUserRepository({required super.authAdapter});

  @override
  Future<void> deleteAccount(
      {required String email, required String password}) async {
    await authAdapter.reautenticateAUser(email: email, password: password);
    await authAdapter.deleteAccount();
  }

  @override
  Future<AuthUser> getLoggedUser() async {
    return await authAdapter.getLoggedUser();
  }

  @override
  Future<bool> isUserLoggedIn() async {
    return await authAdapter.isUserLoggedIn();
  }

  @override
  Future<AuthUser> login(
      {required String email, required String password}) async {
    return await authAdapter.login(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await authAdapter.logout();
  }

  @override
  Future<AuthUser> register(
      {required String email, required String password}) async {
    return await authAdapter.register(email: email, password: password);
  }
}
