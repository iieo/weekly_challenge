import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';

final ThemeData themeData = ThemeData(
    //disable toom effect
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: NoPageTransitionBuilder(),
        TargetPlatform.iOS: NoPageTransitionBuilder(),
        TargetPlatform.fuchsia: NoPageTransitionBuilder(),
        TargetPlatform.linux: NoPageTransitionBuilder(),
        TargetPlatform.macOS: NoPageTransitionBuilder(),
        TargetPlatform.windows: NoPageTransitionBuilder(),
      },
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primarySwatch: const MaterialColor(0xFFFEFAE0, {
      50: Color(0xfff2f2f2),
      100: Color(0xffe6e6e6),
      200: Color(0xffcccccc),
      300: Color(0xffb3b3b3),
      400: Color(0xff999999),
      500: Color(0xff808080),
      600: Color(0xff666666),
      700: Color(0xff4d4d4d),
      800: Color(0xff333333),
      900: Color(0xff1a1a1a)
    }),
    primaryColor: App.primaryColor,
    textTheme: const TextTheme(
      labelSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        color: App.primaryColor,
      ),
      labelMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        color: App.primaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        color: App.primaryColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
        color: App.primaryColor,
      ),
    ));

class NoPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}
