import 'package:flutter/material.dart';
import 'package:mobx_todolist/state/app_state.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          appBar: AppBar(
              title: const Text(
                'Login',
              ),
              centerTitle: true),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Image.asset(
                    'assets/images/todoimage.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 300,
                            height: 42,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                              ),
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 300,
                            height: 42,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: 'Enter your password',
                              ),
                              obscureText: true,
                              controller: passwordController,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: 300,
                            height: 42,
                            child: OutlinedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AppState>().login(
                                          email: emailController.text,
                                          password: passwordController.text,
                                        );
                                  }
                                },
                                child: const Text('Login')),
                          )
                        ],
                      )),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        context.read<AppState>().goTo(AppScreen.register);
                      },
                      child: const Text('Not registered yet? Register here'))
                ],
              )),
            ),
          )),
    );
  }
}
