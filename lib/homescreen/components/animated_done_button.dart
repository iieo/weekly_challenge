import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/main.dart';

class AnimatedDoneButton extends StatefulWidget {
  final Function() onDone;
  final Function() onUndo;

  const AnimatedDoneButton(
      {super.key, required this.onDone, required this.onUndo});

  @override
  State<AnimatedDoneButton> createState() => _AnimatedDoneButtonState();
}

class _AnimatedDoneButtonState extends State<AnimatedDoneButton>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;
  late AnimationController _controller;
  late Animation _shrinkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 0.0,
    );
    _shrinkAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.15, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed() {
    if (!_controller.isCompleted) {
      _controller.forward();
      widget.onDone();
    }
  }

  void _onPressedLottie() {
    if (_controller.isCompleted) {
      _controller.reverse();
      widget.onUndo();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool? isDoneForToday = context.watch<FirestoreHandler>().isDoneForToday;
    if (isDoneForToday == null) {
      return const CircularProgressIndicator();
    }
    if (isDoneForToday && isLoading) {
      _controller.value = 1.0;
      isLoading = false;
    }

    final double size = min(250, MediaQuery.of(context).size.width * 0.5);
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
            height: size,
            width: size,
            child: GestureDetector(
                onTap: _onPressedLottie,
                child: Lottie.asset(
                  'assets/animations/done.json',
                  repeat: false,
                  fit: BoxFit.fill,
                  controller: _controller,
                  onLoaded: (composition) {
                    _controller.duration = composition.duration;
                    _controller.reverseDuration = Duration(
                        milliseconds:
                            (composition.duration.inMilliseconds / 3).round());
                  },
                ))),
        AnimatedBuilder(
            animation: _shrinkAnimation,
            builder: (context, child) {
              return Transform.scale(
                  scale: _shrinkAnimation.value,
                  child: Opacity(
                      opacity: _shrinkAnimation.value,
                      child: Button(
                        onPressed: _onPressed,
                        text: "Erledigt?",
                        backgroundColor: App.secondaryColor,
                        foregorundColor: Colors.white,
                      )));
            })
      ],
    );
  }
}
