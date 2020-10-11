import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/user_provider.dart';

import 'package:farmforge_client/screens/farm_forge/large_farm_forge.dart';
import 'package:farmforge_client/screens/farm_forge/medium_farm_forge.dart';
import 'package:farmforge_client/screens/farm_forge/small_farm_forge.dart';
import 'package:farmforge_client/screens/login/login.dart';

import 'package:farmforge_client/utilities/constants.dart';

class FarmForge extends StatefulWidget {
  static String id = 'farmforge';

  @override
  _FarmForgeState createState() => _FarmForgeState();
}

class _FarmForgeState extends State<FarmForge> {
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth <= kSmallWidthMax
          ? SmallFarmForge()
          : constraints.maxWidth <= kMediumWidthMax
            ? MediumFarmForge()
            : LargeFarmForge();
      },
    );
  }
}