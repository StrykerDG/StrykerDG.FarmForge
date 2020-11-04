import 'dart:html';

import 'package:farmforge_client/services/farmforge_api_service.dart';

class Settings {
  static String version = '0.2.0';

  static String developmentUrl = 'https://localhost:44310';
  static String testUrl = 'https://localhost:443';
  static String productionUrl = '';

  static setApiUrl() {
    var location = window.location.toString();
    if(location.contains('localhost:3000'))
      FarmForgeApiService.apiUrl = developmentUrl;
    else if(location.contains('localhost'))
      FarmForgeApiService.apiUrl = testUrl;
    else 
      FarmForgeApiService.apiUrl = productionUrl;
  }
}