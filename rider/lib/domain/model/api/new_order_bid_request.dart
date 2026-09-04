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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['order_id'] = orderId;
    data['tracking_id'] = trackingId;
    data['pickup_address'] = pickupAddress;
    data['delivery_address'] = deliveryAddress;
    data['package_type'] = packageType;
    data['vehicle_type'] = vehicleType;
    data['base_price'] = basePrice;
    data['distance'] = distance;
    data['bid_timeout_seconds'] = bidTimeoutSeconds;
    return data;
  }
}
