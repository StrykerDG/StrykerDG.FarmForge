import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

import 'large_settings.dart';
// import 'medium_settings.dart';
import 'small_settings.dart';

class Settings extends StatefulWidget {
  static const String title = 'Settings';
  static const IconData fabIcon = null;
  static const Function fabAction = null;

  @override
  _SettingsState createState() => _SettingsState();

}

class _SettingsState extends State<Settings> {

  void loadData() {
    try {
      Future<FarmForgeResponse> cropTypeFuture = Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getCropTypes(includes: 'Varieties,Classification');
      Future<FarmForgeResponse> locationFuture = Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getLocations();
      Future<FarmForgeResponse> userFuture = Provider.of<CoreProvider>(context, listen: false)
        .farmForgeService.getUsers();

      Future.wait([cropTypeFuture, locationFuture, userFuture])
        .then((responses) {
          Provider.of<DataProvider>(context, listen: false)
            .setCropTypes(responses[0].data);
          Provider.of<DataProvider>(context, listen: false)
            .setLocations(responses[1].data);
          Provider.of<DataProvider>(context, listen: false)
            .setUsers(responses[2].data);
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
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return LargeSettings();
      },
    );
  }
}