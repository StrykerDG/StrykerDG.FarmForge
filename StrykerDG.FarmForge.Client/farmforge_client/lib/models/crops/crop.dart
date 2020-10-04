import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/crops/crop_variety.dart';
import 'package:farmforge_client/models/general/crop_log.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/general/status.dart';
import 'package:farmforge_client/utilities/date_time_utility.dart';

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
  List<CropLog> logs = [];

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
    this.yieldPercent,
    this.logs
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

    List<CropLog> logs = new List<CropLog>();
    if(data['logs'] != null && data['logs'].length > 0)
      data['logs'].forEach((logData) {
        CropLog log = CropLog.fromMap(logData);
        logs.add(log);
      });

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
      yieldPercent: data['yieldPercent'],
      logs: logs
    );
  }

  factory Crop.clone(Crop ref) {
    return Crop(
      cropId: ref.cropId, 
      cropTypeId: ref.cropTypeId,
      cropType: ref.cropType, 
      cropVarietyId: ref.cropVarietyId, 
      cropVariety: ref.cropVariety, 
      locationId: ref.locationId, 
      location: ref.location,
      statusId: ref.statusId, 
      status: ref.status,
      plantedAt: ref.plantedAt,
      germinatedAt: ref.germinatedAt,
      harvestedAt: ref.harvestedAt,
      timeToGerminate: ref.timeToGerminate,
      timeToHarvest: ref.timeToHarvest,
      quantity: ref.quantity,
      quantityHarvested: ref.quantityHarvested,
      yieldPercent: ref.yieldPercent,
      logs: ref.logs
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> cropType = this.cropType?.toMap();
    Map<String, dynamic> cropVariety = this.cropVariety?.toMap();
    Map<String, dynamic> location = this.location?.toMap();
    Map<String, dynamic> status = this.status?.toMap();

    String germinatedAt = this.germinatedAt != null
      ? DateTimeUtility.formatDateTime(this.germinatedAt)
      : null;

    String harvestedAt = this.harvestedAt != null
      ? DateTimeUtility.formatDateTime(this.harvestedAt)
      : null;

    return {
      'CropId': this.cropId,
      'CropTypeId': this.cropTypeId,
      'CropType': cropType,
      'CropVarietyId': this.cropVarietyId,
      'CropVariety': cropVariety,
      'LocationId': this.locationId,
      'Location': location,
      'StatusId': this.statusId,
      'Status': status,
      'PlantedAt': DateTimeUtility.formatDateTime(this.plantedAt),
      'GerminatedAt': germinatedAt,
      'HarvestedAt': harvestedAt,
      'TimeToGerminate': this.timeToGerminate,
      'TimeToHarvest': this.timeToHarvest,
      'Quantity': this.quantity,
      'QuantityHarvested': this.quantityHarvested,
      'Yield': this.yieldPercent,
      'Logs': null
    };
  }
}