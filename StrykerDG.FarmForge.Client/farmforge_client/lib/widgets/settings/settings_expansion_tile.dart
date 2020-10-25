import 'package:flutter/material.dart';

import 'package:farmforge_client/utilities/constants.dart';

class SettingsExpansionTile extends StatelessWidget {
  final String title;
  final Widget content;

  SettingsExpansionTile({@required this.title, @required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(kSmallPadding),
      child: Card(
        child: ExpansionTile(
          title: Text(title),
          children: [
            content
          ]
        ),
      ),
    );
  }
}