import 'package:flutter/material.dart';

import 'colors.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  backgroundColor: snow,
  scaffoldBackgroundColor: backgroundColor,
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(backgroundColor: white),
  appBarTheme: const AppBarTheme(
    // ignore: deprecated_member_use
    brightness: Brightness.light,
    color: backgroundColor,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
ThemeData darkMode = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.dark,
  backgroundColor: grey1100,
  scaffoldBackgroundColor: grey1100,
  bottomNavigationBarTheme:
      const BottomNavigationBarThemeData(backgroundColor: grey1000),
  appBarTheme: const AppBarTheme(
    // ignore: deprecated_member_use
    brightness: Brightness.dark,
    color: grey1100,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);
