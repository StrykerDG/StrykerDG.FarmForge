class CropVariety {
  int cropVarietyId;
  int cropTypeId;
  String name;
  String label;

  CropVariety({
    this.cropVarietyId,
    this.cropTypeId,
    this.name,
    this.label
  });

  factory CropVariety.fromMap(Map<String, dynamic> data) {
    return CropVariety(
      cropVarietyId: data['CropVarietyId'],
      cropTypeId: data['CropTypeId'],
      name: data['Name'],
      label: data['Label']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'CropVarietyId': this.cropVarietyId,
      'CropTypeId': this.cropTypeId,
      'Name': this.name,
      'Label': this.label
    };
  }
}