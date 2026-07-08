class RiderFinancialModel {
  FinancialData data;

  RiderFinancialModel({
    required this.data,
  });

  factory RiderFinancialModel.fromJson(Map<String, dynamic> json) =>
      RiderFinancialModel(
        data: FinancialData.fromJson(json['data'] ?? {}),
      );
}

class FinancialData {
  String id;
  num standaloneMerchantPayoutRate;
  num merchantPayoutRate;
  num settlementDurationCash;
  num settlementDurationOnline;
  num normalAmountPerKm;
  num normalBaseAmount;
  num expressAmountPerKm;
  num expressBaseAmount;

  FinancialData({
    required this.id,
    required this.standaloneMerchantPayoutRate,
    required this.merchantPayoutRate,
    required this.settlementDurationCash,
    required this.settlementDurationOnline,
    required this.normalAmountPerKm,
    required this.normalBaseAmount,
    required this.expressAmountPerKm,
    required this.expressBaseAmount,
  });

  factory FinancialData.fromJson(Map<String, dynamic> json) => FinancialData(
        id: json['id'] ?? '',
        standaloneMerchantPayoutRate:
            json['standalone_merchant_payout_rate'] ?? 0,
        merchantPayoutRate: json['merchant_payout_rate'] ?? 0,
        settlementDurationCash: json['settlement_duration_cash'] ?? 0,
        settlementDurationOnline: json['settlement_duration_online'] ?? 0,
        normalAmountPerKm: json['normal_amount_per_km'] ?? 0,
        normalBaseAmount: json['normal_base_amount'] ?? 0,
        expressAmountPerKm: json['express_amount_per_km'] ?? 0,
        expressBaseAmount: json['express_base_amount'] ?? 0,
      );
}
