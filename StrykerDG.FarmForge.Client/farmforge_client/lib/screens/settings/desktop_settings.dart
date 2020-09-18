import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/general/location.dart';

import 'package:farmforge_client/screens/base/desktop/base_desktop.dart';

import 'package:farmforge_client/widgets/settings/settings_expansion_tile.dart';
import 'package:farmforge_client/widgets/settings/add_location.dart';
import 'package:farmforge_client/widgets/farmforge_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';

class DesktopSettings extends StatefulWidget {

  @override
  _DesktopSettingsState createState() => _DesktopSettingsState();
}

class _DesktopSettingsState extends State<DesktopSettings> {
  List<Location> _locations = [];
  int _selectedLocation;
  int _selectedCropType;

  List<Widget> getCropContent() {
    return List<Widget>();
  }

  List<Widget> getLocationContent() {
    List<DropdownMenuItem<int>> locationOptions = _locations.map((location) => 
      DropdownMenuItem<int>(
        value: location.locationId, 
        child: Text(location.label),
      )
    ).toList();

    return [
      Padding(
        padding: EdgeInsets.all(kSmallPadding),
        child: Row(
          children: [
            DropdownButton<int>(
              value: _selectedLocation,
              items: locationOptions,
              onChanged: (int value) { handleItemSelection('location', value); },
            ),
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: handleEditLocation,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: handleDeleteLocation,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: handleAddLocation,
            )
          ],
        ),
      )
    ];
  }

  void handleEditLocation() {

  }

  void handleDeleteLocation() {

  }

  void handleAddLocation() {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Location',
        content: AddLocation(),
      )
    );
  }

  void handleItemSelection(String key, int newValue) {
    setState(() {
      if(key == 'location')
        _selectedLocation = newValue;
    });
  }

  List<Widget> getUserContent() {
    return List<Widget>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _locations = Provider.of<DataProvider>(context).locations;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List<Location> locations = 

    List<Widget> cropContent = getCropContent();
    List<Widget> locationContent = getLocationContent();
    List<Widget> userContent = getUserContent();

    return BaseDesktop(
      title: 'Settings',
      content: SingleChildScrollView(
        child: Column(
          children: [
            SettingsExpansionTile(
              title: 'Crop Types',
              content: cropContent,
            ),
            SettingsExpansionTile(
              title: 'Locations',
              content: locationContent
            ),
            SettingsExpansionTile(
              title: 'Users',
              content: userContent
            )
          ],
        ),
      ),
    );
  }
} 