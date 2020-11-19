import 'package:farmforge_client/models/farm_forge_model.dart';
import 'package:farmforge_client/models/sales/order.dart';

class Customer extends FarmForgeModel {
  int customerId;
  String firstName;
  String lastName;
  String phone;
  String email;
  String company;
  List<Order> orders;

  String fullName;

  Customer({
    this.customerId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.company,
    this.orders
  }) {
    this.fullName = '$firstName $lastName';
  }

  factory Customer.fromMap(Map<String, dynamic> data) {
    List<Order> orders = new List<Order>();
    if(data['Orders'] != null && data['Orders'].length > 0)
      data['Orders'].forEach((orderData) {
        Order order = Order.fromMap(orderData);
        orders.add(order);
      });

    return Customer(
      customerId: data['CustomerId'],
      firstName: data['FirstName'],
      lastName: data['LastName'],
      phone: data['Phone'],
      email: data['Email'],
      company: data['Company'],
      orders: orders
    );
  }

  @override
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> orders = List.generate(
      this.orders?.length, 
      (index) => this.orders.elementAt(index).toMap()
    );

    return {
      'CustomerId': this.customerId,
      'FirstName': this.firstName,
      'LastName': this.lastName,
      'Phone': this.phone,
      'Email': this.email,
      'Company': this.company,
      'Orders': orders,
      'FullName': this.fullName
    };
  }
}