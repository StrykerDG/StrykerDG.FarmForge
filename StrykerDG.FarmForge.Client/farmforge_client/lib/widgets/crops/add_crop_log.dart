import 'package:flutter/material.dart';

import 'package:farmforge_client/models/crops/crop.dart';

import 'package:farmforge_client/utilities/constants.dart';

class AddCropLog extends StatefulWidget {
  final Crop crop;

  AddCropLog({@required this.crop});

  @override
  _AddCropLogState createState() => _AddCropLogState();
}

class _AddCropLogState extends State<AddCropLog> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kSmallDesktopModalWidth,
      child: Text(widget.crop.cropType.label),
    );
  }
}