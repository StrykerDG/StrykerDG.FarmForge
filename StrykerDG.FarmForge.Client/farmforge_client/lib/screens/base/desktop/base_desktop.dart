import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/user_provider.dart';

import 'package:farmforge_client/screens/login/login.dart';
import 'package:farmforge_client/screens/dashboard/dashboard.dart';
import 'package:farmforge_client/screens/crops/crops.dart';
import 'package:farmforge_client/screens/settings/settings.dart';

import 'package:farmforge_client/utilities/constants.dart';

class BaseDesktop extends StatefulWidget {
  final Widget content;
  final Function action;
  final IconData fabIcon;
  final String title;

  BaseDesktop({
    @required this.content,
    this.action,
    this.fabIcon,
    this.title
  });

  @override
  _BaseDesktopState createState() => _BaseDesktopState();
}

class _BaseDesktopState extends State<BaseDesktop> {
  void handleNavigation(BuildContext context, String id) {
    Navigator.pushNamed(context, id);
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

    IconData icon = widget.fabIcon != null
      ? widget.fabIcon
      : Icons.add;

    Widget actionButton = widget.action != null
      ? FloatingActionButton(
          onPressed: () {
            widget.action(context);
          },
          child: Icon(icon),
        )
      : Container();

    String title = widget.title != null
      ? widget.title
      : 'FarmForge';

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
                      onTap: () { handleNavigation(context, Dashboard.id); },
                    ),
                    ListTile(
                      title: Text('Crops'),
                      onTap: () { handleNavigation(context, Crops.id); },
                    ),
                    ListTile(
                      title: Text('Devices'),
                      onTap: () { handleNavigation(context, ""); },
                    ),
                    ListTile(
                      title: Text('Inventory'),
                      onTap: () { handleNavigation(context, ""); },
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    ListTile(
                      title: Text('Account'),
                      onTap: () { handleNavigation(context, ""); },
                    ),
                    ListTile(
                      title: Text('Settings'),
                      onTap: () { handleNavigation(context, Settings.id); },
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  widget.content,
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