import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/crops/crop_variety.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/general/status.dart';

class Crop {
  int cropId;
  int cropTypeId;
  CropType cropType;
  int cropVarietyId;
  CropVariety cropVariety;
  int locationId;
  Location location;
  int statusId;
  Status status;
  DateTime plantedAt;
  DateTime germinatedAt;
  DateTime harvestedAt;
  int timeToGerminate;
  int timeToHarvest;
  int quantity;
  int quantityHarvested;
  double yieldPercent;

  Crop({
    this.cropId,
    this.cropTypeId,
    this.cropType,
    this.cropVarietyId,
    this.cropVariety,
    this.locationId,
    this.location,
    this.statusId,
    this.status,
    this.plantedAt,
    this.germinatedAt,
    this.harvestedAt,
    this.timeToGerminate,
    this.timeToHarvest,
    this.quantity,
    this.quantityHarvested,
    this.yieldPercent
  });

}