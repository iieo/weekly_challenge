import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:weekly_challenge/components/dialog.dart';

import '../firebase/firebase_auth_handler.dart';
import 'authentication.dart';

class SignUpContainer extends StatefulWidget {
  const SignUpContainer({super.key});

  @override
  State<SignUpContainer> createState() => _SignUpContainer();
}

class _SignUpContainer extends State<SignUpContainer> {
  final double loginWidth = 300;

  final passwordController = TextEditingController();
  final checkPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final passwordValidator = GlobalKey<FormState>();

  bool loading = false;
  bool passwordsMatch = true;
  String infoText = '';

  void checkPasswordEquality(String value) {
    if (passwordController.text.compareTo(checkPasswordController.text) == 0) {
      setState(() {
        infoText = "";
      });
      passwordsMatch = true;
    } else {
      setState(() {
        infoText = "Passwords don't match";
      });
      passwordsMatch = false;
    }
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
                padding: const EdgeInsets.all(8.0),
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
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: passwordController,
                  style: Theme.of(context).textTheme.bodyMedium,
                  obscureText: true,
                  onChanged: checkPasswordEquality,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter your password'),
                ),
              )),
          SizedBox(
              width: loginWidth,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: checkPasswordController,
                  obscureText: true,
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: checkPasswordEquality,
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
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!passwordsMatch) {
                        showSimpleErrorDialog(context, "Passwords don't match!",
                            "Please try again");
                        return;
                      }
                      setState(() {
                        loading = true;
                      });
                      try {
                        await FirebaseAuthHandler.trySignup(
                            emailController.text,
                            emailController.text,
                            passwordController.text);
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          loading = false;
                        });
                        showSimpleErrorDialog(context, "Error signing up",
                            FirebaseAuthHandler.getFirebaseErrorText(e));
                      } catch (e) {
                        showSimpleErrorDialog(context, "Unkown Error.",
                            "Please try again or contact +49 176 82756321");
                      }
                    },
                    child: const Text('Sign up'),
                  ))),
          SizedBox(
              width: loginWidth,
              height: 40,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                      child: Text("Have an account? Log in.",
                          style: Theme.of(context).textTheme.titleSmall),
                      onTap: () {
                        GoRouter.of(context).go("/login");
                      }))),
          SizedBox(
              width: loginWidth,
              height: 40,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    infoText,
                    style: Theme.of(context).textTheme.bodySmall,
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
