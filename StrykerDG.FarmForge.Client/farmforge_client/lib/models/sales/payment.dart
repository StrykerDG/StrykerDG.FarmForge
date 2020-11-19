class Payment {
  int paymentId;
  int orderId;
  double amount;

  Payment({
    this.paymentId,
    this.orderId,
    this.amount
  });

  factory Payment.fromMap(Map<String, dynamic> data) {
    return Payment(
      paymentId: data['PaymentId'],
      orderId: data['OrderId'],
      amount: data['Amount']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PaymentId': this.paymentId,
      'OrderId': this.orderId,
      'Amount': this.amount
    };
  }
}