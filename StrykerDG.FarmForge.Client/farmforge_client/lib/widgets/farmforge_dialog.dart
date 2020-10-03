import 'package:flutter/material.dart';

import 'package:farmforge_client/utilities/constants.dart';

class FarmForgeDialog extends StatelessWidget {
  final String title;
  final Widget content;
  final double width;

  FarmForgeDialog({
    @required this.title, 
    @required this.content,
    @required this.width
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kMediumRadius)
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: kSmallPadding),
              child: Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Container(
              width: width,
              child: Divider(
                color: Colors.black,
                height: kDividerHeight,
                thickness: kDividerThickness,
                indent: kDividerIndent,
                endIndent: kDividerIndent,
              ),
            ),
            Container(
              width: width,
              child: Padding(
                padding: EdgeInsets.only(
                  left: kMediumPadding,
                  right: kMediumPadding,
                  bottom: kMediumPadding
                ),
                child: content,
              ),
            )
          ],
        ),
      ),
    );
  }
}