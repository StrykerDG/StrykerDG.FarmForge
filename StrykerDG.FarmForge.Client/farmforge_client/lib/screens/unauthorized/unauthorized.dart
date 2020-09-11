import 'package:flutter/material.dart';

class Unauthorized extends StatelessWidget {
  static const String id = 'unauthorized';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Unauthorized"),
      ),
    );
  }
}