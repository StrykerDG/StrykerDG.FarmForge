import 'package:flutter/material.dart';

import 'package:farmforge_client/widgets/farmforge_dialog.dart';

import 'package:farmforge_client/utilities/constants.dart';

class UiUtility {
  static handleError({
    @required BuildContext context,
    @required String title, 
    @required String error
  }) {
    showDialog(
      context: context,
      builder: (context) => FarmForgeDialog(
        width: kSmallDesktopModalWidth,
        title: title,
        content: Center(
          child: Padding(
            padding: EdgeInsets.all(kSmallPadding),
            child: Text(error),
          ),
        ),
      )
    );
  }
}