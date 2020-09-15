import 'package:farmforge_client/models/crops/crops.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/provider/crop_provider.dart';
import 'package:flutter/material.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:provider/provider.dart';

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
  List<Crop> _crops;

  void loadData() async {
    try {
      FarmForgeResponse cropResponse = await Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getCrops(
          begin: Provider.of<CropProvider>(context, listen: false).defaultDate,
          end: DateTime.now()
        );

    }
    catch(e) {
      print("Error: ${e.toString()}");
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth <= kMobileWidth
          ? MobileCrops()
          : constraints.maxWidth <= kTabletWidth
            ? TabletCrops()
            : DesktopCrops();
      },
    );
  }
}