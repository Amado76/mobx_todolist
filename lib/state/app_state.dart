import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx_todolist/adapter/auth_adapter.dart';
import 'package:mobx_todolist/adapter/remote_storage_adapter.dart';
import 'package:mobx_todolist/custom_extensions.dart';
import 'package:mobx_todolist/repository/auth_user_repository.dart';
import 'package:mobx_todolist/repository/to_do_repository.dart';
import 'package:mobx_todolist/store/auth_user_store.dart';
import 'package:mobx_todolist/store/to_do_store.dart';
import 'package:mobx_todolist/util/auth_error.dart';
import 'package:mobx_todolist/util/to_do_dto.dart';

part 'app_state.g.dart';

enum AppScreen { login, register, toDoList }

class AppState = _AppState with _$AppState;

abstract class _AppState with Store {
  final IAuthUserRepository authUserRepository = AuthUserRepository(
      authAdapter: FirebaseAuthAdapter(firebaseAuth: FirebaseAuth.instance));
  final IToDoRepository toDoRepository = ToDoRepository(
      remoteStorageAdapter:
          FirestorageAdapter(firestore: FirebaseFirestore.instance));

  @observable
  AppScreen currentScreen = AppScreen.login;

  @observable
  bool isLoading = false;

  @observable
  AuthUser? currentUser;

  @observable
  AuthError? authError;

  @observable
  ObservableList<ToDoStore> toDoList = ObservableList<ToDoStore>();

  @computed
  ObservableList<ToDoStore> get sortedReminderList =>
      toDoList.sorted().asObservable();

  @action
  void goTo(AppScreen screen) {
    currentScreen = screen;
  }

  @action
  Future<bool> delete(ToDoStore toDo) async {
    isLoading = true;

    bool isUserLogged = await authUserRepository.isUserLoggedIn();
    if (isUserLogged == false) {
      isLoading = false;
      return false;
    }

    AuthUser user = await authUserRepository.getLoggedUser();

    try {
      await toDoRepository.deleteDataFromRemoteStorage(
          userId: user.userId, toDo: toDo);
      toDoList.removeWhere(((element) => element.id == toDo.id));
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteAccount(String email, String password) async {
    isLoading = true;
    bool isUserLogged = await authUserRepository.isUserLoggedIn();
    if (isUserLogged == false) {
      isLoading = false;
      return false;
    }
    AuthUser user = await authUserRepository.getLoggedUser();

    try {
      await toDoRepository.deleteAllDataFromRemoteStorage(user.userId);
      await authUserRepository.deleteAccount(email: email, password: password);
      await authUserRepository.logout();
      currentScreen = AppScreen.login;
      return true;
    } on Exception catch (e) {
      authError = AuthError.from(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> logout() async {
    isLoading = true;
    await authUserRepository.logout();
    isLoading = false;
    currentScreen = AppScreen.login;
    toDoList.clear();
  }

  @action
  Future<bool> createToDo(
      {required String title, required String content}) async {
    isLoading = true;
    final userId = currentUser?.userId;
    if (userId == null) {
      isLoading = false;
      return false;
    }
    final creationDate = DateTime.now();
    ToDoDto toDoDto = ToDoDto(
        creationDate: creationDate,
        title: title,
        content: content,
        isDone: false);

    try {
      toDoRepository.addData(
          toDoDto: toDoDto, userId: userId, toDoList: toDoList);
      isLoading = false;
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
