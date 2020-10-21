import 'package:farmforge_client/models/farm_forge_model.dart';
import 'package:farmforge_client/models/general/location.dart';
import 'package:farmforge_client/models/inventory/product.dart';
import 'package:farmforge_client/models/inventory/product_type.dart';
import 'package:farmforge_client/models/inventory/unit_type.dart';

class InventoryDTO extends FarmForgeModel {
  int productTypeId;
  ProductType productType;
  int quantity;
  int unitTypeId;
  UnitType unitType;
  int locationId;
  Location location;
  List<Product> products;

  InventoryDTO({
    this.productTypeId,
    this.productType,
    this.quantity,
    this.unitTypeId,
    this.unitType,
    this.locationId,
    this.location,
    this.products
  });

  factory InventoryDTO.fromMap(Map<String, dynamic> data) {
    ProductType productType = data['ProductType'] != null
      ? ProductType.fromMap(data['ProductType'])
      : null;
    
    UnitType unitType = data['UnitType'] != null
      ? UnitType.fromMap(data['UnitType'])
      : null;

    Location location = data['Location'] != null
      ? Location.fromMap(data['Location'])
      : null;

    List<Product> products = new List<Product>();
    if(data['Products'] != null && data['Products'].length > 0)
      data['Products'].forEach((productData) {
        Product product = Product.fromMap(productData);
        products.add(product);
      });

    return InventoryDTO(
      productTypeId: data['ProductTypeId'],
      productType: productType,
      quantity: data['Quantity'],
      unitTypeId: data['UnitTypeId'],
      unitType: unitType,
      locationId: data['LocationId'],
      location: location,
      products: products
    );
  }

  @override 
  Map<String, dynamic> toMap() {
    Map<String, dynamic> productType = this.productType?.toMap();
    Map<String, dynamic> unitType = this.unitType?.toMap();
    Map<String, dynamic> location = this.location?.toMap();

    List<Map<String, dynamic>> products = List.generate(
      this.products?.length, 
      (index) => this.products.elementAt(index).toMap()
    );

    return {
      'ProductTypeId': this.productTypeId,
      'ProductType': productType,
      'Quantity': this.quantity,
      'UnitTypeId': this.unitTypeId,
      'UnitType': unitType,
      'LocationId': this.locationId,
      'Location': location,
      'Products': products
    };
  }
}
