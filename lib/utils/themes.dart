import 'package:flutter/material.dart';
import 'constants.dart';

final ThemeData wwDarkTheme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
      seedColor: appAccentColor, brightness: Brightness.dark),
  useMaterial3: true,
  buttonTheme: ButtonThemeData(
    buttonColor: appAccentColor,
    textTheme: ButtonTextTheme.primary,
  ),
);

final ThemeData wwLightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme.fromSeed(
      seedColor: appPrimaryColor, brightness: Brightness.light),
  useMaterial3: true,
  buttonTheme: ButtonThemeData(
    buttonColor: appPrimaryColor,
    textTheme: ButtonTextTheme.primary,
  ),
);

// final lightTheme = ThemeData(
//   primaryColor: appPrimaryColor,
//   accentColor: appAccentColor,
//   brightness: Brightness.light,
//   useMaterial3: true,
//   buttonTheme: ButtonThemeData(
//     buttonColor: appPrimaryColor,
//     textTheme: ButtonTextTheme.primary,
//   ),
// );
//
// final darkTheme = ThemeData(
//   primaryColor: appPrimaryColor,
//   accentColor: appAccentColor,
//   brightness: Brightness.dark,
//   useMaterial3: true,
//   buttonTheme: ButtonThemeData(
//     buttonColor: appPrimaryColor,
//     textTheme: ButtonTextTheme.primary,
//   ),
// );
