class NewCropLogDTO {
  int cropId;
  int logTypeId;
  int cropStatusId;
  String notes;
  int unitTypeId;
  int quantity;

  NewCropLogDTO({
    this.cropId,
    this.logTypeId,
    this.cropStatusId,
    this.notes,
    this.unitTypeId,
    this.quantity
  });

  Map<String, dynamic> toMap() {
    return {
      'CropId': cropId,
      'LogTypeId': logTypeId,
      'CropStatusId': cropStatusId,
      'Notes': notes,
      'UnitTypeId': unitTypeId,
      'Quantity': quantity
    };
  }
}