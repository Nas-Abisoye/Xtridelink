// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:injectable/injectable.dart';
// import 'package:xtridelink/domain/model/api/order_det.dart';
// import 'package:xtridelink/domain/model/api/puller_bank.dart';
// import 'package:xtridelink/domain/model/api/riders.dart';
// import 'package:xtridelink/domain/model/api/track.dart';
// import '../../../constants/helpers.dart';
// import '../../../../domain/model/local/chat.dart';
// import '../request_helper.dart';

// sealed class OrderApiService {
//   Future<List<OrderDetails>?> getOrders();
//   Future<OrderDetails?> createUpdateOrder(
//       {required Map<String, dynamic> map, required String? orderId});
//   Future<OrderDetails?> updateOrder(
//       {required Map<String, dynamic> map, required String orderId});
//   Future<OrderRecipientData?> addOrderRecipient(
//       {required Map<String, dynamic> map});
//   Future<List<RiderData>?> getRiders({required String location});
//   Future<bool> createOffer(
//       {required String senderId,
//       required String receiverId,
//       required String orderId,
//       required num amount});
//   Future<bool> cancelOrder({required String orderId});
//   Future<TrackingData?> trackOrder({required String trackingId});
//   Future<PullerBank?> generatePaymentAccount(
//       {required num amount, required String orderId});
//   Future<String?> verifyPayment({required String reference});
//   Future<bool> rateRider({required String riderId, required String rating});
//   Future<List<ChatTextModel>> getChats({required String roomId});
// }

// @Injectable()
// class OrderApiServiceImpl extends OrderApiService {
//   RequestHelpersImpl requestHelpers;
//   OrderApiServiceImpl({required this.requestHelpers});

//   @override
//   Future<List<OrderDetails>?> getOrders() async {
//     String url = '/v1/user/orders';
//     try {
//       http.Response? res = await requestHelpers.get(url: url);
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         OrdersListResModel ordersListResModel =
//             OrdersListResModel.fromJson(body);
//         return ordersListResModel.data.data;
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//     return null;
//   }

//   @override
//   Future<OrderDetails?> createUpdateOrder(
//       {required Map<String, dynamic> map, required String? orderId}) async {
//     String url = orderId == null
//         ? '/v1/user/create-orders/'
//         : '/v1/user/update/$orderId';
//     try {
//       http.Response? res = await requestHelpers.post(url: url, body: map);
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         OrderDetResModel orderDetResModel = OrderDetResModel.fromJson(body);
//         return orderDetResModel.data;
//       } else {
//         HelperFunc.toast(
//             body['message']?.toString() ?? 'Failed to create order');
//       }
//     } catch (e) {
//       log(e.toString());
//       HelperFunc.toast('Failed to create order');
//     }
//     return null;
//   }

//   @override
//   Future<OrderDetails?> updateOrder(
//       {required Map<String, dynamic> map, required String orderId}) async {
//     String url = '/v1/user/update/$orderId';
//     try {
//       http.Response? res = await requestHelpers.post(url: url, body: map);
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         OrderDetResModel orderDetResModel = OrderDetResModel.fromJson(body);
//         return orderDetResModel.data;
//       } else {
//         // HelperFunc.toast(
//         //     body['message']?.toString() ?? 'Failed to update order');
//       }
//     } catch (e) {
//       log(e.toString());
//       // HelperFunc.toast('Failed to update order');
//     }
//     return null;
//   }

//   @override
//   Future<OrderRecipientData?> addOrderRecipient(
//       {required Map<String, dynamic> map}) async {
//     String url = map['orderReciepientId'] != null
//         ? '/v1/user/edit-order-recipient/'
//         : '/v1/user/create-order-recipient/';
//     try {
//       http.Response? res = map['orderReciepientId'] != null
//           ? await requestHelpers.put(url: url, body: map)
//           : await requestHelpers.post(url: url, body: map);
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         return OrderRecipientData.fromJson(body['data'] ?? {});
//       } else {
//         HelperFunc.toast(
//             body['message']?.toString() ?? 'Failed to add recipient details');
//       }
//     } catch (e) {
//       log(e.toString());
//       HelperFunc.toast('Failed to add recipient details');
//     }
//     return null;
//   }

