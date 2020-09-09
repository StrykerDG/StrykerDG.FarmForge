import 'package:flutter/material.dart';

class FarmForgeDialog extends StatelessWidget {
  final String title;
  final Widget content;

  FarmForgeDialog({@required this.title, @required this.content});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(title),
            SizedBox(height: 16.0),
            content
          ],
        ),
      ),
    );
  }
}