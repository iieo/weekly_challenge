import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/components/dialog.dart';

import '../firebase/firebase_auth_handler.dart';
import 'authentication.dart';

class LoginContainer extends StatefulWidget {
  const LoginContainer({super.key});

  @override
  State<LoginContainer> createState() => _LoginContainer();
}

class _LoginContainer extends State<LoginContainer> {
  final double loginWidth = 300;

  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordValidator = GlobalKey<FormState>();

  bool loading = false;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void onEmailVerified(BuildContext context) {
    GoRouter.of(context).go('/');
  }

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser != null) {
      emailController.text = FirebaseAuth.instance.currentUser!.email!;
    }
  }

  void UpdateLoading(bool isLoading) {
    setState(() {
      loading = isLoading;
    });
  }

  Future<bool> ShowEmailNotVerifiedDialog(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return false;
    }

    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Email not verified"),
            content: Text(
                'Please verify your email before logging in. Email was sent to ${FirebaseAuth.instance.currentUser!.email}'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Dismiss",
                      style: Theme.of(context).textTheme.labelMedium)),
              TextButton(
                  onPressed: () {
                    FirebaseAuthHandler.resendVerificationEmail();
                  },
                  child: Text("Send again",
                      style: Theme.of(context).textTheme.labelMedium))
            ],
          );
        });

    return true;
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
                  style: Theme.of(context).textTheme.bodyMedium,
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
                  style: Theme.of(context).textTheme.bodyMedium,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your password'),
                ),
              )),
          Container(
              width: loginWidth,
              height: 65,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      UpdateLoading(true);
                      FirebaseAuthHandler.tryReload();
                      FirebaseAuthHandler.tryLogin(
                              emailController.text, passwordController.text)
                          .then((value) {
                        FirebaseAuth.instance.currentUser!.reload();
                        if (FirebaseAuth.instance.currentUser!.emailVerified) {
                          GoRouter.of(context).go('/');
                        } else {
                          ShowEmailNotVerifiedDialog(context);
                        }
                        UpdateLoading(false);
                      }).onError((error, stackTrace) {
                        print(error);
                        print(stackTrace);
                        UpdateLoading(false);
                        if (error is FirebaseAuthException) {
                          showSimpleErrorDialog(context,
                              FirebaseAuthHandler.getFirebaseErrorText(error));
                        } else if (error is EmailNotVerifiedException) {
                          ShowEmailNotVerifiedDialog(context);
                        } else {
                          showSimpleErrorDialog(context, "Unkown Error.");
                        }
                      });
                    },
                    child: const Text('Login'),
                  ))),
          SizedBox(
              width: loginWidth,
              height: 40,
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            child: Text("Forgot Password?",
                                style: Theme.of(context).textTheme.titleSmall),
                            onTap: () {
                              UpdateLoading(true);
                              FirebaseAuthHandler.forgotPassword(
                                      emailController.text)
                                  .then((value) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Password reset"),
                                        content: Text(
                                            'Email was sent to ${emailController.text}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("Ok"),
                                          )
                                        ],
                                      );
                                    });
                                UpdateLoading(false);
                              }).onError((error, stackTrace) {
                                UpdateLoading(false);
                                if (error is FirebaseAuthException) {
                                  showSimpleErrorDialog(
                                      context,
                                      FirebaseAuthHandler.getFirebaseErrorText(
                                          error));
                                } else {
                                  showSimpleErrorDialog(
                                      context, "Unkown Error.");
                                }
                              });
                            }),
                        InkWell(
                            child: Text("Create User Account.",
                                style: Theme.of(context).textTheme.titleSmall),
                            onTap: () {
                              FirebaseAuthHandler.logout();
                              GoRouter.of(context).go("/signup");
                            })
                      ]))),
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
