import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';

const Color backgroundDark = Color.fromARGB(255, 11, 25, 46);
const Color backgroundDarkBrighter = Color.fromARGB(255, 24, 43, 69);

const Color primaryColor = Color.fromARGB(255, 11, 25, 46);
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
Color primaryColor2 = const Color.fromARGB(255, 60, 194, 143);
ColorScheme colorScheme2 = ColorScheme.fromSeed(
  seedColor: primaryColor2,
  //const Color.fromARGB(255, 187, 134, 252),
  brightness: Brightness.dark,
  primary: primaryColor2,
  //const Color.fromARGB(255, 187, 134, 252),
  secondary: primaryColor2,
  background: const Color.fromARGB(255, 18, 18, 18),
  primaryContainer: const Color.fromARGB(255, 30, 30, 30),
  surface: const Color.fromARGB(255, 30, 30, 30),
  error: const Color.fromARGB(255, 207, 102, 121),
  onPrimary: Colors.white,
  onBackground: Colors.white,
  onSurface: Colors.white,
  onError: Colors.black,
);

final ThemeData themeData2 = ThemeData(
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(App.defaultRadius),
          ),
        ),
      ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: colorScheme2,
    textTheme: textTheme);

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
    colorScheme: colorScheme2,
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
            borderRadius: BorderRadius.circular(App.defaultRadius),
          ),
        ),
      ),
    ),
    textTheme: textTheme);

TextTheme textTheme = const TextTheme(
  titleSmall: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
    color: Color.fromARGB(200, 255, 255, 255),
  ),
  titleMedium: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
    color: Color.fromARGB(225, 255, 255, 255),
  ),
  titleLarge: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
    color: Color.fromARGB(255, 255, 255, 255),
  ),
  labelSmall: TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    color: Color.fromARGB(200, 255, 255, 255),
  ),
  labelMedium: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    color: Color.fromARGB(225, 255, 255, 255),
  ),
  labelLarge: TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.none,
    color: Color.fromARGB(255, 255, 255, 255),
  ),
  bodyMedium: TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    decoration: TextDecoration.none,
    color: Color.fromARGB(225, 255, 255, 255),
  ),
);

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
