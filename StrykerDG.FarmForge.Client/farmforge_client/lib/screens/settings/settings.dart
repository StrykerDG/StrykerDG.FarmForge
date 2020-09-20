import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:farmforge_client/provider/core_provider.dart';
import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/farmforge_response.dart';

import 'package:farmforge_client/utilities/constants.dart';
import 'package:farmforge_client/utilities/ui_utility.dart';

import 'desktop_settings.dart';
import 'tablet_settings.dart';
import 'mobile_settings.dart';

class Settings extends StatefulWidget {
  static String id = 'settings';

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

      Future.wait([cropTypeFuture, locationFuture])
        .then((responses) {
          Provider.of<DataProvider>(context, listen: false)
            .setCropTypes(responses[0].data);
          Provider.of<DataProvider>(context, listen: false)
            .setLocations(responses[1].data);
        });
    }
    catch(e) {
      UiUtility.handleError(
        context: null, 
        title: null, 
        error: null
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
        return constraints.maxWidth <= kMobileWidth
          ? MobileSettings()
          : constraints.maxWidth <= kTabletWidth
            ? TabletSettings()
            : DesktopSettings();
      },
    );
  }
}