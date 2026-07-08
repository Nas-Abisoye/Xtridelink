import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/network/api_result.dart';
import 'package:xtridelink/core/network/http_service.dart';
import 'package:xtridelink/data/source/remote/base_remote_source.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/data/source/remote/model/order/get_order_details_response.dart';
import 'package:xtridelink/data/source/remote/model/order/list_orders_response.dart';
import 'package:xtridelink/data/source/remote/model/order/payment_account_response/payment_account_response.dart';
import 'package:xtridelink/domain/params/order/order_params.dart';
import 'package:xtridelink/injector.dart';

class OrderEndpoints {
  static const String orders = '/orders/';
}

@Injectable()
class OrderRemoteDatasource extends BaseRemoteSource {
  Future<ApiResult<ListOrdersResponse>> getOrders() async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response =
          await client.get<Map<String, dynamic>>(OrderEndpoints.orders);

      return ApiResult.success(
          data: ListOrdersResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<CreateOrderResponse>> createOrder(OrderParams params) async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        OrderEndpoints.orders,
        data: params.toMap(),
      );

      return ApiResult.success(
          data: CreateOrderResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<GetOrderDetailsResponse>> getOrderDetails(
      String orderId) async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.get<Map<String, dynamic>>(
        '${OrderEndpoints.orders}$orderId/',
      );

      return ApiResult.success(
          data: GetOrderDetailsResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<CreateOrderResponse>> cancelOrder(String orderId) async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        '${OrderEndpoints.orders}$orderId/cancel/',
      );

      return ApiResult.success(
          data: CreateOrderResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<CreateOrderResponse>> updateOrder(String orderId,
      {required OrderParams params}) async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.put<Map<String, dynamic>>(
        '${OrderEndpoints.orders}$orderId/',
        data: params.toMap(),
      );

      return ApiResult.success(
          data: CreateOrderResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<GetOrderDetailsResponse>> searchDriver(
      String trackingId) async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        '${OrderEndpoints.orders}$trackingId/search-driver/',
      );

      return ApiResult.success(
          data: GetOrderDetailsResponse.fromMap(response.data!));
    });
  }

  Future<ApiResult<PaymentAccountResponse>> generatePaymentAccount(
      String trackingId) async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.post<Map<String, dynamic>>(
        '/wallets/orders/$trackingId/payment/',
        data: {'payment_timing': 'pre_payment'},
      );

      return ApiResult.success(
          data: PaymentAccountResponse.fromJson(response.data!));
    });
  }

  Future<ApiResult<bool>> checkPayemtStatus(String trackingId) async {
    return run(() async {
      final client = getIt<HttpService>().client(requireAuth: true);
      final response = await client.get<Map<String, dynamic>>(
        '/wallets/orders/$trackingId/payment-status/',
      );
      final completed = response.data?['data']['payment_completed'] ?? false;
      return ApiResult.success(data: completed);
    });
  }
}
