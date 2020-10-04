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
      cropVarietyId: data['cropVarietyId'],
      cropTypeId: data['cropTypeId'],
      name: data['name'],
      label: data['label']
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