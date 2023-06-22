import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mobx_todolist/firebase_options.dart';
import 'package:mobx_todolist/page/login_page.dart';
import 'package:mobx_todolist/page/register_page.dart';
import 'package:mobx_todolist/page/to_do_list_page.dart';
import 'package:mobx_todolist/state/app_state.dart';
import 'package:mobx_todolist/util/auth_error.dart';
import 'package:mobx_todolist/widgets/dialogs/auth_error.dart';
import 'package:mobx_todolist/widgets/loading/loading_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => AppState(),
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: ReactionBuilder(
          builder: (context) {
            return autorun((_) {
              final isLoading = context.read<AppState>().isLoading;
              if (isLoading) {
                LoadingScreen.instance()
                    .show(context: context, text: 'Loading');
              } else {
                LoadingScreen.instance().hide();
              }
              AuthError? authError = context.read<AppState>().authError;
              if (authError != null) {
                showAuthError(authError: authError, context: context);
                context.watch<AppState>().resetAuthError();
                authError = context.read<AppState>().authError;
              }
            });
          },
          child: Observer(builder: (context) {
            switch (context.read<AppState>().currentScreen) {
              case AppScreen.register:
                return const RegisterPage();
              case AppScreen.toDoList:
                return const ToDoListPage();
              default:
                return const LoginPage();
            }
          }),
        ),
      ),
    );
  }
}
