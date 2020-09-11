import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/core_provider.dart';
import 'provider/user_provider.dart';

import 'utilities/settings.dart';

import 'screens/login/login.dart';
import 'screens/home/home.dart';
import 'screens/unauthorized/unauthorized.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CoreProvider>(
      create: (BuildContext context) => CoreProvider(),
      child: ChangeNotifierProvider<UserProvider>(
        create: (BuildContext context) => UserProvider(),
        child: FarmForge(),
      )
    )
  );
}

class FarmForge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FarmForge v${Settings.version}',
      theme: Provider.of<CoreProvider>(context).currentTheme,
      initialRoute: Login.id,
      routes: {
        null: (context) => Login(),
        '/': (context) => Login(),
        Login.id: (context) => Login(),
        Home.id: (context) => Home(),
        Unauthorized.id: (context) => Unauthorized(),
      },
    );
  }
}