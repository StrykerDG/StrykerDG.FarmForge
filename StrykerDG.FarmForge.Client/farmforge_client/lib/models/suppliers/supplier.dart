class Supplier {
  int supplierId;
  String name;
  String address;
  String phone;
  String email;

  Supplier({
    this.supplierId = 0,
    this.name,
    this.address,
    this.phone,
    this.email
  });

  factory Supplier.fromMap(Map<String, dynamic> data) {
    return Supplier(
      supplierId: data['SupplierId'],
      name: data['Name'],
      address: data['Address'],
      phone: data['Phone'],
      email: data['Email']
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