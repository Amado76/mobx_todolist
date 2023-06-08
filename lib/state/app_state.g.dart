// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppState on _AppState, Store {
  Computed<ObservableList<ToDoStore>>? _$sortedReminderListComputed;

  @override
  ObservableList<ToDoStore> get sortedReminderList =>
      (_$sortedReminderListComputed ??= Computed<ObservableList<ToDoStore>>(
              () => super.sortedReminderList,
              name: '_AppState.sortedReminderList'))
          .value;

  late final _$currentScreenAtom =
      Atom(name: '_AppState.currentScreen', context: context);

  @override
  AppScreen get currentScreen {
    _$currentScreenAtom.reportRead();
    return super.currentScreen;
  }

  @override
  set currentScreen(AppScreen value) {
    _$currentScreenAtom.reportWrite(value, super.currentScreen, () {
      super.currentScreen = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_AppState.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$currentUserAtom =
      Atom(name: '_AppState.currentUser', context: context);

  @override
  AuthUser? get currentUser {
    _$currentUserAtom.reportRead();
    return super.currentUser;
  }

  @override
  set currentUser(AuthUser? value) {
    _$currentUserAtom.reportWrite(value, super.currentUser, () {
      super.currentUser = value;
    });
  }

  late final _$authErrorAtom =
      Atom(name: '_AppState.authError', context: context);

  @override
  AuthError? get authError {
    _$authErrorAtom.reportRead();
    return super.authError;
  }

  @override
  set authError(AuthError? value) {
    _$authErrorAtom.reportWrite(value, super.authError, () {
      super.authError = value;
    });
  }

  late final _$toDoListAtom =
      Atom(name: '_AppState.toDoList', context: context);

  @override
  ObservableList<ToDoStore> get toDoList {
    _$toDoListAtom.reportRead();
    return super.toDoList;
  }

  @override
  set toDoList(ObservableList<ToDoStore> value) {
    _$toDoListAtom.reportWrite(value, super.toDoList, () {
      super.toDoList = value;
    });
  }

  late final _$deleteAsyncAction =
      AsyncAction('_AppState.delete', context: context);

  @override
  Future<bool> delete(ToDoStore toDo) {
    return _$deleteAsyncAction.run(() => super.delete(toDo));
  }

  late final _$deleteAccountAsyncAction =
      AsyncAction('_AppState.deleteAccount', context: context);

  @override
  Future<bool> deleteAccount(String email, String password) {
    return _$deleteAccountAsyncAction
        .run(() => super.deleteAccount(email, password));
  }

  late final _$logoutAsyncAction =
      AsyncAction('_AppState.logout', context: context);

  @override
  Future<void> logout() {
    return _$logoutAsyncAction.run(() => super.logout());
  }

  late final _$createToDoAsyncAction =
      AsyncAction('_AppState.createToDo', context: context);

  @override
  Future<bool> createToDo({required String title, required String content}) {
    return _$createToDoAsyncAction
        .run(() => super.createToDo(title: title, content: content));
  }

  late final _$_AppStateActionController =
      ActionController(name: '_AppState', context: context);

  @override
  void goTo(AppScreen screen) {
    final _$actionInfo =
        _$_AppStateActionController.startAction(name: '_AppState.goTo');
    try {
      return super.goTo(screen);
    } finally {
      _$_AppStateActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currentScreen: ${currentScreen},
isLoading: ${isLoading},
currentUser: ${currentUser},
authError: ${authError},
toDoList: ${toDoList},
sortedReminderList: ${sortedReminderList}
    ''';
  }
}
