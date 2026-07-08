class CustomerPriceProposal {
  String? event;
  String? orderId;
  String? trackingId;
  String? negotiationId;
  String? proposedPrice;
  String? customerName;
  String? riderLastBid;
  String? orderStatus;
  String? pickupAddress;
  String? deliveryAddress;
  String? recipientName;
  String? recipientPhone;
  String? packageType;
  String? deliveryType;
  String? basePrice;
  String? finalPrice;
  String? deliveryNotes;
  String? paymentTiming;
  String? customerId;
  String? message;

  CustomerPriceProposal(
      {this.event,
      this.orderId,
      this.trackingId,
      this.negotiationId,
      this.proposedPrice,
      this.customerName,
      this.riderLastBid,
      this.orderStatus,
      this.pickupAddress,
      this.deliveryAddress,
      this.recipientName,
      this.recipientPhone,
      this.packageType,
      this.deliveryType,
      this.basePrice,
      this.finalPrice,
      this.deliveryNotes,
      this.paymentTiming,
      this.customerId,
      this.message});

  CustomerPriceProposal.fromJson(Map<String, dynamic> json) {
    event = json['event'];
    orderId = json['order_id'];
    trackingId = json['tracking_id'];
    negotiationId = json['negotiation_id'];
    proposedPrice = json['proposed_price'];
    customerName = json['customer_name'];
    riderLastBid = json['rider_last_bid'];
    orderStatus = json['order_status'];
    pickupAddress = json['pickup_address'];
    deliveryAddress = json['delivery_address'];
    recipientName = json['recipient_name'];
    recipientPhone = json['recipient_phone'];
    packageType = json['package_type'];
    deliveryType = json['delivery_type'];
    basePrice = json['base_price'];
    finalPrice = json['final_price'];
    deliveryNotes = json['delivery_notes'];
    paymentTiming = json['payment_timing'];
    customerId = json['customer_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event'] = event;
    data['order_id'] = orderId;
    data['tracking_id'] = trackingId;
    data['negotiation_id'] = negotiationId;
    data['proposed_price'] = proposedPrice;
    data['customer_name'] = customerName;
    data['rider_last_bid'] = riderLastBid;
    data['order_status'] = orderStatus;
    data['pickup_address'] = pickupAddress;
    data['delivery_address'] = deliveryAddress;
    data['recipient_name'] = recipientName;
    data['recipient_phone'] = recipientPhone;
    data['package_type'] = packageType;
    data['delivery_type'] = deliveryType;
    data['base_price'] = basePrice;
    data['final_price'] = finalPrice;
    data['delivery_notes'] = deliveryNotes;
    data['payment_timing'] = paymentTiming;
    data['customer_id'] = customerId;
    data['message'] = message;
    return data;
  }
}
