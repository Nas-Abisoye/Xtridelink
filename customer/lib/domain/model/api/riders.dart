class AvailableRidersModel {
  List<RiderData> data;

  AvailableRidersModel({
    required this.data,
  });

  factory AvailableRidersModel.fromJson(Map<String, dynamic> json) =>
      AvailableRidersModel(
        data: List<RiderData>.from(
            (json['data'] ?? []).map((x) => RiderData.fromJson(x))),
      );
}

class RiderData {
  String? bidId;
  String? riderId;
  String? riderName;
  String? riderPhone;
  String? riderRating;
  String? proposedPrice;
  String? createdAt;

  RiderData(
      {this.bidId,
      this.riderId,
      this.riderName,
      this.riderPhone,
      this.riderRating,
      this.proposedPrice,
      this.createdAt});

  RiderData.fromJson(Map<String, dynamic> json) {
    bidId = json['bid_id'];
    riderId = json['rider_id'];
    riderName = json['rider_name'];
    riderPhone = json['rider_phone'];
    riderRating = json['rider_rating'];
    proposedPrice = json['proposed_price'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bid_id'] = this.bidId;
    data['rider_id'] = this.riderId;
    data['rider_name'] = this.riderName;
    data['rider_phone'] = this.riderPhone;
    data['rider_rating'] = this.riderRating;
    data['proposed_price'] = this.proposedPrice;
    data['created_at'] = this.createdAt;
    return data;
  }
}
