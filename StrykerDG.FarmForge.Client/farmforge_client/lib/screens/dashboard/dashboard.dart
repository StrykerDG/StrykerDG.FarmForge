import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/farmforge_response.dart';
import 'package:farmforge_client/models/general/crop_log.dart';

import 'large_dashboard.dart';
// import 'medium_dashboard.dart';
// import 'small_dashboard.dart';

import 'package:farmforge_client/utilities/ui_utility.dart';

class Dashboard extends StatefulWidget {
  static const String title = 'Dashboard';
  static const IconData fabIcon = null;
  static const Function fabAction = null;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Crop> _crops;
  List<CropLog> _logs;

  void handleNavigation(String id) {
    Navigator.pushNamed(context, id);
  }

  void loadData() async {
    try {
      Future<FarmForgeResponse> cropsPlantedResponse = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getCrops(
          includes: 'Location,Status',
          status: 'planted,germinated,growing,flowering,ripening,transplanted',
        );
      Future<FarmForgeResponse> cropLogs = Provider
        .of<CoreProvider>(context, listen: false)
        .farmForgeService
        .getCropLogs('harvest');

      Future.wait([cropsPlantedResponse, cropLogs])
        .then((responses) {
          setState(() {
            _crops = List<Crop>();
            responses[0].data.forEach((map) {
              _crops.add(Crop.fromMap(map));
            });
            _logs = List<CropLog>();
            responses[1].data.forEach((map) {
              _logs.add(CropLog.fromMap(map));
            });
          });
        });
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
  }

  @override
  Widget build(BuildContext context) {
    return LargeDashboard(
      crops: _crops,
      logs: _logs,
    );
  }
}