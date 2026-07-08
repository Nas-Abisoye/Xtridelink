class NewOrderBidRequest {
  String? event;
  String? orderId;
  String? trackingId;
  String? pickupAddress;
  String? deliveryAddress;
  String? packageType;
  String? vehicleType;
  String? basePrice;
  double? distance;
  int? bidTimeoutSeconds;

  NewOrderBidRequest(
      {this.event,
      this.orderId,
      this.trackingId,
      this.pickupAddress,
      this.deliveryAddress,
      this.packageType,
      this.vehicleType,
      this.basePrice,
      this.distance,
      this.bidTimeoutSeconds});

  NewOrderBidRequest.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    orderId = json['order_id'];
    trackingId = json['tracking_id'];
    pickupAddress = json['pickup_address'];
    deliveryAddress = json['delivery_address'];
    packageType = json['package_type'];
    vehicleType = json['vehicle_type'];
    basePrice = json['base_price'];
    distance = json['distance'];
    bidTimeoutSeconds = json['bid_timeout_seconds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['event'] = this.event;
    data['order_id'] = this.orderId;
    data['tracking_id'] = this.trackingId;
    data['pickup_address'] = this.pickupAddress;
    data['delivery_address'] = this.deliveryAddress;
    data['package_type'] = this.packageType;
    data['vehicle_type'] = this.vehicleType;
    data['base_price'] = this.basePrice;
    data['distance'] = this.distance;
    data['bid_timeout_seconds'] = this.bidTimeoutSeconds;
    return data;
  }
}
