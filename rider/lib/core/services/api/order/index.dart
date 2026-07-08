import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/domain/model/api/offers.dart';
import 'package:xtridelink_driver/domain/model/api/ongoing_orders.dart';
import 'package:xtridelink_driver/domain/model/local/chat.dart';
import '../../../constants/helpers.dart';
import '../request_helper.dart';

sealed class OrderApiService {
  Future<List<OrderDetails>?> getOngoingOrders();
  Future<List<OrderDetails>?> getHistory();
  Future<OrderDetails?> getOrder(String orderId);
  Future<List<OfferData>?> getAllOffers();
  Future<bool> acceptDeclineOffer(
      {required bool isAccepted,
      required String orderId,
      required String offerId});
  Future<bool> updateTracking({
    required String trackingId,
    required String orderLocation,
  });
  Future<bool> completeOrder(
      {required String trackingId, required String deliveryCode});
  Future<bool> userUnreachable({required String orderId});
  Future<List<ChatTextModel>> getChats({required String roomId});
  Future<bool> generate2FA({required String orderId});
  Future<bool> verify2FA(
      {required String orderId,
      required String trackingId,
      required String otp});
}

class OrderApiServiceImpl extends OrderApiService {
  RequestHelpersImpl requestHelpers;
  OrderApiServiceImpl({required this.requestHelpers});

  @override
  Future<List<OrderDetails>?> getOngoingOrders() async {
    String url = '/orders/';
    try {
      http.Response? res = await requestHelpers.get(url: url, useToken: true);
      if (res == null) return null;
      var body = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode == 200 || res.statusCode == 201) {
        OngoingOrdersResModel ongoingOrdersResModel =
            OngoingOrdersResModel.fromJson(body);
        return ongoingOrdersResModel.data
            .where((element) => element.status != 'completed')
            .where((element) => element.status != 'canceled')
            .toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Future<OrderDetails?> getOrder(String orderId) async {
    String url = '/orders/$orderId/';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return OrderDetails.fromJson(body['data']);
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Future<List<OfferData>?> getAllOffers() async {
    String url = '/v1/rider/all-offers';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: {});
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        AllOffersResModel allOffersResModel = AllOffersResModel.fromJson(body);
        return allOffersResModel.data.reversed.toList();
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Future<bool> acceptDeclineOffer(
      {required bool isAccepted,
      required String orderId,
      required String offerId}) async {
    String url = '/v1/rider/offer/accept-decline';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: {
        'status': isAccepted ? 'Accepted' : 'Declined',
        'offerId': offerId,
        'orderId': orderId,
        'packagePicking': 'packagePicking',
      });
      if (res == null) return false;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        HelperFunc.toast(body['message']?.toString() ??
            'Failed to ${isAccepted ? 'accept' : 'decline'} order');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to ${isAccepted ? 'accept' : 'decline'} order');
    }
    return false;
  }

  @override
  Future<bool> updateTracking({
    required String trackingId,
    required String orderLocation,
  }) async {
    String url = '/orders/$trackingId/';
    try {
      http.Response? res = await requestHelpers.put(url: url, body: {
        'status': orderLocation,
      });
      if (res == null) return false;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to update order status');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to update order status');
    }
    return false;
  }

  @override
  Future<List<OrderDetails>?> getHistory() async {
    String url = '/orders/';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return null;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        print(body['data']?.length);
        OngoingOrdersResModel ongoingOrdersResModel =
            OngoingOrdersResModel.fromJson(body);
        return ongoingOrdersResModel.data;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  @override
  Future<bool> completeOrder(
      {required String trackingId, required String deliveryCode}) async {
    String url = '/orders/$trackingId/complete/';
    try {
      http.Response? res = await requestHelpers
          .post(url: url, body: {'delivery_code': deliveryCode});
      if (res == null) return false;
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to complete order');
      }
    } catch (e) {
      log(e.toString());
      HelperFunc.toast('Failed to complete order');
    }
    return false;
  }

  @override
  Future<bool> userUnreachable({required String orderId}) async {
    String url = '/v1/rider/recipient-unreahable';
    try {
      http.Response? res =
          await requestHelpers.post(url: url, body: {'orderId': orderId});
      if (res == null) return false;
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        var body = jsonDecode(res.body);
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to reach user');
      }
    } catch (e) {
      HelperFunc.toast('Failed to reach user');
      log(e.toString());
    }
    return false;
  }

  @override
  Future<bool> verify2FA(
      {required String orderId,
      required String trackingId,
      required String otp}) async {
    String url = '/v1/rider/2fa';
    try {
      http.Response? res = await requestHelpers.post(url: url, body: {
        'otp': otp,
        // 'orderId': orderId,
        'trackingId': trackingId
      });
      if (res == null) return false;
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        var body = jsonDecode(res.body);
        HelperFunc.toast(body['message']?.toString() ?? 'Failed to verify 2FA');
      }
    } catch (e) {
      HelperFunc.toast('Failed to verify 2FA');
      log(e.toString());
    }
    return false;
  }

  @override
  Future<bool> generate2FA({required String orderId}) async {
    String url = '/v1/rider/generate-otp';
    try {
      http.Response? res =
          await requestHelpers.post(url: url, body: {'orderId': orderId});
      if (res == null) return false;
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      } else {
        var body = jsonDecode(res.body);
        HelperFunc.toast(
            body['message']?.toString() ?? 'Failed to generate 2FA');
      }
    } catch (e) {
      HelperFunc.toast('Failed to generate 2FA');
      log(e.toString());
    }
    return false;
  }

  @override
  Future<List<ChatTextModel>> getChats({required String roomId}) async {
    String url = '/v1/chat/$roomId';
    try {
      http.Response? res = await requestHelpers.get(url: url);
      if (res == null) return [];
      var body = jsonDecode(res.body);
      if (res.statusCode == 200 || res.statusCode == 201) {
        ChatTextModelRes chatModelRes = ChatTextModelRes.fromJson(body);
        return chatModelRes.data;
      }
    } catch (e) {
      log(e.toString());
    }
    return [];
  }
}
