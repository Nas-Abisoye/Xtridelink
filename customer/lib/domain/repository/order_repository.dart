import 'package:xtridelink/core/network/api_result.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/data/source/remote/model/order/get_order_details_response.dart';
import 'package:xtridelink/data/source/remote/model/order/list_orders_response.dart';
import 'package:xtridelink/data/source/remote/model/order/payment_account_response/payment_account_response.dart';
import 'package:xtridelink/domain/params/order/order_params.dart';

abstract class OrderRepository {
  Future<ApiResult<CreateOrderResponse>> createOrder(OrderParams params);
  Future<ApiResult<GetOrderDetailsResponse>> getOrderDetails(String orderId);

  Future<ApiResult<CreateOrderResponse>> cancelOrder(String orderId);
  Future<ApiResult<CreateOrderResponse>> updateOrder(String orderId,
      {required OrderParams params});
  Future<ApiResult<ListOrdersResponse>> getOrders();

  Future<ApiResult<GetOrderDetailsResponse>> searchDriver(String trackingId);
  Future<ApiResult<PaymentAccountResponse>> generatePaymentAccount(
      String trackingId);
  Future<ApiResult<bool>> checkPayemtStatus(String trackingId);
}
