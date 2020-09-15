import 'package:flutter/material.dart';

import 'desktop_dashboard.dart';
import 'tablet_dashboard.dart';
import 'mobile_dashboard.dart';

import 'package:farmforge_client/utilities/constants.dart';

class Dashboard extends StatefulWidget {
  static const String id = 'dashboard';

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  void handleNavigation(String id) {
    Navigator.pushNamed(context, id);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return constraints.maxWidth <= kMobileWidth
          ? MobileDashboard()
          : constraints.maxWidth <= kTabletWidth
            ? TabletDashboard()
            : DesktopDashboard();
      },
    );
  }
}