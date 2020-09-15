import 'package:flutter/material.dart';

import 'package:farmforge_client/models/crops/crops.dart';

class CropProvider extends ChangeNotifier {
  DateTime defaultDate = DateTime.now().subtract(Duration(days: 60));
  List<Crop> crops = new List<Crop>();

  void setCrops(List<Crop> newCrops) {
    crops = newCrops;
    notifyListeners();
  }
}