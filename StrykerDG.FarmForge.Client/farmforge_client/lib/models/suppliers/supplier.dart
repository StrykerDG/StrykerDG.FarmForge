import 'package:farmforge_client/models/inventory/product_type.dart';

class Supplier {
  int supplierId;
  String name;
  String address;
  String phone;
  String email;
  List<ProductType> products;

  Supplier({
    this.supplierId = 0,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.products
  });

  factory Supplier.fromMap(Map<String, dynamic> data) {
    List<ProductType> products = new List<ProductType>();
    if(data['Products'] != null && data['Products'].length > 0)
      data['Products'].forEach((productData) {
        ProductType type = ProductType.fromMap(productData);
        products.add(type);
      });

    return Supplier(
      supplierId: data['SupplierId'],
      name: data['Name'],
      address: data['Address'],
      phone: data['Phone'],
      email: data['Email'],
      products: products
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SupplierId': this.supplierId,
      'Name': this.name,
      'Address': this.address,
      'Phone': this.phone,
      'Email': this.email
    };
  }
}