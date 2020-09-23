class NewCropLogDTO {
  int cropId;
  int logTypeId;
  int cropStatusId;
  String notes;

  NewCropLogDTO({
    this.cropId,
    this.logTypeId,
    this.cropStatusId,
    this.notes
  });

  Map<String, dynamic> toMap() {
    return {
      'CropId': cropId,
      'LogTypeId': logTypeId,
      'CropStatusId': cropStatusId,
      'Notes': notes
    };
  }
}