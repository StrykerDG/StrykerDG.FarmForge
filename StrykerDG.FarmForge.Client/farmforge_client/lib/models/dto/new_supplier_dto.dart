import 'package:farmforge_client/models/suppliers/supplier.dart';

class NewSupplierDTO {
  Supplier supplier;
  List<int> productIds;

  NewSupplierDTO({
    this.supplier,
    this.productIds
  });

  Map<String, dynamic> toMap() {
    Map<String, dynamic> supplier = this.supplier != null
      ? this.supplier.toMap()
      : null;

    return {
      'Supplier': supplier,
      'ProductIds': this.productIds
    };
  }
}