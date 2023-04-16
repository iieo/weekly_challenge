import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../backend/firebase_handler.dart';
import 'authentication.dart';

class SingUpContainer extends StatefulWidget {
  SingUpContainer({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  @override
  State<SingUpContainer> createState() => _SingUpContainer();
}

class _SingUpContainer extends State<SingUpContainer> {
  final double loginWidth = 300;

  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordValidator = GlobalKey<FormState>();

  bool loading = false;
  bool passwordsMatch = false;
  String infoText = '';

  void UpdateLoading(bool isLoading) {
    setState(() {
      loading = isLoading;
    });
  }

  void UpdateInfoText(String text) {
    setState(() {
      infoText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: loginWidth,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  key: passwordValidator,
                  controller: emailController,
                  decoration: const InputDecoration(
                      hoverColor: Colors.black,
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter valid mail.'),
                ),
              )),
          SizedBox(
              width: loginWidth,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your password'),
                ),
              )),
          SizedBox(
              width: loginWidth,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: checkPasswordController,
                  obscureText: true,
                  onChanged: (value) {
                    if (value != passwordController.text) {
                      UpdateInfoText("Passwords don't match");
                      passwordsMatch = false;
                    } else {
                      passwordsMatch = true;
                      UpdateInfoText("");
                    }
                  },
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Repeat Password',
                      hintText: 'Repeat your password'),
                ),
              )),
          SizedBox(
              width: loginWidth,
              height: 65,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!passwordsMatch) {
                        return;
                      }
                      UpdateLoading(true);
                      TrySignup(emailController.text, passwordController.text)
                          .then((value) {
                        UpdateInfoText('');
                        UpdateLoading(false);

                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                    "Account was created successfully!"),
                                content: const Text("Press Ok to login."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      context.go('/authentication/login');
                                    },
                                    child: const Text("Ok"),
                                  )
                                ],
                              );
                            });
                      }).timeout(const Duration(seconds: 5), onTimeout: () {
                        UpdateInfoText("Connection timed out.");
                        UpdateLoading(false);
                      }).onError((error, stackTrace) {
                        if (error is FirebaseAuthException) {
                          UpdateInfoText(GetFirebaseErrorText(error));
                        } else {
                          UpdateInfoText("Unkown Error.");
                        }
                        UpdateLoading(false);
                      });
                    },
                    child: const Text('Sign up'),
                  ))),
          SizedBox(
              width: loginWidth,
              height: 40,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: InkWell(
                      child: const Text("Have an account? Log in.",
                          style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        context.go("/authentication/login");
                      }))),
          SizedBox(
              width: loginWidth,
              height: 40,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    infoText,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  )))
        ],
      ),
      Builder(builder: (context) {
        if (loading) {
          return const LoadingScreen();
        } else {
          return const SizedBox.shrink();
        }
      })
    ]);
  }
}
