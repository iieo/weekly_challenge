import 'package:flutter/material.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/main.dart';

class AnimatedCheckButton extends StatefulWidget {
  const AnimatedCheckButton({super.key});

  @override
  State<AnimatedCheckButton> createState() => _AnimatedCheckButtonState();
}

class _AnimatedCheckButtonState extends State<AnimatedCheckButton>
    with TickerProviderStateMixin {
  late AnimationController _controllerCheck;
  late AnimationController _controllerUncheck;
  late Animation<double> _animationCheck;
  late Animation<double> _animationUncheck;

  @override
  void initState() {
    super.initState();
    _controllerCheck = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _controllerUncheck = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _animationCheck = Tween<double>(begin: 1, end: 0).animate(_controllerCheck);
    _animationUncheck =
        Tween<double>(begin: 0, end: 1).animate(_controllerUncheck);
  }

  @override
  void dispose() {
    _controllerCheck.dispose();
    _controllerUncheck.dispose();
    super.dispose();
  }

  void _onPressed() async {
    if (_controllerCheck.isAnimating || _controllerUncheck.isAnimating) {
      return;
    }
    if (_controllerCheck.isCompleted && _controllerUncheck.isCompleted) {
      _controllerUncheck.reverse();
      await Future.delayed(const Duration(milliseconds: 250));
      _controllerCheck.reverse();
    } else {
      _controllerCheck.reverse();
      await Future.delayed(const Duration(milliseconds: 250));
      _controllerUncheck.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: AnimatedBuilder(
          animation: _animationCheck,
          builder: (context, child) {
            return Transform.scale(
                scale: _animationCheck.value,
                child: Button(
                    onPressed: _onPressed,
                    backgroundColor: App.primaryColor,
                    foregorundColor: App.primaryColorBrighter,
                    borderRadius: 10,
                    child: const Icon(Icons.check, color: Colors.white)));
          }),
    );
  }
}
