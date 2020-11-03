class AddInventoryDTO {
  int supplierId;
  int productTypeId;
  int locationId;
  int quantity;
  int unitTypeId;

  AddInventoryDTO({
    this.supplierId,
    this.productTypeId,
    this.locationId,
    this.quantity,
    this.unitTypeId
  });

  Map<String, dynamic> toMap() {
    return {
      'SupplierId': this.supplierId,
      'ProductTypeId': this.productTypeId,
      'LocationId': this.locationId,
      'Quantity': this.quantity,
      'UnitTypeId': this.unitTypeId
    };
  }
}