import 'package:farmforge_client/utilities/ui_utility.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/farmforge_response.dart';

import 'mobile_crops.dart';
import 'tablet_crops.dart';
import 'desktop_crops.dart';

import 'package:farmforge_client/utilities/constants.dart';

class Crops extends StatefulWidget {
  static String id = 'crops';
  
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
        return constraints.maxWidth <= kMobileWidth
          ? MobileCrops()
          : constraints.maxWidth <= kTabletWidth
            ? TabletCrops()
            : DesktopCrops(
              searchBegin: searchBegin,
              searchEnd: searchEnd,
            );
      },
    );
  }
}