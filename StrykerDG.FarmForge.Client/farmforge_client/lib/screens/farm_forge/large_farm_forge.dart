import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/user_provider.dart';

import 'package:farmforge_client/screens/login/login.dart';
import 'package:farmforge_client/screens/dashboard/dashboard.dart';
import 'package:farmforge_client/screens/crops/crops.dart';
import 'package:farmforge_client/screens/settings/settings.dart';

import 'package:farmforge_client/utilities/constants.dart';

class LargeFarmForge extends StatefulWidget {
  @override
  _LargeFarmForgeState createState() => _LargeFarmForgeState();
}

class _LargeFarmForgeState extends State<LargeFarmForge> {

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
  void initState() {
    super.initState();
    Future.microtask(() => {
      if(Provider.of<UserProvider>(context, listen: false).username == null)
        Navigator.pushNamed(context, Login.id)
    });
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
              elevation: kDesktopNavigationElevation,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: kDesktopNavigationWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.network('https://k48b9e9840-flywheel.netdna-ssl.com/wp-content/uploads/2020/04/COVID-19-Relief_Small-Farms--1024x614.jpg'),
                    ListTile(
                      title: Text("Dashboard"),
                      onTap: () { 
                        handleNavigation(
                          Dashboard(),
                          Dashboard.title,
                          Dashboard.fabIcon,
                          Dashboard.fabAction
                        ); 
                      },
                    ),
                    ListTile(
                      title: Text('Crops'),
                      onTap: () { 
                        handleNavigation(
                          Crops(),
                          Crops.title,
                          Crops.fabIcon,
                          Crops.fabAction
                        ); 
                      },
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
                    ListTile(
                      title: Text('Settings'),
                      onTap: () { 
                        handleNavigation(
                          Settings(),
                          Settings.title,
                          Settings.fabIcon,
                          Settings.fabAction
                        ); 
                      },
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