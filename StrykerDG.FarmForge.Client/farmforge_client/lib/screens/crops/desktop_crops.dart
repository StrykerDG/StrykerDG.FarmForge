import 'package:flutter/material.dart';

import 'package:farmforge_client/screens/base/desktop/base_desktop.dart';

class DesktopCrops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseDesktop(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search bar
          Row(
            children: [
              // Search box
              Container(
                width: 100,
                child: TextField(),
              ),
              // Filter button
              GestureDetector(
                child: Icon(Icons.filter_list),
                onTap: () {},
              ),
              Expanded(
                child: Container(),
              ),
              GestureDetector(
                child: Icon(Icons.calendar_today),
                onTap: () {},
              )
            ],
          ),
          // Listview
          Center(
            child: Text("List goes here"),
          )
        ],
      )
    );
  }
}