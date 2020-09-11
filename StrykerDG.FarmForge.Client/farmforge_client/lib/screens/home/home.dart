import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/user_provider.dart';

import 'package:farmforge_client/screens/unauthorized/unauthorized.dart';

class Home extends StatefulWidget {
  static const String id = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void handleNavigation(String id) {
    Navigator.pushNamed(context, id);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => {
      if(Provider.of<UserProvider>(context, listen: false).username == null)
        Navigator.pushNamed(context, Unauthorized.id)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FarmForge'),
      ),
      body: Provider.of<UserProvider>(context, listen: false).username == null
        ? Container()
        : Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              elevation: 5.0,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: 300.0,
                // child: Center(child: Text('Test'),),
                child: ListView(
                  children: [
                    Image.network('https://k48b9e9840-flywheel.netdna-ssl.com/wp-content/uploads/2020/04/COVID-19-Relief_Small-Farms--1024x614.jpg'),
                    ListTile(
                      title: Text('Crops'),
                      onTap: () { handleNavigation(""); },
                    ),
                    ListTile(
                      title: Text('Devices'),
                      onTap: () { handleNavigation(""); },
                    ),
                    ListTile(
                      title: Text('Inventory'),
                      onTap: () { handleNavigation(""); },
                    )
                  ],
                ),
              ),
            ),
            Text("Test"),
            // Text(Provider.of<UserProvider>(context).username),
          ],
        ),
    );
  }
}