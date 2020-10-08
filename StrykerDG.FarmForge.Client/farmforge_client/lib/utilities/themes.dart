import 'package:flutter/material.dart';

import 'constants.dart';

ThemeData primaryTheme = ThemeData(
  primaryColor: kPrimaryColor,
  primaryColorLight: kPrimaryLightColor,
  primaryColorDark: kPrimaryDarkColor,
  accentColor: kSecondaryColor,
  buttonColor: kSecondaryColor,

  textTheme: TextTheme(
    headline5: TextStyle(
      fontWeight: FontWeight.bold
    ),
    headline6: TextStyle(
      fontWeight: FontWeight.bold
    ),
  )
);

ThemeData lightTheme = ThemeData.light().copyWith();

ThemeData darkTheme = ThemeData.dark().copyWith();