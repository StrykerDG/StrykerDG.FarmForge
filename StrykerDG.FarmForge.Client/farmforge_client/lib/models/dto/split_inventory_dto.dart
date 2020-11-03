class SplitInventoryDTO {
  List<int> productIds;
  int unitTypeConversionId;
  int locationId;

  SplitInventoryDTO({
    this.productIds,
    this.unitTypeConversionId,
    this.locationId
  });

  Map<String, dynamic> toMap() {
    return {
      'ProductIds': this.productIds,
      'UnitTypeConversionId': this.unitTypeConversionId,
      'LocationId': this.locationId
    };
  }
}