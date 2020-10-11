import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/user_provider.dart';

import 'package:farmforge_client/screens/dashboard/dashboard.dart';
import 'package:farmforge_client/screens/crops/crops.dart';
import 'package:farmforge_client/screens/settings/settings.dart';

import 'package:farmforge_client/utilities/constants.dart';

class MediumFarmForge extends StatefulWidget {

  @override
  _MediumFarmForgeState createState() => _MediumFarmForgeState();
}

class _MediumFarmForgeState extends State<MediumFarmForge> {
    void handleNavigation(
    Widget content, 
    String title,
    IconData icon, 
    Function action
  ) {
    Provider.of<CoreProvider>(context, listen: false)
      .setAppContent(content, title, icon, action);
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
      body: Provider.of<UserProvider>(context, listen: false).username == null
        ? Container()
        : Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              elevation: kLargeNavigationElevation,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: kMediumNavigationWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      icon: Icon(Icons.dashboard), 
                      onPressed: () {
                        handleNavigation(
                          Dashboard(),
                          Dashboard.title,
                          Dashboard.fabIcon,
                          Dashboard.fabAction
                        ); 
                      }
                    ),
                    IconButton(
                      icon: Icon(Icons.agriculture), 
                      onPressed: () {
                        handleNavigation(
                          Crops(),
                          Crops.title,
                          Crops.fabIcon,
                          Crops.fabAction
                        ); 
                      }
                    ),
                    // ListTile(
                    //   title: Text('Devices'),
                    //   onTap: () { handleNavigation(context, ""); },
                    // ),
                    // ListTile(
                    //   title: Text('Inventory'),
                    //   onTap: () { handleNavigation(context, ""); },
                    // ),
                    Expanded(
                      child: Container(),
                    ),
                    // ListTile(
                    //   title: Text('Account'),
                    //   onTap: () { handleNavigation(context, ""); },
                    // ),
                    IconButton(
                      icon: Icon(Icons.settings), 
                      onPressed: () {
                        handleNavigation(
                          Settings(),
                          Settings.title,
                          Settings.fabIcon,
                          Settings.fabAction
                        ); 
                      }
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  content,
                  Positioned(
                    bottom: kLargePadding,
                    right: kLargePadding,
                    child: actionButton,
                  )
                ],
              )
            )
          ],
        ),
    );
  }
}