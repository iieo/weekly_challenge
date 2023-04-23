import 'package:flutter/material.dart';

const Color backgroundDark = Color.fromARGB(255, 11, 25, 46);
const Color backgroundDarkBrighter = Color.fromARGB(255, 24, 43, 69);

const Color primaryColor = Color.fromARGB(255, 12, 201, 169);
const Color primaryColorBrighter = Color.fromARGB(255, 24, 43, 69);

const Color secondaryColor = Color.fromARGB(255, 12, 201, 171);
const Color secondaryColorDarker = Color.fromARGB(255, 11, 51, 65);

const Color whiteColor = Color.fromARGB(255, 205, 215, 245);
const Color whiteColorDarker = Color.fromARGB(255, 144, 150, 172);

ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: primaryColorBrighter,
  brightness: Brightness.dark,
  primary: primaryColor,
  secondary: secondaryColor,
  background: backgroundDark,
  primaryContainer: primaryColorBrighter,
  error: Colors.red,
  onPrimary: whiteColor,
  onBackground: whiteColor,
  onError: Colors.white,
);

/*const Color backgroundDark = Color.fromARGB(255, 20, 36, 62);
const Color backgroundDarkBrighter = Color.fromARGB(255, 35, 63, 108);

const Color primaryColor = Color.fromARGB(255, 39, 103, 68);
const Color primaryColorBrighter = Color.fromARGB(255, 61, 164, 109);

const Color secondaryColor = Color.fromARGB(255, 141, 93, 208);
const Color secondaryColorDarker = Color.fromARGB(255, 121, 65, 200);

const Color ternaryColor = Color.fromARGB(255, 50, 62, 153);
const Color ternaryColorDarker = Color.fromARGB(255, 40, 50, 123);

const Color fourthColor = Color.fromARGB(255, 24, 62, 75);
const Color fourthColorDarker = Color.fromARGB(255, 20, 51, 62);

const Color whiteColor = Color.fromARGB(255, 205, 215, 245);
const Color whiteColorDarker = Color.fromARGB(255, 144, 150, 172);

ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    secondary: secondaryColor,
    tertiary: ternaryColor,
    brightness: Brightness.dark,
    background: fourthColor);*/

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
    scaffoldBackgroundColor: backgroundDark,
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
      bodyMedium: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          color: whiteColorDarker),
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
