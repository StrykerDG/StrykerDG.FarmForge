class CropClassification {
  int cropClassificationId;
  String name;
  String label;
  String description;

  CropClassification({
    this.cropClassificationId,
    this.name,
    this.label,
    this.description
  });

  factory CropClassification.fromMap(Map<String, dynamic> data) {
    return CropClassification(
      cropClassificationId: data['CropClassificationId'],
      name: data['Name'],
      label: data['Label'],
      description: data['Description']
    );
  }
}