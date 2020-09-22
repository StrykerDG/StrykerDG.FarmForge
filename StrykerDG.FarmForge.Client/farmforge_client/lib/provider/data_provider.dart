import 'package:flutter/material.dart';

import 'package:farmforge_client/models/crops/crop.dart';
import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/general/location.dart';

class DataProvider extends ChangeNotifier {
  DateTime defaultDate = DateTime.now().subtract(Duration(days: 60));
  List<Crop> crops = [];
  List<CropType> cropTypes = [];
  List<Location> locations = [];

  void setCrops(List<dynamic> newCrops) {
    crops.clear();
    newCrops.forEach((cropData) { 
      crops.add(Crop.fromMap(cropData));
    });
    notifyListeners();
  }

  void addCrop(Map<String, dynamic> newCrop) {
    crops.add(Crop.fromMap(newCrop));
    notifyListeners();
  }

  void setCropTypes(List<dynamic> newCropTypes) {
    cropTypes.clear();
    newCropTypes.forEach((cropTypeData) { 
      cropTypes.add(CropType.fromMap(cropTypeData));
    });
    notifyListeners();
  }

  void setLocations(List<dynamic> newLocations) {
    locations.clear();
    newLocations.forEach((locationData) { 
      locations.add(Location.fromMap(locationData));
    });
    notifyListeners();
  }

  void addLocation(dynamic newLocation) {
    locations.add(Location.fromMap(newLocation));
    notifyListeners();
  }

  void updateLocation(dynamic location) {
    Location locationToUpdate = Location.fromMap(location);

    int locationIndex = locations.indexWhere(
      (l) => l.locationId == locationToUpdate.locationId,
    );

    if(locationIndex != -1) {
      locations[locationIndex] = locationToUpdate;
      notifyListeners();
    }
  }

  void deleteLocation(int id) {
    locations.removeWhere((l) => l.locationId == id);
    notifyListeners();
  }
}