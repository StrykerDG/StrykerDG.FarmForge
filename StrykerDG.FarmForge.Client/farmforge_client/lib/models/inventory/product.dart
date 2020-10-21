import 'package:farmforge_client/models/general/status.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';

class Product {
  int productId;
  int productTypeId;
  ProductType productType;
  double price;
  int locationId;
  Location location;
  int statusId;
  Status status;
  int unitTypeId;
  UnitType unitType;

  Product({
    this.productId,
    this.productTypeId,
    this.productType,
    this.price,
    this.locationId,
    this.location,
    this.statusId,
    this.status,
    this.unitTypeId,
    this.unitType
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    ProductType productType = data['ProductType'] != null
      ? ProductType.fromMap(data['ProductType'])
      : null;

    Location location = data['Location'] != null
      ? Location.fromMap(data['Location'])
      : null;

    Status status = data['Status'] != null
      ? Status.fromMap(data['Status'])
      : null;

    UnitType unitType = data['UnitType'] != null
      ? UnitType.fromMap(data['UnitType'])
      : null;

    return Product(
      productId: data['ProductId'],
      productTypeId: data['ProductTypeId'],
      productType: productType,
      price: data['Price'],
      locationId: data['LocationId'],
      location: location,
      statusId: data['StatusId'],
      status: status,
      unitTypeId: data['UnitTypeId'],
      unitType: unitType
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> productType = this.productType?.toMap();
    Map<String, dynamic> location = this.location?.toMap();
    Map<String, dynamic> status = this.status?.toMap();
    Map<String, dynamic> unitType = this.unitType?.toMap();

    return {
      'ProductId': this.productId,
      'ProductType': productType,
      'Price': this.price,
      'LocationId': this.locationId,
      'Location': location,
      'StatusId': this.statusId,
      'Status': status,
      'UnitTypeId': this.unitTypeId,
      'UnitType': unitType
    };
  }
}