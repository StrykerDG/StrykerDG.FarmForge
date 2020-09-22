class NewCropDTO {
  int cropTypeId;
  int varietyId;
  int locationId;
  int quantity;
  DateTime date;

  NewCropDTO({
    this.cropTypeId,
    this.varietyId,
    this.locationId,
    this.quantity,
    this.date
  });
}