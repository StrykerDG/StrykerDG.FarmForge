import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/core_provider.dart';
import 'provider/user_provider.dart';
import 'provider/data_provider.dart';

import 'utilities/settings.dart' as utility;

import 'screens/login/login.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/crops/crops.dart';
import 'screens/settings/settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CoreProvider>(
      create: (BuildContext context) => CoreProvider(),
      child: ChangeNotifierProvider<UserProvider>(
        create: (BuildContext context) => UserProvider(),
        child: ChangeNotifierProvider<DataProvider>(
          create: (BuildContext context) => DataProvider(),
          child: FarmForge(),
        )
      )
    )
  );
}

class FarmForge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmForge v${utility.Settings.version}',
      theme: Provider.of<CoreProvider>(context).currentTheme,
      initialRoute: Login.id,
      routes: {
        null: (context) => Login(),
        '/': (context) => Login(),
        Login.id: (context) => Login(),
        Dashboard.id: (context) => Dashboard(),
        Crops.id: (context) => Crops(),
        Settings.id: (context) => Settings(),
      },
    );
  }
}