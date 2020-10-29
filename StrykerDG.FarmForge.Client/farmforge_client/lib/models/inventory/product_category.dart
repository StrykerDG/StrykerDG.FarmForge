class ProductCategory {
  int productCategoryId;
  String name;
  String label;
  String description;

  ProductCategory({
    this.productCategoryId,
    this.name,
    this.label,
    this.description
  });

  factory ProductCategory.fromMap(Map<String, dynamic> data) {
    return ProductCategory(
      productCategoryId: data['ProductCategoryId'],
      name: data['Name'],
      label: data['Label'],
      description: data['Description']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ProductCategoryId': this.productCategoryId,
      'Name': this.name,
      'Label': this.label,
      'Description': this.description
    };
  }
}