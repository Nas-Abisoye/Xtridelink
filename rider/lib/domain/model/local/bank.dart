class BankModel {
  String bankName;
  String bankCode;
  String accountNumber;
  String accountName;

  BankModel({
    required this.bankName,
    required this.bankCode,
    required this.accountNumber,
    required this.accountName,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      accountName: json['accountName'] ?? '');
}

class BankResModel {
  List<BankModel> data;

  BankResModel({
    required this.data,
  });

  factory BankResModel.fromJson(Map<String, dynamic> json) => BankResModel(
        data: List<BankModel>.from(
            (json['data'] ?? []).map((x) => BankModel.fromJson(x))),
      );
}

class UserBankAccountsRes {
  List<UserBankAccount> data;

  UserBankAccountsRes({
    required this.data,
  });

  factory UserBankAccountsRes.fromJson(Map<String, dynamic> json) =>
      UserBankAccountsRes(
        data: List<UserBankAccount>.from(
            (json['data']??'').map((x) => UserBankAccount.fromJson(x))),
      );
}

class UserBankAccount {
  String id;
  String riderId;
  dynamic businessId;
  String name;
  String bankName;
  String bankCode;
  String bankAccountNo;
  dynamic userId;

  UserBankAccount({
    required this.id,
    required this.riderId,
    required this.businessId,
    required this.name,
    required this.bankName,
    required this.bankCode,
    required this.bankAccountNo,
    required this.userId,
  });

  factory UserBankAccount.fromJson(Map<String, dynamic> json) =>
      UserBankAccount(
        id: json['id'] ?? '',
        riderId: json['riderId'] ?? '',
        businessId: json['businessId'] ?? '',
        name: json['name'] ?? '',
        bankName: json['bankName'] ?? '',
        bankCode: json['bankCode'] ?? '',
        bankAccountNo: json['bankAccountNo'] ?? '',
        userId: json['userId'] ?? '',
      );
}
