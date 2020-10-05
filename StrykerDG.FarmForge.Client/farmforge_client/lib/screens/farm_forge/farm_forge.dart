import 'package:flutter/material.dart';

import 'package:farmforge_client/screens/farm_forge/large_farm_forge.dart';
import 'package:farmforge_client/screens/farm_forge/medium_farm_forge.dart';
import 'package:farmforge_client/screens/farm_forge/small_farm_forge.dart';

import 'package:farmforge_client/utilities/constants.dart';

class FarmForge extends StatelessWidget {
  static String id = 'farmforge';

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