import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:farmforge_client/provider/data_provider.dart';

import 'package:farmforge_client/models/crops/crop.dart';

import 'package:farmforge_client/utilities/constants.dart';

class SmallCrops extends StatefulWidget {
  final Function onTap;
  final Function onLongPress;

  SmallCrops({
    @required this.onTap,
    @required this.onLongPress
  });

  @override
  _SmallCropsState createState() => _SmallCropsState();
}

class _SmallCropsState extends State<SmallCrops> {
  List<Crop> _crops = [];

  @override
  void initState() {
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _crops = Provider.of<DataProvider>(context).crops;
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double containerHeight = deviceHeight - kAppBarHeight;

    return Container(
      height: containerHeight,
      child: ListView.builder(
        itemCount: _crops.length,
        itemBuilder: (context, index) {
          Crop currentCrop = _crops.elementAt(index);

          String title = '${currentCrop.cropType.label} - ${currentCrop.cropVariety.label}';
          String plantedDate = DateFormat.yMd().format(currentCrop?.plantedAt) ?? "";
          String subTitle = '${currentCrop.location.label} - $plantedDate';

          return ListTile(
            title: Text(title),
            subtitle: Text(subTitle),
            onTap: () {
              // On tap takes a bool so it works with data table row change
              widget.onTap(false, currentCrop);
            },
            onLongPress: () {
              widget.onLongPress(currentCrop);
            },
          );
        }
      ),
    );
  }
}