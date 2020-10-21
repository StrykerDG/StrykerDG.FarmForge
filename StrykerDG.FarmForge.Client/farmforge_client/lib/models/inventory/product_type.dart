import 'package:farmforge_client/models/inventory/product_category.dart';

class ProductType {
  int productTypeId;
  int productCategoryId;
  ProductCategory productCategory;
  String name;
  String label;
  int reorderLevel;

  ProductType({
    this.productTypeId,
    this.productCategoryId,
    this.productCategory,
    this.name,
    this.label,
    this.reorderLevel
  });

  factory ProductType.fromMap(Map<String, dynamic> data) {
    ProductCategory category = data['ProductCategory'] != null
      ? ProductCategory.fromMap(data['ProductCategory'])
      : null;

    return ProductType(
      productTypeId: data['ProductTypeId'],
      productCategoryId: data['ProductCategoryId'],
      productCategory: category,
      name: data['Name'],
      label: data['Label'],
      reorderLevel: data['ReorderLevel']
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> category = this.productCategory?.toMap();

    return {
      'ProductTypeId': this.productTypeId,
      'ProductCategoryId': this.productCategoryId,
      'ProductCategory': category,
      'Name': this.name,
      'Label': this.label,
      'ReorderLevel': this.reorderLevel
    };
  }
}