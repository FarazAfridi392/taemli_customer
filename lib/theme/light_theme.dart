import 'package:flutter/material.dart';

Color primary = Color(0xFF5D2C7D);

ThemeData light = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: primary,
  secondaryHeaderColor: primary,
  disabledColor: Colors.black,
  backgroundColor: Color(0xFFF3F3F3),
  errorColor: Color(0xFFE84D4F),
  brightness: Brightness.light,
  hintColor: Color(0xFF9F9F9F),
  cardColor: Colors.white,
  colorScheme: ColorScheme.light(primary: primary, secondary: primary),
  textButtonTheme:
      TextButtonThemeData(style: TextButton.styleFrom(primary: primary)),
);
