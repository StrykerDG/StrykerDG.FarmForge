class ProductDestination {
  int productDestinationId;
  int productId;
  int orderId;
  int cropId;
  int destinationProductId;

  ProductDestination({
    this.productDestinationId,
    this.productId,
    this.orderId,
    this.cropId,
    this.destinationProductId
  });

  factory ProductDestination.fromMap(Map<String, dynamic> data) {
    return ProductDestination(
      productDestinationId: data['ProductDestinationId'],
      productId: data['ProductId'],
      orderId: data['OrderId'],
      cropId: data['CropId'],
      destinationProductId: data['DestinationProductId']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ProductDestinationId': this.productDestinationId,
      'ProductId': this.productId,
      'OrderId': this.orderId,
      'CropId': this.cropId,
      'DestinationProductId': this.destinationProductId
    };
  }
}