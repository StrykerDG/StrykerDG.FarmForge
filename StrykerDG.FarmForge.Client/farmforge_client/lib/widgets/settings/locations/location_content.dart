import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/location.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/settings/locations/add_location.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class LocationContent extends StatefulWidget {
  @override
  _LocationContentState createState() => _LocationContentState();
}

class _LocationContentState extends State<LocationContent> {
  List<Location> _locations = [];
  List<DropdownMenuItem<int>> _locationOptions = [];
  int _selectedLocation;
  int _selectedParentLocation;

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
        title: 'Update Error', 
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
        width: kSmallDesktopModalWidth,
      )
    );
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
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _locations = Provider.of<DataProvider>(context).locations;
      
      _locationOptions = _locations.map((location) => 
        DropdownMenuItem<int>(
          value: location.locationId, 
          child: Text(location.label),
        )
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {

    Location selectedLocation = _locations
      .firstWhere(
        (l) => l.locationId == _selectedLocation,
        orElse: () => null
      );

    List<DropdownMenuItem<int>> parentLocationOptions;
    String parentLocationLabel = "";
    Function deleteAction;

    if(selectedLocation != null) {
      parentLocationOptions = _locationOptions;
      parentLocationLabel = 'Parent Location';
      deleteAction = handleDeleteLocation;
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(kSmallPadding),
          child: Wrap(
            children: [
              Container(
                width: 200,
                child: DropdownButtonFormField<int>(
                  value: _selectedLocation,
                  items: _locationOptions,
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
      ]
    );
  }
}