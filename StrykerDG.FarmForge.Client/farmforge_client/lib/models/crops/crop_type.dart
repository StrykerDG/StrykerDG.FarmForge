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

  factory CropType.fromMap(Map<String, dynamic> data) {
    List<CropVariety> cropVarieties = new List<CropVariety>();
    if(data['Varieties'] != null && data['Varieties'].length > 0)
      data['Varieties'].forEach((varietyData) {
        CropVariety variety = CropVariety.fromMap(varietyData);
        cropVarieties.add(variety);
      });

    CropClassification classification = data['CropClassification'] != null
      ? CropClassification.fromMap(data['CropClassification'])
      : null;

    return CropType(
      cropTypeId: data['CropTypeId'],
      cropClassificationId: data['CropClassificationId'],
      cropClassification: classification,
      name: data['Name'],
      label: data['Label'],
      averageGermination: data['AverageGermination'],
      averageTimeToHarvest: data['AverageTimeToHarvest'],
      averageYield: data['AverageYield'],
      varieties: cropVarieties
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CropTypeId': this.cropTypeId,
      'CropClassificationId': this.cropClassificationId,
      'CropClassification': null,
      'Name': this.name,
      'Label': this.label,
      'AverageGermination': this.averageGermination,
      'AverageTimeToHarvest': this.averageTimeToHarvest,
      'AverageYield': this.averageYield,
      'Varieties': null
    };
  }
}