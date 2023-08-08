import 'package:flutter/material.dart';

Color primary = Color(0xFF5D2C7D);

ThemeData dark = ThemeData(
  fontFamily: 'Roboto',
  primaryColor: primary,
  secondaryHeaderColor: primary,
  disabledColor: Color(0xffa2a7ad),
  backgroundColor: Color(0xFF343636),
  errorColor: Color(0xFFdd3135),
  brightness: Brightness.dark,
  hintColor: Color(0xFFbebebe),
  cardColor: Colors.black,
  colorScheme: ColorScheme.dark(primary: primary, secondary: primary),
  textButtonTheme:
      TextButtonThemeData(style: TextButton.styleFrom(primary: primary)),
);
