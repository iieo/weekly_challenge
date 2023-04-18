import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';

class AuthScreen extends StatefulWidget {
  final double width;
  final double height;
  final Widget child;

  const AuthScreen(
      {super.key, required this.child, this.width = 400, this.height = 450});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<AuthScreen> createState() => _AuthScreen();
}

class _AuthScreen extends State<AuthScreen> {
  bool showLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.center,
            child: Material(
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: App.whiteColor,
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: App.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    width: widget.width,
                    height: widget.height,
                    child: Stack(alignment: Alignment.center, children: [
                      widget.child,
                      Builder(builder: (context) {
                        if (showLoading) {
                          return const LoadingScreen();
                        } else {
                          return const SizedBox.shrink();
                        }
                      })
                    ])))));
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
        child: Container(
            color: Colors.white.withOpacity(0.5),
            child: const Center(child: CircularProgressIndicator())));
  }
}
