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

  factory Crop.fromMap(Map<String, dynamic> data) {
    CropType cropType = data['cropType'] != null
      ? CropType.fromMap(data['cropType'])
      : null;

    CropVariety variety = data['cropVariety'] != null
      ? CropVariety.fromMap(data['cropVariety'])
      : null;

    Location location = data['location'] != null
      ? Location.fromMap(data['location'])
      : null;

    Status status = data['status'] != null
      ? Status.fromMap(data['status'])
      : null;

    DateTime plantedAt = data['plantedAt'] != null
      ? DateTime.parse(data['plantedAt'])
      : null;

    DateTime germinatedAt = data['germinatedAt'] != null
      ? DateTime.parse(data['germinatedAt'])
      : null;

    DateTime harvestedAt = data['harvestedAt'] != null
      ? DateTime.parse(data['harvestedAt'])
      : null;

    return Crop(
      cropId: data['cropId'],
      cropTypeId: data['cropTypeId'],
      cropType: cropType,
      cropVarietyId: data['cropVarietyId'],
      cropVariety: variety,
      locationId: data['locationId'],
      location: location,
      statusId: data['statusId'],
      status: status,
      plantedAt: plantedAt,
      germinatedAt: germinatedAt,
      harvestedAt: harvestedAt,
      timeToGerminate: data['timeToGerminate'],
      timeToHarvest: data['timeToHarvest'],
      quantity: data['quantity'],
      quantityHarvested: data['quantityHarvested'],
      yieldPercent: data['yieldPercent']
    );
  }
}