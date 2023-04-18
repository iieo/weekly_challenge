import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 11, 25, 46);
const Color primaryColorBrighter = Color.fromARGB(255, 24, 43, 69);
const Color whiteColor = Color.fromARGB(255, 205, 215, 245);
const Color whiteColorDarker = Color.fromARGB(255, 144, 150, 172);
const Color secondaryColor = Color.fromARGB(255, 12, 201, 171);
const Color secondaryColorDarker = Color.fromARGB(255, 11, 51, 65);

const ColorScheme colorScheme = ColorScheme(
  primary: primaryColorBrighter,
  secondary: secondaryColor,
  surface: primaryColorBrighter,
  background: primaryColor,
  error: Colors.red,
  onPrimary: whiteColor,
  onSecondary: whiteColor,
  onSurface: whiteColor,
  onBackground: whiteColor,
  onError: Colors.white,
  brightness: Brightness.dark,
);

final ThemeData themeData = ThemeData(
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
    primaryColor: primaryColor,
    colorScheme: colorScheme,
    appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor, foregroundColor: whiteColor),
    scaffoldBackgroundColor: primaryColor,
    dialogBackgroundColor: primaryColorBrighter,
    cardColor: primaryColorBrighter,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        color: whiteColorDarker,
      ),
      titleMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        color: whiteColor,
      ),
      titleLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.normal,
        decoration: TextDecoration.none,
        color: whiteColor,
      ),
      labelSmall: TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
        color: Colors.white,
      ),
      labelMedium: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        decoration: TextDecoration.none,
        color: Colors.white,
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
