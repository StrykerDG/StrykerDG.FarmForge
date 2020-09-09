import 'package:flutter/material.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';

class UiUtility {
  static handleError({
    @required BuildContext context,
    @required String title, 
    @required String error
  }) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        title: title,
        content: Text(error),
      )
    );
  }
}