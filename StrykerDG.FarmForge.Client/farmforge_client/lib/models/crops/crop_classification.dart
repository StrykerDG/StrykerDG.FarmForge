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
      cropClassificationId: data['cropClassificationId'],
      name: data['name'],
      label: data['label'],
      description: data['description']
    );
  }
}