import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/network/api_result.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/data/source/remote/model/order/get_order_details_response.dart';
import 'package:xtridelink/data/source/remote/model/order/list_orders_response.dart';
import 'package:xtridelink/data/source/remote/model/order/payment_account_response/payment_account_response.dart';
import 'package:xtridelink/data/source/remote/order_remote_datasource.dart';
import 'package:xtridelink/domain/params/order/order_params.dart';
import 'package:xtridelink/domain/repository/order_repository.dart';

@LazySingleton(as: OrderRepository)
class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._orderRemoteDatasource);

  final OrderRemoteDatasource _orderRemoteDatasource;

  @override
  Future<ApiResult<CreateOrderResponse>> createOrder(OrderParams params) {
    return _orderRemoteDatasource.createOrder(params);
  }

  @override
  Future<ApiResult<CreateOrderResponse>> cancelOrder(String orderId) {
    return _orderRemoteDatasource.cancelOrder(orderId);
  }

  @override
  Future<ApiResult<CreateOrderResponse>> updateOrder(String orderId,
      {required OrderParams params}) {
    return _orderRemoteDatasource.updateOrder(orderId, params: params);
  }

  @override
  Future<ApiResult<ListOrdersResponse>> getOrders() {
    return _orderRemoteDatasource.getOrders();
  }

  @override
  Future<ApiResult<GetOrderDetailsResponse>> getOrderDetails(String orderId) {
    return _orderRemoteDatasource.getOrderDetails(orderId);
  }

  @override
  Future<ApiResult<GetOrderDetailsResponse>> searchDriver(String trackingId) =>
      _orderRemoteDatasource.searchDriver(trackingId);

  @override
  Future<ApiResult<PaymentAccountResponse>> generatePaymentAccount(
          String trackingId) =>
      _orderRemoteDatasource.generatePaymentAccount(trackingId);

  @override
  Future<ApiResult<bool>> checkPayemtStatus(String trackingId) =>
      _orderRemoteDatasource.checkPayemtStatus(trackingId);
}
