import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/core_provider.dart';
import 'provider/user_provider.dart';
import 'provider/data_provider.dart';

import 'screens/farm_forge/farm_forge.dart';
import 'screens/login/login.dart';

import 'utilities/settings.dart' as utility;

void main() {
  utility.Settings.setApiUrl();
  
  runApp(
    ChangeNotifierProvider<CoreProvider>(
      create: (BuildContext context) => CoreProvider(),
      child: ChangeNotifierProvider<UserProvider>(
        create: (BuildContext context) => UserProvider(),
        child: ChangeNotifierProvider<DataProvider>(
          create: (BuildContext context) => DataProvider(),
          child: FarmForgeApp(),
        )
      )
    )
  );
}

class FarmForgeApp extends StatelessWidget {
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
        FarmForge.id: (context) => FarmForge()
      },
    );
  }
}