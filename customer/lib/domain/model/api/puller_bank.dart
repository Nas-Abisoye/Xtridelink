class PullerBankDataRes {
  PullerBankData data;

  PullerBankDataRes({
    required this.data,
  });

  factory PullerBankDataRes.fromJson(Map<String, dynamic> json) =>
      PullerBankDataRes(
        data: PullerBankData.fromJson(json['data'] ?? {}),
      );
}

class PullerBankData {
  PullerBank data;

  PullerBankData({
    required this.data,
  });

  factory PullerBankData.fromJson(Map<String, dynamic> json) => PullerBankData(
        data: PullerBank.fromJson(json['data'] ?? {}),
      );
}

class PullerBank {
  String accountNo;
  String bankName;
  String currencyCode;
  String displayName;
  String firstName;
  String lastName;
  String amount;
  String email;
  String accountType;
  BankMetadata metadata;

  PullerBank({
    required this.accountNo,
    required this.bankName,
    required this.currencyCode,
    required this.displayName,
    required this.firstName,
    required this.lastName,
    required this.amount,
    required this.email,
    required this.accountType,
    required this.metadata,
  });

  factory PullerBank.fromJson(Map<String, dynamic> json) => PullerBank(
        accountNo: json['account_no'] ?? '',
        bankName: json['bank_name'] ?? '',
        currencyCode: json['currency_code'] ?? '',
        displayName: json['display_name'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        amount: json['amount'] ?? '',
        email: json['email'] ?? '',
        accountType: json['account_type'] ?? '',
        metadata: BankMetadata.fromJson(json['metadata'] ?? {}),
      );
}

class BankMetadata {
  String transactionId;
  String orderId;
  String reference;

  BankMetadata({
    required this.transactionId,
    required this.orderId,
    required this.reference,
  });

  factory BankMetadata.fromJson(Map<String, dynamic> json) => BankMetadata(
        transactionId: json['transactionId'] ?? '',
        orderId: json['orderId'] ?? '',
        reference: json['reference'] ?? '',
      );
}
