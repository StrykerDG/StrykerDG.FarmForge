import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/farmforge_response.dart';

import 'large_crops.dart';
import 'medium_crops.dart';
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
  DateTime searchBegin;
  DateTime searchEnd;

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

  @override
  void initState() {
    super.initState();
    
    loadData();
    setState(() {
       searchBegin = Provider.of<DataProvider>(context, listen: false).defaultDate;
       searchEnd = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth <= kSmallWidthMax
          ? SmallCrops()
          : constraints.maxWidth <= kMediumWidthMax
            ? MediumCrops()
            : LargeCrops(
              searchBegin: searchBegin,
              searchEnd: searchEnd,
            );
      },
    );
  }
}