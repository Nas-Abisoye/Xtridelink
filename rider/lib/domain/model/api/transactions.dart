class WalletTransactionsRes {
  WalletTransactions data;

  WalletTransactionsRes({
    required this.data,
  });

  factory WalletTransactionsRes.fromJson(Map<String, dynamic> json) =>
      WalletTransactionsRes(
        data: WalletTransactions.fromJson(json['data'] ?? {}),
      );
}

class WalletTransactions {
  List<TransactionData> transactions;
  MetaData meta;

  WalletTransactions({
    required this.transactions,
    required this.meta,
  });

  factory WalletTransactions.fromJson(Map<String, dynamic> json) =>
      WalletTransactions(
        transactions: List<TransactionData>.from(
            (json['transactions'] ?? []).map((x) => TransactionData.fromJson(x))),
        meta: MetaData.fromJson(json['meta'] ?? {}),
      );
}

class MetaData {
  int total;

  MetaData({
    required this.total,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        total: json['total'] ?? 0,
      );
}
class TransactionData {
  String? id;
  String? transactionId;
  String? reference;
  String? transactionType;
  String? amount;
  String? feeAmount;
  String? netAmount;
  String? currency;
  String? description;
  String? narration;
  String? beneficiaryAccountNumber;
  String? beneficiaryAccountName;
  String? beneficiaryBankCode;
  String? beneficiaryBankName;
  String? sourceAccountNumber;
  String? sourceAccountName;
  String? sourceBankCode;
  String? sourceBankName;
  String? status;
  String? processorStatusCode;
  String? failureReason;
  String? processedAt;
  String? completedAt;
  String? sessionId;
  String? cashconnectReference;
  String? balanceBefore;
  String? balanceAfter;
  String? createdAt;
  UserDetails? userDetails;
  OrderDetails? orderDetails;

  TransactionData(
      {this.id,
      this.transactionId,
      this.reference,
      this.transactionType,
      this.amount,
      this.feeAmount,
      this.netAmount,
      this.currency,
      this.description,
      this.narration,
      this.beneficiaryAccountNumber,
      this.beneficiaryAccountName,
      this.beneficiaryBankCode,
      this.beneficiaryBankName,
      this.sourceAccountNumber,
      this.sourceAccountName,
      this.sourceBankCode,
      this.sourceBankName,
      this.status,
      this.processorStatusCode,
      this.failureReason,
      this.processedAt,
      this.completedAt,
      this.sessionId,
      this.cashconnectReference,
      this.balanceBefore,
      this.balanceAfter,
      this.createdAt,
      this.userDetails,
      this.orderDetails});

  TransactionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    reference = json['reference'];
    transactionType = json['transaction_type'];
    amount = json['amount'];
    feeAmount = json['fee_amount'];
    netAmount = json['net_amount'];
    currency = json['currency'];
    description = json['description'];
    narration = json['narration'];
    beneficiaryAccountNumber = json['beneficiary_account_number'];
    beneficiaryAccountName = json['beneficiary_account_name'];
    beneficiaryBankCode = json['beneficiary_bank_code'];
    beneficiaryBankName = json['beneficiary_bank_name'];
    sourceAccountNumber = json['source_account_number'];
    sourceAccountName = json['source_account_name'];
    sourceBankCode = json['source_bank_code'];
    sourceBankName = json['source_bank_name'];
    status = json['status'];
    processorStatusCode = json['processor_status_code'];
    failureReason = json['failure_reason'];
    processedAt = json['processed_at'];
    completedAt = json['completed_at'];
    sessionId = json['session_id'];
    cashconnectReference = json['cashconnect_reference'];
    balanceBefore = json['balance_before'];
    balanceAfter = json['balance_after'];
    createdAt = json['created_at'];
    userDetails = json['user_details'] != null
        ? new UserDetails.fromJson(json['user_details'])
        : null;
    orderDetails = json['order_details'] != null
        ? new OrderDetails.fromJson(json['order_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['reference'] = this.reference;
    data['transaction_type'] = this.transactionType;
    data['amount'] = this.amount;
    data['fee_amount'] = this.feeAmount;
    data['net_amount'] = this.netAmount;
    data['currency'] = this.currency;
    data['description'] = this.description;
    data['narration'] = this.narration;
    data['beneficiary_account_number'] = this.beneficiaryAccountNumber;
    data['beneficiary_account_name'] = this.beneficiaryAccountName;
    data['beneficiary_bank_code'] = this.beneficiaryBankCode;
    data['beneficiary_bank_name'] = this.beneficiaryBankName;
    data['source_account_number'] = this.sourceAccountNumber;
    data['source_account_name'] = this.sourceAccountName;
    data['source_bank_code'] = this.sourceBankCode;
    data['source_bank_name'] = this.sourceBankName;
    data['status'] = this.status;
    data['processor_status_code'] = this.processorStatusCode;
    data['failure_reason'] = this.failureReason;
    data['processed_at'] = this.processedAt;
    data['completed_at'] = this.completedAt;
    data['session_id'] = this.sessionId;
    data['cashconnect_reference'] = this.cashconnectReference;
    data['balance_before'] = this.balanceBefore;
    data['balance_after'] = this.balanceAfter;
    data['created_at'] = this.createdAt;
    if (this.userDetails != null) {
      data['user_details'] = this.userDetails!.toJson();
    }
    if (this.orderDetails != null) {
      data['order_details'] = this.orderDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? id;
  String? name;
  String? email;

  UserDetails({this.id, this.name, this.email});

  UserDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}

class OrderDetails {
  String? id;
  String? trackingId;
  String? status;
  String? pickupAddress;
  String? deliveryAddress;

  OrderDetails(
      {this.id,
      this.trackingId,
      this.status,
      this.pickupAddress,
      this.deliveryAddress});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trackingId = json['tracking_id'];
    status = json['status'];
    pickupAddress = json['pickup_address'];
    deliveryAddress = json['delivery_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tracking_id'] = this.trackingId;
    data['status'] = this.status;
    data['pickup_address'] = this.pickupAddress;
    data['delivery_address'] = this.deliveryAddress;
    return data;
  }
}


// class TransactionData {
//   String id;
//   DateTime createdAt;
//   num amount;
//   String reference;
//   num transactionFee;
//   String flowType;
//   String status;
//   String description;
//   String type;
//   bool isOutstandingSettlement;
//   dynamic paymentMethod;
//   String paymentGateway;
//   dynamic cardId;
//   dynamic receiverWalletId;
//   String senderWalletId;
//   dynamic userId;
//   String riderId;
//   dynamic businessId;
//   dynamic orderId;
//   String owner;
//   String payoutOutstandingId;
//   RiderData rider;

//   TransactionData({
//     required this.id,
//     required this.createdAt,
//     required this.amount,
//     required this.reference,
//     required this.transactionFee,
//     required this.flowType,
//     required this.status,
//     required this.description,
//     required this.type,
//     required this.isOutstandingSettlement,
//     required this.paymentMethod,
//     required this.paymentGateway,
//     required this.cardId,
//     required this.receiverWalletId,
//     required this.senderWalletId,
//     required this.userId,
//     required this.riderId,
//     required this.businessId,
//     required this.orderId,
//     required this.owner,
//     required this.payoutOutstandingId,
//     required this.rider,
//   });

//   factory TransactionData.fromJson(Map<String, dynamic> json) => TransactionData(
//         id: json['id'] ?? '',
//         createdAt: DateTime.tryParse(
//             json['createdAt'] ?? '')?.toLocal() ?? DateTime.now(),
//         amount: json['amount'] ?? 0,
//         reference: json['reference'] ?? '',
//         transactionFee: json['transactionFee'] ?? 0,
//         flowType: json['flowType'] ?? '',
//         status: json['status'] ?? '',
//         description: json['description'] ?? '',
//         type: json['type'] ?? '',
//         isOutstandingSettlement: json['isOutstandingSettlement'] ?? false,
//         paymentMethod: json['paymentMethod'],
//         paymentGateway: json['paymentGateway'] ?? '',
//         cardId: json['cardId'],
//         receiverWalletId: json['receiverWalletId'],
//         senderWalletId: json['senderWalletId'] ?? '',
//         userId: json['userId'],
//         riderId: json['riderId'] ?? '',
//         businessId: json['businessId'],
//         orderId: json['orderId'],
//         owner: json['owner'] ?? '',
//         payoutOutstandingId: json['payoutOutstandingId'] ?? '',
//         rider: RiderData.fromJson(json['rider'] ?? {}),
//       );
// }

// class RiderData {
//   String id;
//   dynamic orderCompleted;
//   String userId;
//   dynamic distanceCovered;
//   dynamic idVerification;
//   dynamic license;
//   bool isActive;
//   dynamic addressVerification;
//   dynamic businessId;
//   String rating;
//   String withdrawalAccountId;
//   String payoutType;
//   num upNegotiationRate;
//   num downNegotiationRate;
//   String status;

//   RiderData({
//     required this.id,
//     required this.orderCompleted,
//     required this.userId,
//     required this.distanceCovered,
//     required this.idVerification,
//     required this.license,
//     required this.isActive,
//     required this.addressVerification,
//     required this.businessId,
//     required this.rating,
//     required this.withdrawalAccountId,
//     required this.payoutType,
//     required this.upNegotiationRate,
//     required this.downNegotiationRate,
//     required this.status,
//   });

//   factory RiderData.fromJson(Map<String, dynamic> json) => RiderData(
//         id: json['id'] ?? '',
//         orderCompleted: json['orderCompoleted'],
//         userId: json['userId'] ?? '',
//         distanceCovered: json['distanceCovered'],
//         idVerification: json['idVerification'],
//         license: json['license'],
//         isActive: json['isActive'] ?? false,
//         addressVerification: json['addressVerification'],
//         businessId: json['businessId'],
//         rating: json['rating'] ?? '',
//         withdrawalAccountId: json['withdrawalAccountId'] ?? '',
//         payoutType: json['payoutType'] ?? '',
//         upNegotiationRate: json['upNegotiationRate'] ?? 0,
//         downNegotiationRate: json['downNegotiationRate'] ?? 0,
//         status: json['status'] ?? '',
//       );
// }
