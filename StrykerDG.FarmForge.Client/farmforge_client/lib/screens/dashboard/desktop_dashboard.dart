import 'package:flutter/material.dart';

import 'package:farmforge_client/screens/base/desktop/base_desktop.dart';

class DesktopDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseDesktop(
      title: 'Dashboard',
      content: Center(child: Text("Dashboard under development"),),
    );
  }
}