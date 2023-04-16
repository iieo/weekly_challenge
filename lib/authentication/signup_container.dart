import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:weekly_challenge/main.dart';

import '../backend/firebase_handler.dart';
import 'authentication.dart';

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({super.key});

  @override
  State<SignUpContainer> createState() => _SignUpContainer();
}

class _SignUpContainer extends State<SignUpContainer> {
  final double loginWidth = 300;

  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordValidator = GlobalKey<FormState>();

  bool loading = false;
  bool passwordsMatch = false;
  String infoText = '';

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: loginWidth,
              child: Padding(
                padding: App.defaultPadding,
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hoverColor: Colors.black,
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                      hintText: 'Enter valid name.'),
                ),
              )),
          SizedBox(
              width: loginWidth,
              child: Padding(
                padding: App.defaultPadding,
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
                padding: App.defaultPadding,
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
                padding: App.defaultPadding,
                child: TextField(
                  controller: checkPasswordController,
                  obscureText: true,
                  onChanged: (value) {
                    if (value != passwordController.text) {
                      setState(() {
                        infoText = "Passwords don't match";
                      });
                      passwordsMatch = false;
                    } else {
                      passwordsMatch = true;
                      setState(() {
                        infoText = "";
                      });
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
                  padding: App.defaultPadding,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!passwordsMatch) {
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      FirebaseHandler.trySignup(nameController.text,
                              emailController.text, passwordController.text)
                          .then((value) {
                        setState(() {
                          loading = false;
                          infoText = "";
                        });

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
                        setState(() {
                          loading = false;
                          infoText = "Connection timed out.";
                        });
                      }).onError((error, stackTrace) {
                        if (error is FirebaseAuthException) {
                          setState(() {
                            infoText =
                                FirebaseHandler.getFirebaseErrorText(error);
                            loading = false;
                          });
                        } else {
                          setState(() {
                            infoText = "Unknown error occured.";
                            loading = false;
                          });
                        }
                      });
                    },
                    child: const Text('Sign up'),
                  ))),
          SizedBox(
              width: loginWidth,
              height: 40,
              child: Padding(
                  padding: App.defaultPadding,
                  child: InkWell(
                      child: const Text("Have an account? Log in.",
                          style: TextStyle(color: Colors.blue)),
                      onTap: () {
                        GoRouter.of(context).go("/login");
                      }))),
          SizedBox(
              width: loginWidth,
              height: 40,
              child: Padding(
                  padding: App.defaultPadding,
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
