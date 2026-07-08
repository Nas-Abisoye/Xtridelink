class PaymentAccount {
  String? accountNumber;
  String? accountName;
  String? bankName;
  num? amount;
  DateTime? expiresAt;
  String? paymentTiming;
  String? orderStatus;

  PaymentAccount({
    this.accountNumber,
    this.accountName,
    this.amount,
    this.expiresAt,
    this.paymentTiming,
    this.orderStatus,
    this.bankName,
  });

  @override
  String toString() {
    return 'Data(accountNumber: $accountNumber, accountName: $accountName, amount: $amount, expiresAt: $expiresAt, paymentTiming: $paymentTiming, orderStatus: $orderStatus, bankName: $bankName)';
  }

  factory PaymentAccount.fromJson(Map<String, dynamic> json) => PaymentAccount(
        accountNumber: json['account_number'] as String?,
        accountName: json['account_name'] as String?,
        amount: json['amount'] as num?,
        expiresAt: json['expires_at'] == null
            ? null
            : DateTime.parse(json['expires_at'] as String),
        paymentTiming: json['payment_timing'] as String?,
        orderStatus: json['order_status'] as String?,
        bankName: json['bank_name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'account_number': accountNumber,
        'account_name': accountName,
        'amount': amount,
        'expires_at': expiresAt?.toIso8601String(),
        'payment_timing': paymentTiming,
        'order_status': orderStatus,
        'bank_name': bankName,
      };
}
