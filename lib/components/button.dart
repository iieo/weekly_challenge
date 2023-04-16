import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';

class Button extends StatelessWidget {
  final Color? foregorundColor;
  final Color? backgroundColor;
  final Function() onPressed;
  final String? text;
  final double borderRadius;
  final Icon? icon;

  const Button({
    super.key,
    this.text,
    this.icon,
    required this.onPressed,
    this.foregorundColor,
    this.backgroundColor,
    this.borderRadius = 10,
  });

  Widget _buildChild() {
    if (text != null) {
      return Text(text!);
    } else if (icon != null) {
      return icon!;
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: foregorundColor ?? Colors.black,
            backgroundColor: backgroundColor ?? App.secondaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            ),
          ),
          onPressed: onPressed,
          child: _buildChild(),
        ));
  }
}
