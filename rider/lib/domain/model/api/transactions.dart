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
        transactions: List<TransactionData>.from((json['transactions'] ?? [])
            .map((x) => TransactionData.fromJson(x))),
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
        ? UserDetails.fromJson(json['user_details'])
        : null;
    orderDetails = json['order_details'] != null
        ? OrderDetails.fromJson(json['order_details'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['transaction_id'] = transactionId;
    data['reference'] = reference;
    data['transaction_type'] = transactionType;
    data['amount'] = amount;
    data['fee_amount'] = feeAmount;
    data['net_amount'] = netAmount;
    data['currency'] = currency;
    data['description'] = description;
    data['narration'] = narration;
    data['beneficiary_account_number'] = beneficiaryAccountNumber;
    data['beneficiary_account_name'] = beneficiaryAccountName;
    data['beneficiary_bank_code'] = beneficiaryBankCode;
    data['beneficiary_bank_name'] = beneficiaryBankName;
    data['source_account_number'] = sourceAccountNumber;
    data['source_account_name'] = sourceAccountName;
    data['source_bank_code'] = sourceBankCode;
    data['source_bank_name'] = sourceBankName;
    data['status'] = status;
    data['processor_status_code'] = processorStatusCode;
    data['failure_reason'] = failureReason;
    data['processed_at'] = processedAt;
    data['completed_at'] = completedAt;
    data['session_id'] = sessionId;
    data['cashconnect_reference'] = cashconnectReference;
    data['balance_before'] = balanceBefore;
    data['balance_after'] = balanceAfter;
    data['created_at'] = createdAt;
    if (userDetails != null) {
      data['user_details'] = userDetails!.toJson();
    }
    if (orderDetails != null) {
      data['order_details'] = orderDetails!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tracking_id'] = trackingId;
    data['status'] = status;
    data['pickup_address'] = pickupAddress;
    data['delivery_address'] = deliveryAddress;
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
