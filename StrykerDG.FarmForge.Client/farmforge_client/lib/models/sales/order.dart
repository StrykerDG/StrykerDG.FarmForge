import 'package:farmforge_client/models/sales/payment.dart';
import 'package:farmforge_client/models/sales/product_destination.dart';

class Order {
  int orderId;
  int customerId;
  String orderNumber;
  double total;
  List<ProductDestination> products;
  List<Payment> payments;

  Order({
    this.orderId,
    this.customerId,
    this.orderNumber,
    this.total,
    this.products,
    this.payments
  });

  factory Order.fromMap(Map<String, dynamic> data) {
    List<ProductDestination> products = new List<ProductDestination>();
    if(data['Products'] != null && data['Products'].length > 0)
      data['Products'].forEach((productData) {
        ProductDestination product = ProductDestination.fromMap(productData);
        products.add(product);
      });

    List<Payment> payments = new List<Payment>();
    if(data['Payments'] != null && data['Payments'].length > 0)
      data['Payments'].forEach((paymentData) {
        Payment payment = Payment.fromMap(paymentData);
        payments.add(payment);
      });

    return Order(
      orderId: data['OrderId'],
      customerId: data['CustomerId'],
      orderNumber: data['OrderNumber'],
      total: data['Total'],
      products: products,
      payments: payments
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> products = List.generate(
      this.products?.length, 
      (index) => this.products.elementAt(index).toMap()
    );
    List<Map<String, dynamic>> payments = List.generate(
      this.payments?.length, 
      (index) => this.payments.elementAt(index).toMap()
    );

    return {
      'OrderId': this.orderId,
      'CustomerId': this.customerId,
      'OrderNumber': this.orderNumber,
      'Total': this.total,
      'Products': products,
      'Payments': payments
    };
  }
}