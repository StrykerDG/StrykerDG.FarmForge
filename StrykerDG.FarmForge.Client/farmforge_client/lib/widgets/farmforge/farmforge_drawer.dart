import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';

import 'package:farmforge_client/screens/crops/crops.dart';
import 'package:farmforge_client/screens/dashboard/dashboard.dart';
import 'package:farmforge_client/screens/inventory/inventory.dart';
import 'package:farmforge_client/screens/customers/customers.dart';
import 'package:farmforge_client/screens/settings/settings.dart';

import 'package:farmforge_client/utilities/constants.dart';

class FarmForgeDrawer extends StatelessWidget {
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
    double deviceHeight = MediaQuery.of(context).size.height;
    
    return Drawer(
      child: Container(
        height: deviceHeight,
        child: Column(
          // Image
          children: [
            ListTile(
              leading: Icon(kDashboardIcon),
              title: Text('Dashboard'),
              onTap: () {
                handleNavigation(
                  context, 
                  Dashboard(), 
                  Dashboard.title,
                  Dashboard.fabIcon, 
                  Dashboard.fabAction
                );
              },
            ),
            ListTile(
              leading: Icon(kCropIcon),
              title: Text('Crops'),
              onTap: () {
                handleNavigation(
                  context, 
                  Crops(), 
                  Crops.title, 
                  Crops.fabIcon, 
                  Crops.fabAction
                );
              },
            ),
            ListTile(
              leading: Icon(kInventoryIcon),
              title: Text('Inventory'),
              onTap: () {
                handleNavigation(
                  context,
                  Inventory(), 
                  Inventory.title, 
                  Inventory.fabIcon,
                  Inventory.fabAction
                );
              },
            ),
            ListTile(
              leading: Icon(kCustomerIcon),
              title: Text('Customers'),
              onTap: () {
                handleNavigation(
                  context,
                  Customers(),
                  Customers.title,
                  Customers.fabIcon,
                  Customers.fabAction
                );
              },
            ),
            Expanded(
              child: Container(),
            ),
            ListTile(
              leading: Icon(kSettingsIcon),
              title: Text('Settings'),
              onTap: () {
                handleNavigation(
                  context, 
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
    );
  }
}