//   @override
//   Future<List<RiderData>?> getRiders({required String location}) async {
//     String url = '/v1/user/get-riders';
//     try {
//       http.Response? res = await requestHelpers.post(
//           url: url,
//           // body: {'location': 'Opebi Road, Ikeja, Nigeria'});
//           body: {'location': 'ikeja'});
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         AvailableRidersModel availableRidersModel =
//             AvailableRidersModel.fromJson(body);
//         return availableRidersModel.data;
//       } else {
//         HelperFunc.toast(
//             body['message']?.toString() ?? 'Failed to add recipient details');
//       }
//     } catch (e) {
//       log(e.toString());
//       HelperFunc.toast('Failed to add recipient details');
//     }
//     return null;
//   }

//   @override
//   Future<bool> rateRider(
//       {required String riderId, required String rating}) async {
//     String url = '/v1/user/rate-rider';
//     try {
//       http.Response? res = await requestHelpers
//           .post(url: url, body: {'rating': rating, 'riderId': riderId});
//       if (res == null) return false;
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         return true;
//       } else {
//         HelperFunc.toast(body['message']?.toString() ?? 'Failed to rate rider');
//       }
//     } catch (e) {
//       log(e.toString());
//       HelperFunc.toast('Failed to rate rider');
//     }
//     return false;
//   }

//   @override
//   Future<bool> createOffer(
//       {required String senderId,
//       required String receiverId,
//       required String orderId,
//       required num amount}) async {
//     String url = '/v1/user/create-offer';
//     try {
//       http.Response? res = await requestHelpers.post(url: url, body: {
//         'senderId': senderId,
//         'riderId': receiverId,
//         'orderId': orderId,
//         'amount': amount
//       });
//       if (res == null) return false;
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         return true;
//       } else {
//         HelperFunc.toast(
//             body['message']?.toString() ?? 'Failed to create offer');
//       }
//     } catch (e) {
//       log(e.toString());
//       HelperFunc.toast('Failed to create offer');
//     }
//     return false;
//   }

//   @override
//   Future<bool> cancelOrder({required String orderId}) async {
//     String url = '/v1/user/cancel/$orderId';
//     try {
//       http.Response? res =
//           await requestHelpers.post(url: url, body: {'orderId': orderId});
//       if (res == null) return false;
//       if (res.statusCode == 200 || res.statusCode == 201) return true;
//     } catch (e) {
//       log(e.toString());
//     }
//     return false;
//   }

//   @override
//   Future<TrackingData?> trackOrder({required String trackingId}) async {
//     String url = '/v1/recipient/$trackingId';
//     try {
//       http.Response? res = await requestHelpers.get(url: url);
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       if ((res.statusCode == 200 || res.statusCode == 201) &&
//           body['data'] != null) {
//         TrackingResData trackingResData = TrackingResData.fromJson(body);
//         return trackingResData.data;
//       } else {
//         HelperFunc.toast(body['data'] == null
//             ? 'Invalid Id'
//             : body['message']?.toString() ?? 'Failed to track order');
//       }
//     } catch (e) {
//       log(e.toString());
//       HelperFunc.toast('Failed to track order');
//     }
//     return null;
//   }

//   @override
//   Future<PullerBank?> generatePaymentAccount(
//       {required num amount, required String orderId}) async {
//     String url = '/v1/transactions/user/payment';
//     try {
//       http.Response? res = await requestHelpers
//           .post(url: url, body: {'amount': amount, 'orderId': orderId});
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       if ((res.statusCode == 200 || res.statusCode == 201)) {
//         PullerBankDataRes pullerBankDataRes = PullerBankDataRes.fromJson(body);
//         return pullerBankDataRes.data.data;
//       } else {
//         HelperFunc.toast(body['message']?.toString() ??
//             'Failed to generate payment account');
//       }
//     } catch (e) {
//       log(e.toString());
//       HelperFunc.toast('Failed to generate payment account');
//     }
//     return null;
//   }

//   @override
//   Future<String?> verifyPayment({required String reference}) async {
//     String url = '/v1/transactions/verify-payment';
//     try {
//       http.Response? res =
//           await requestHelpers.post(url: url, body: {'reference': reference});
//       if (res == null) return null;
//       var body = jsonDecode(res.body);
//       return body['data']?.toString();
//     } catch (e) {
//       log(e.toString());
//     }
//     return null;
//   }

//   @override
//   Future<List<ChatTextModel>> getChats({required String roomId}) async {
//     String url = '/v1/chat/$roomId';
//     try {
//       http.Response? res = await requestHelpers.get(url: url);
//       if (res == null) return [];
//       var body = jsonDecode(res.body);
//       if (res.statusCode == 200 || res.statusCode == 201) {
//         ChatTextModelRes chatModelRes = ChatTextModelRes.fromJson(body);
//         return chatModelRes.data;
//       }
//     } catch (e) {
//       log(e.toString());
//     }
//     return [];
//   }
// }
