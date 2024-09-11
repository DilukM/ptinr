import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
  ),
  brightness: Brightness.light,
  fontFamily: "Nunito",
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Colors.grey.shade200,
    secondary: Colors.grey.shade300,
    shadow: const Color.fromARGB(145, 117, 117, 117),
    tertiary: Color.fromARGB(255, 41, 41, 41),
    error: Color.fromARGB(255, 4, 57, 39),
  ),
  useMaterial3: true,
);

ThemeData darkMode = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey.shade900,
    ),
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Colors.grey.shade800,
      secondary: Colors.grey.shade600,
      shadow: Color.fromARGB(50, 0, 0, 0),
      tertiary: Colors.grey.shade400,
      error: Color.fromARGB(255, 102, 183, 117),
    ));
