import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String username;

  void setUsername(String user) {
    username = user;
    notifyListeners();
  }
}