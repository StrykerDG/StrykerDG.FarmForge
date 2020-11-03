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

/*
  static displayLoadingNotification(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kMediumRadius)
        ),
        child: Opacity(
          opacity: 0.3,
          child: Container(
            width: kSmallCardWidth,
            height: kSmallCardHeight,
            color: Colors.black54,
            child: Center(
              child: Text(message),
            ),
          ),
        ),
      )
    );
  }

  static dismissLoadingNotification(BuildContext context) {
    Navigator.pop(context);
  }
  */
}