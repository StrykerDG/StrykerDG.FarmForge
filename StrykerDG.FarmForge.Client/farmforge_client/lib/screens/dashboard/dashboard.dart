import 'package:flutter/material.dart';

import 'large_dashboard.dart';
import 'medium_dashboard.dart';
import 'small_dashboard.dart';

import 'package:farmforge_client/utilities/constants.dart';

class Dashboard extends StatefulWidget {
  static const String title = 'Dashboard';
  static const IconData fabIcon = null;
  static const Function fabAction = null;

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
        return constraints.maxWidth <= kSmallWidthMax
          ? SmallDashboard()
          : constraints.maxWidth <= kMediumWidthMax
            ? MediumDashboard()
            : LargeDashboard();
      },
    );
  }
}