import 'package:farmforge_client/models/farmforge_response.dart';
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
import 'package:farmforge_client/utilities/ui_utility.dart';

class DesktopSettings extends StatefulWidget {

  @override
  _DesktopSettingsState createState() => _DesktopSettingsState();
}

class _DesktopSettingsState extends State<DesktopSettings> {
  List<Location> _locations = [];
  int _selectedLocation;
  int _selectedParentLocation;
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

    Location selectedLocation = _locations
      .firstWhere(
        (l) => l.locationId == _selectedLocation,
        orElse: () => null
      );

    List<DropdownMenuItem<int>> parentLocationOptions;
    String parentLocationLabel = "";
    Function deleteAction;

    if(selectedLocation != null) {
      parentLocationOptions = locationOptions;
      parentLocationLabel = 'Parent Location';
      deleteAction = handleDeleteLocation;
    }

    return [
      Padding(
        padding: EdgeInsets.all(kSmallPadding),
        child: Row(
          children: [
            Container(
              width: 200,
              child: DropdownButtonFormField<int>(
                value: _selectedLocation,
                items: locationOptions,
                onChanged: handleLocationSelection,
                decoration: InputDecoration(
                  labelText: 'Location'
                ),
              ),
            ),
            SizedBox(width: kSmallPadding),
            Container(
              width: 200,
              child: DropdownButtonFormField<int>(
                value: _selectedParentLocation,
                items: parentLocationOptions,
                disabledHint: Text('Select a Location'),
                onChanged: handleParentLocationSelection,
                decoration: InputDecoration(
                  labelText: parentLocationLabel
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteAction,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: handleAddLocation,
            ),
          ],
        ),
      )
    ];
  }

  void handleDeleteLocation() async {
    try {
      FarmForgeResponse deleteResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .deleteLocation(_selectedLocation);

      if(deleteResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .deleteLocation(_selectedLocation);

        setState(() {
          _selectedLocation = null;
        });
      }
      else
        throw deleteResponse.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Delete Error', 
        error: e.toString()
      );
    }
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

  void handleLocationSelection(int newValue) {
    int parentId = _locations
      .firstWhere(
        (l) => l.locationId == newValue,
        orElse: () => null
      )?.parentLocationId;

    setState(() {
      _selectedLocation = newValue;
      _selectedParentLocation = parentId != 0
        ? parentId
        : null;
    });
  }

  void handleParentLocationSelection(int newValue) async {
    setState(() {
      _selectedParentLocation = newValue;
    });

    handleUpdateLocationParent(newValue);
  }

  void handleUpdateLocationParent(int newParent) async {
    try {
      FarmForgeResponse updateResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .updateLocation(
          'ParentLocationId',
          Location(
            locationId: _selectedLocation, 
            parentLocationId: newParent
          )
        );

      if(updateResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .updateLocation(updateResponse.data);
      }
      else
        throw updateResponse.error;
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Delete Error', 
        error: e.toString()
      );
    }
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