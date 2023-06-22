// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobx/mobx.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobx_todolist/adapter/auth_adapter.dart';
import 'package:mobx_todolist/adapter/remote_storage_adapter.dart';
import 'package:mobx_todolist/custom_extensions.dart';
import 'package:mobx_todolist/repository/auth_user_repository.dart';
import 'package:mobx_todolist/repository/to_do_repository.dart';
import 'package:mobx_todolist/store/auth_user_model.dart';
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
  ObservableList<ToDoStore> get sortedToDoListList =>
      toDoList.sorted().asObservable();

  ({bool isLogged, String? userId}) isUserLogged() {
    if (currentUser == null) {
      return (isLogged: false, userId: null);
    }
    return (isLogged: true, userId: currentUser!.userId);
  }

  @action
  void goTo(AppScreen screen) {
    currentScreen = screen;
  }

  @action
  void resetAuthError() {
    authError = null;
  }

  @action
  Future<bool> delete(ToDoStore toDo) async {
    ({bool isLogged, String? userId}) userLogged = isUserLogged();
    if (!userLogged.isLogged) {
      return false;
    }
    isLoading = true;
    String userId = userLogged.userId!;
    try {
      await toDoRepository.deleteDataFromRemoteStorage(
          userId: userId, toDo: toDo);
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
    ({bool isLogged, String? userId}) userLogged = isUserLogged();
    if (!userLogged.isLogged) {
      return false;
    }
    isLoading = true;
    String userId = userLogged.userId!;

    try {
      await toDoRepository.deleteAllDataFromRemoteStorage(userId);
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
  Future<bool> login({required String email, required String password}) async {
    isLoading = true;
    resetAuthError();

    try {
      currentUser =
          await authUserRepository.login(email: email, password: password);
      await _loadToDoList();
      isLoading = false;
      currentScreen = AppScreen.toDoList;
      return true;
    } on Exception catch (e) {
      authError = AuthError.from(e);
      currentUser = null;

      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> registerUser(
      {required String email, required String password}) async {
    isLoading = true;
    resetAuthError();
    try {
      currentUser =
          await authUserRepository.register(email: email, password: password);
      await _loadToDoList();
      isLoading = false;
      currentScreen = AppScreen.toDoList;
      return true;
    } on Exception catch (e) {
      authError = AuthError.from(e);
      currentUser = null;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> createToDo(
      {required String title, required String content}) async {
    ({bool isLogged, String? userId}) userLogged = isUserLogged();
    if (!userLogged.isLogged) {
      resetAuthError();
      return false;
    }
    resetAuthError();
    isLoading = true;
    String userId = userLogged.userId!;
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

  @action
  Future<bool> modifyIsDone(ToDoStore toDo, {required bool isDone}) async {
    ({bool isLogged, String? userId}) userLogged = isUserLogged();
    if (!userLogged.isLogged) {
      resetAuthError();
      return false;
    }
    resetAuthError();
    isLoading = true;
    String userId = userLogged.userId!;

    try {
      await toDoRepository
          .updateData(toDo: toDo, userId: userId, data: {'isDone': isDone});
      toDoList.firstWhere((element) => element.id == toDo.id).isDone = isDone;
      isLoading = false;
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> modifyTitle(ToDoStore toDo, {required String title}) async {
    ({bool isLogged, String? userId}) userLogged = isUserLogged();
    if (!userLogged.isLogged) {
      resetAuthError();
      return false;
    }
    resetAuthError();
    isLoading = true;
    String userId = userLogged.userId!;

    try {
      await toDoRepository
          .updateData(toDo: toDo, userId: userId, data: {'title': title});
      toDoList.firstWhere((element) => element.id == toDo.id).title = title;
      isLoading = false;
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> modifyContent(ToDoStore toDo, {required String content}) async {
    ({bool isLogged, String? userId}) userLogged = isUserLogged();
    if (!userLogged.isLogged) {
      resetAuthError();
      return false;
    }
    resetAuthError();
    isLoading = true;
    String userId = userLogged.userId!;

    try {
      await toDoRepository
          .updateData(toDo: toDo, userId: userId, data: {'content': content});
      toDoList.firstWhere((element) => element.id == toDo.id).content = content;
      isLoading = false;
      return true;
    } on Exception catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> initialize() async {
    resetAuthError();
    isLoading = true;
    bool isUserLogged = await authUserRepository.isUserLoggedIn();
    if (!isUserLogged) {
      isLoading = false;
      currentScreen = AppScreen.login;
      currentUser = null;
      return;
    }
    currentUser = await authUserRepository.getLoggedUser();
    _loadToDoList();
    currentScreen = AppScreen.toDoList;
    isLoading = false;
  }

  @action
  Future<bool> _loadToDoList() async {
    resetAuthError();
    ({bool isLogged, String? userId}) userLogged = isUserLogged();
    if (!userLogged.isLogged) {
      return false;
    }
    String userId = userLogged.userId!;
    try {
      final toDoList = await toDoRepository.getAllCollection(userId);
      this.toDoList = ObservableList.of(toDoList);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
