import 'package:flutter/material.dart';

import 'package:farmforge_client/widgets/settings/settings_expansion_tile.dart';

import 'package:farmforge_client/widgets/settings/crops/crop_content.dart';
import 'package:farmforge_client/widgets/settings/inventory/inventory_content.dart';
import 'package:farmforge_client/widgets/settings/locations/location_content.dart';
import 'package:farmforge_client/widgets/settings/users/user_content.dart';

class LargeSettings extends StatefulWidget {

  @override
  _LargeSettingsState createState() => _LargeSettingsState();
}

class _LargeSettingsState extends State<LargeSettings> {

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        children: [
          SettingsExpansionTile(
            title: 'Crops',
            content: CropContent(),
          ),
          SettingsExpansionTile(
            title: 'Locations',
            content: LocationContent()
          ),
          SettingsExpansionTile(
            title: 'Users',
            content: UserContent()
          ),
          SettingsExpansionTile(
            title: 'Inventory',
            content: InventoryContent(),
          )
        ],
      ),
    );
  }
} 