import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';

import 'package:farmforge_client/widgets/farmforge/farmforge_drawer.dart';

class SmallFarmForge extends StatelessWidget {
  void handleNavigation(
    BuildContext context,
    Widget content, 
    String title,
    IconData icon, 
    Function action
  ) {
    Provider.of<CoreProvider>(context, listen: false)
      .setAppContent(content, title, icon, action);
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Provider.of<CoreProvider>(context).appContent;
    IconData icon = Provider.of<CoreProvider>(context).fabIcon;
    Function action = Provider.of<CoreProvider>(context).fabAction;
    String title = Provider.of<CoreProvider>(context).appTitle;

    Widget actionButton = Container();
    
    if(action != null) {
      icon = icon != null
        ? icon
        : Icons.add;

      actionButton = FloatingActionButton(
        onPressed: () {
          action(context);
        },
        child: Icon(icon),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: FarmForgeDrawer(),
      body: SingleChildScrollView(
        child: content
      ),
      floatingActionButton: actionButton,
    );
  }
}