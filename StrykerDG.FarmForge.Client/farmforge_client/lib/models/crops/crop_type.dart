import 'package:farmforge_client/models/crops/crop_classification.dart';
import 'package:farmforge_client/models/crops/crop_variety.dart';

class CropType {
  int cropTypeId;
  int cropClassificationId;
  CropClassification cropClassification;
  String name;
  String label;
  int averageGermination;
  int averageTimeToHarvest;
  double averageYield;
  List<CropVariety> varieties;

  CropType({
    this.cropTypeId,
    this.cropClassificationId,
    this.cropClassification,
    this.name,
    this.label,
    this.averageGermination,
    this.averageTimeToHarvest,
    this.averageYield,
    this.varieties
  });
}