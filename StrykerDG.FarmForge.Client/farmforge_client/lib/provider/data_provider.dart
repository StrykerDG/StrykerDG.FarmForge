import 'package:flutter/material.dart';

import 'package:farmforge_client/models/crops/crops.dart';
import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/general/location.dart';

class DataProvider extends ChangeNotifier {
  DateTime defaultDate = DateTime.now().subtract(Duration(days: 60));
  List<Crop> crops = new List<Crop>();
  List<CropType> cropTypes = new List<CropType>();

  List<Location> locations = new List<Location>();

  void setCrops(List<Crop> newCrops) {
    crops = newCrops;
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