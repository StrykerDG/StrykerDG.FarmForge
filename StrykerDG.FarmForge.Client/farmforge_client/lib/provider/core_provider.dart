import 'package:flutter/material.dart';

import 'package:farmforge_client/services/farmforge_api_service.dart';

import '../utilities/themes.dart';

enum ThemeType {
  Primary,
  Light,
  Dark
}

class CoreProvider extends ChangeNotifier {
  FarmForgeApiService farmForgeService = FarmForgeApiService();
  ThemeData currentTheme = primaryTheme;

  void toggleTheme(ThemeType type) {
    if(type == ThemeType.Primary)
      currentTheme = primaryTheme;
    if(type == ThemeType.Light)
      currentTheme = lightTheme;
    if(type == ThemeType.Dark)
      currentTheme = darkTheme;
  }
}