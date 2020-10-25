import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';
import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/crops/crop_variety.dart';
import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';
import 'package:farmforge_client/widgets/settings/crops/add_crop_type.dart';
import 'package:farmforge_client/widgets/settings/crops/add_crop_variety.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class CropContent extends StatefulWidget {
  @override
  _CropContentState createState() => _CropContentState();
}

class _CropContentState extends State<CropContent> {
  List<CropType> _cropTypes = [];
  List<DropdownMenuItem<int>> _cropTypeOptions = [];
  int _selectedCropType;
  int _selectedRow;

  void setSelectedRow(int index) {
    setState(() {
      if(_selectedRow != index)
        _selectedRow = index;
      else
        _selectedRow = null;
    });
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

  Widget buildVarietyList() {
    Function deleteVarietyAction;

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

    return Container(
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
          Wrap(
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
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _cropTypes = Provider.of<DataProvider>(context).cropTypes;
      _cropTypeOptions = _cropTypes.map((type) => 
        DropdownMenuItem<int>(
          value: type.cropTypeId,
          child: Text(type.label),
        )
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Function deleteTypeAction;
    
    Widget varietyList = Container();

    if(_selectedCropType != null) {
      deleteTypeAction = handleDeleteCropType;
      varietyList = buildVarietyList();
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
                  value: _selectedCropType,
                  items: _cropTypeOptions,
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
        varietyList
      ]
    );
  }
}