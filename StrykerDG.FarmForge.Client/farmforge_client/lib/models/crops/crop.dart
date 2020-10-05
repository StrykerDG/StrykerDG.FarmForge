import 'package:farmforge_client/models/crops/crop_type.dart';
import 'package:farmforge_client/models/crops/crop_variety.dart';
import 'package:farmforge_client/models/farm_forge_model.dart';
import 'package:farmforge_client/models/general/crop_log.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/general/status.dart';
import 'package:farmforge_client/utilities/date_time_utility.dart';

class Crop extends FarmForgeModel {
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
    CropType cropType = data['CropType'] != null
      ? CropType.fromMap(data['CropType'])
      : null;

    CropVariety variety = data['CropVariety'] != null
      ? CropVariety.fromMap(data['CropVariety'])
      : null;

    Location location = data['Location'] != null
      ? Location.fromMap(data['Location'])
      : null;

    Status status = data['Status'] != null
      ? Status.fromMap(data['Status'])
      : null;

    DateTime plantedAt = data['PlantedAt'] != null
      ? DateTime.tryParse(data['PlantedAt'])
      : null;

    DateTime germinatedAt = data['GerminatedAt'] != null
      ? DateTime.tryParse(data['GerminatedAt'])
      : null;

    DateTime harvestedAt = data['HarvestedAt'] != null
      ? DateTime.tryParse(data['HarvestedAt'])
      : null;

    List<CropLog> logs = new List<CropLog>();
    if(data['Logs'] != null && data['Logs'].length > 0)
      data['Logs'].forEach((logData) {
        CropLog log = CropLog.fromMap(logData);
        logs.add(log);
      });

    return Crop(
      cropId: data['CropId'],
      cropTypeId: data['CropTypeId'],
      cropType: cropType,
      cropVarietyId: data['CropVarietyId'],
      cropVariety: variety,
      locationId: data['LocationId'],
      location: location,
      statusId: data['StatusId'],
      status: status,
      plantedAt: plantedAt,
      germinatedAt: germinatedAt,
      harvestedAt: harvestedAt,
      timeToGerminate: data['TimeToGerminate'],
      timeToHarvest: data['TimeToHarvest'],
      quantity: data['Quantity'],
      quantityHarvested: data['QuantityHarvested'],
      yieldPercent: data['YieldPercent'],
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

  @override
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

    List<Map<String, dynamic>> logs = List.generate(
      this.logs?.length, 
      (index) => this.logs.elementAt(index).toMap()
    );

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
      'Logs': logs
    };
  }
}