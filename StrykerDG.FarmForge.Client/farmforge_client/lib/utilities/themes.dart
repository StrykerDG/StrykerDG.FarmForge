import 'package:flutter/material.dart';

import 'constants.dart';
import 'constants.dart';
import 'constants.dart';

ThemeData primaryTheme = ThemeData(
  primaryColor: kPrimaryColor,
  primaryColorLight: kPrimaryLightColor,
  primaryColorDark: kPrimaryDarkColor,
  accentColor: kSecondaryColor,
  buttonColor: kSecondaryColor
);

ThemeData lightTheme = ThemeData.light().copyWith();

ThemeData darkTheme = ThemeData.dark().copyWith();