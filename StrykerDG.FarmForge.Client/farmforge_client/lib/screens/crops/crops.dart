import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/farm_forge_data_table_column.dart';
import 'package:farmforge_client/widgets/crops/add_crop_log.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/farmforge_response.dart';

import 'large_crops.dart';
// import 'medium_crops.dart';
import 'small_crops.dart';
import 'package:farmforge_client/widgets/crops/add_crop.dart';
import 'package:farmforge_client/widgets/farmforge_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

class Crops extends StatefulWidget {
  static const String title = 'Crops';
  static const IconData fabIcon = Icons.add;
  static const Function fabAction = handleAddCrop;

  static void handleAddCrop(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add New Crop',
        content: AddCrop(),
        width: kSmallDesktopModalWidth,
      )
    );
  }
  
  @override
  _CropsState createState() => _CropsState();
}

class _CropsState extends State<Crops> {
  DateTime _searchBegin;
  DateTime _searchEnd;
  List<FarmForgeDataTableColumn> _columns;

  void loadData() async {
    try {
      FarmForgeResponse cropResponse = await Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getCrops(
          begin: Provider.of<DataProvider>(context, listen: false).defaultDate,
          end: DateTime.now(),
          includes: 'CropType,CropVariety,Location,Status,Logs.LogType'
        );

      if(cropResponse.data != null) {
        Provider.of<DataProvider>(context, listen: false)
          .setCrops(cropResponse.data);
      }
      else
        throw cropResponse.error;      
    }
    catch(e) {
      UiUtility.handleError(
        context: context, 
        title: 'Load Error', 
        error: e.toString()
      );
    }
  }

  generateColumns() {
        return [
      FarmForgeDataTableColumn(
        label: 'Type',
        property: 'CropType.Label'
      ),
      FarmForgeDataTableColumn(
        label: 'Variety',
        property: 'CropVariety.Label'
      ),
      FarmForgeDataTableColumn(
        label: 'Location',
        property: 'Location.Label'
      ),
      FarmForgeDataTableColumn(
        label: 'Status',
        property: 'Status.Label'
      ),
      FarmForgeDataTableColumn(
        label: 'Quantity',
        property: 'Quantity'
      ),
      FarmForgeDataTableColumn(
        label: 'PlantedAt',
        propertyFunc: (Crop c) =>
          Text(
            DateFormat.yMd().format(c?.plantedAt) ?? ""
          )
      ),
      FarmForgeDataTableColumn(
        label: '',
        propertyFunc: (Crop c) => 
          IconButton(
            icon: Icon(Icons.note),
              onPressed: () { handleAddLog(c); },
          )
      ),
    ];
  }

  void handleAddLog(Crop crop) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: 'Add ${crop.cropType.label} Log',
        content: AddCropLog(crop: crop),
        width: kSmallDesktopModalWidth,
      ),
    );
  }
  
  @override
  void initState() {
    super.initState();
    
    loadData();
    setState(() {
       _searchBegin = Provider.of<DataProvider>(context, listen: false).defaultDate;
       _searchEnd = DateTime.now();
       _columns = generateColumns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {

        // We need to use Mediaquery because the constraints is the size of
        // our "Content" width, not the screen 
        double deviceWidth = MediaQuery.of(context).size.width;

        List<FarmForgeDataTableColumn> columnsToDisplay = 
          deviceWidth > kSmallWidthMax && deviceWidth <= kMediumWidthMax
            ? _columns.where((columnDef) => 
              columnDef.label != 'Variety' &&
              columnDef.label != 'Status' &&
              columnDef.label != 'Quantity'
            ).toList()
            : _columns;

        return deviceWidth < kSmallWidthMax
          ? SmallCrops()
          : deviceWidth <= kMediumWidthMax
            ? LargeCrops(
              searchBegin: _searchBegin,
              searchEnd: _searchEnd,
              columns: columnsToDisplay,              
            )
            : LargeCrops(
              searchBegin: _searchBegin,
              searchEnd: _searchEnd,
              columns: columnsToDisplay,
            );
      },
    );
  }
}