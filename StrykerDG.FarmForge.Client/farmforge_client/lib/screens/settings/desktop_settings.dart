import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/crops/crop_variety.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/user.dart';

import 'package:farmforge_client/screens/base/desktop/base_desktop.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/settings/settings_expansion_tile.dart';
import 'package:farmforge_client/widgets/settings/add_location.dart';
import 'package:farmforge_client/widgets/settings/add_crop_type.dart';
import 'package:farmforge_client/widgets/settings/add_crop_variety.dart';
import 'package:farmforge_client/widgets/settings/add_user.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class DesktopSettings extends StatefulWidget {

  @override
  _DesktopSettingsState createState() => _DesktopSettingsState();
}

class _DesktopSettingsState extends State<DesktopSettings> {
  List<CropType> _cropTypes = [];
  List<Location> _locations = [];
  List<User> _users = [];
  int _selectedRow;
  int _selectedLocation;
  int _selectedParentLocation;
  int _selectedUser;
  int _selectedCropType;

  void setSelectedRow(int index) {
    setState(() {
      if(_selectedRow != index)
        _selectedRow = index;
      else
        _selectedRow = null;
    });
  }

  List<Widget> getCropContent() {
    List<DropdownMenuItem<int>> cropTypeOptions = _cropTypes.map((type) => 
      DropdownMenuItem<int>(
        value: type.cropTypeId,
        child: Text(type.label),
      )
    ).toList();

    Function deleteTypeAction;
    Function deleteVarietyAction;
    Widget varietyList = Container();
    
    if(_selectedCropType != null) {
      deleteTypeAction = handleDeleteCropType;

      if(_selectedRow != null)
        deleteVarietyAction = handleDeleteCropTypeVariety;

      List<CropVariety> varieties = _cropTypes
        .firstWhere(
          (t) => t.cropTypeId == _selectedCropType,
          orElse: () => null)
        ?.varieties;

      List<DataRow> varietyData = varieties != null
        ? List<DataRow>.generate(
          varieties.length, 
          (index) {
            CropVariety v = varieties.elementAt(index);
            return DataRow(
              cells: [DataCell(Text(v?.label))],
              onSelectChanged: (bool value) {
                setSelectedRow(index);
              },
              selected: _selectedRow == index
                ? true
                : false,
              color: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if(states.contains(MaterialState.selected))
                    return Theme.of(context).colorScheme.primary.withOpacity(0.08);
                  else
                    return null;
                }
              )
            );
          }
        )
        : [];

      double listHeight = 60 + (varieties.length * 50.0);
      if(listHeight > 400)
        listHeight = 400;

      varietyList = Container(
        // width: kSmallDesktopModalWidth,
        padding: EdgeInsets.all(kSmallPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 100),
              child: Text('Varieties'),
            ),
            SizedBox(height: kSmallPadding),
            Row(
              children: [
                Container(
                  width: 200.0,
                  height: listHeight,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [DataColumn(label: Text('Name'))],
                      rows: varietyData,
                      showCheckboxColumn: false,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    handleAddVariety(_selectedCropType);
                  }
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: deleteVarietyAction,
                )
              ],
            )
          ],
        ),
      );
    }

    return [
      Padding(
        padding: EdgeInsets.all(kSmallPadding),
        child: Row(
          children: [
            Container(
              width: 200,
              child: DropdownButtonFormField<int>(
                value: _selectedCropType,
                items: cropTypeOptions,
                onChanged: handleCropTypeSelection,
                decoration: InputDecoration(
                  labelText: 'CropType'
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteTypeAction,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: handleAddCropType,
            ),
          ],
        ),
      ),
      Positioned(
        left: 0,
        child: varietyList,
      )
    ];
  }

  void handleCropTypeSelection(int newValue) {
    setState(() {
      _selectedCropType = newValue;
    });
  }

  void handleDeleteCropType() async {
    try {
      FarmForgeResponse deleteResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .deleteCropType(_selectedCropType);

      if(deleteResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .deleteCropType(_selectedCropType);

        setState(() {
          _selectedCropType = null;
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

  void handleAddVariety(int cropTypeId) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Variety',
        content: AddCropVarieity(cropTypeId: cropTypeId),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  void handleDeleteCropTypeVariety() async {
    try {
      int variety = _cropTypes
        .firstWhere(
          (t) => t.cropTypeId == _selectedCropType,
          orElse: () => null
        )
        ?.varieties
        ?.elementAt(_selectedRow)
        ?.cropVarietyId;

      FarmForgeResponse deleteResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .deleteCropVariety(_selectedCropType, variety);

      if(deleteResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .deleteCropTypVariety(_selectedCropType, variety);

        setState(() {
          _selectedRow = null;
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

  void handleAddCropType() {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Type',
        content: AddCropType(),
        width: kSmallDesktopModalWidth,
      )
    );
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
        width: kSmallDesktopModalWidth,
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
        title: 'Update Error', 
        error: e.toString()
      );
    }
  }

  List<Widget> getUserContent() {
    List<DropdownMenuItem<int>> userOptions = _users.map((user) => 
      DropdownMenuItem<int>(
        value: user.userId, 
        child: Text(user.username),
      )
    ).toList();

    Function deleteAction = _selectedUser == null
      ? null
      : handleDeleteUser;

    return [
      Padding(
        padding: EdgeInsets.all(kSmallPadding),
        child: Row(
          children: [
            Container(
              width: 200,
              child: DropdownButtonFormField<int>(
                value: _selectedUser,
                items: userOptions,
                onChanged: handleUserSelection,
                decoration: InputDecoration(
                  labelText: 'User'
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: deleteAction,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: handleAddUser,
            ),
          ],
        ),
      )
    ];
  }

  void handleUserSelection(int newValue) {
    setState(() {
      _selectedUser = newValue;
    });
  }

  void handleDeleteUser() async {
    try {
      FarmForgeResponse deleteResponse = await Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .deleteUser(_selectedUser);

      if(deleteResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .deleteUser(_selectedUser);

        setState(() {
          _selectedUser = null;
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

  void handleAddUser() {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New User',
        content: AddUser(),
        width: kSmallDesktopModalWidth,
      )
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _locations = Provider.of<DataProvider>(context).locations;
      _users = Provider.of<DataProvider>(context).users;
      _cropTypes = Provider.of<DataProvider>(context).cropTypes;
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
              title: 'Crops',
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