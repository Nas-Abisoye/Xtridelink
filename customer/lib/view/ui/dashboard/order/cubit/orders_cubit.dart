import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/base/process_state.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/core/services/socket/index.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/model/api/location_prediction.dart';
import 'package:xtridelink/domain/model/api/riders.dart';
import 'package:xtridelink/domain/params/order/order_params.dart';
import 'package:xtridelink/domain/repository/order_repository.dart';
import 'package:xtridelink/injector.dart';

part 'orders_state.dart';

enum OrderNegotiationStatus {
  initial,
  searchingRider,
  noRiderFound,
  ridersFound,
}

@Injectable()
class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._orderRepository) : super(OrdersState.initial());

  final socketService = getIt<SocketService>();

  StreamSubscription<SocketStatus>? _socketConnectionSubscription;
  StreamSubscription<Map<String, dynamic>>? _messagesSubscription;

  final OrderRepository _orderRepository;

  void selectViewOrderState(ViewOrdersByStatus status) {
    emit(state.copyWith(ordersByStatus: status));
    getOrders();
  }

  Future<void> getOrders() async {
    emit(state.copyWith(orders: ProcessState.loading()));
    final response = await _orderRepository.getOrders();
    response.when(
      success: (data) {
        emit(state.copyWith(orders: ProcessState.success(data.data ?? [])));
      },
      failure: (error) {
        emit(state.copyWith(orders: ProcessState.error(error)));
      },
    );
  }

  void setOrderDetails(
      {required String title,
      required OrderState orderStatus,
      required OrderType orderType,
      required LocationData pickupLocation,
      required LocationData deliveryLocation,
      required DeliveryType deliveryType,
      required PackageType packageType,
      required VehicleType vehicleType}) {
    emit(
      state.copyWith(
        orderParams: OrderParams(
          packageType: packageType,
          pickupAddress: pickupLocation.address,
          pickupLatitude: pickupLocation.latitude.toString(),
          pickupLongitude: pickupLocation.longitude.toString(),
          deliveryAddress: deliveryLocation.address,
          deliveryLatitude: deliveryLocation.latitude.toString(),
          deliveryLongitude: deliveryLocation.longitude.toString(),
          deliveryType: deliveryType,
          vehicleType: vehicleType,
          orderType: orderType,
        ),
      ),
    );
    Future.delayed(Duration(seconds: 1)).then((_) => globalNavigateTo(
        route: Routes.recipientDet, arguments: state.orderParams));
  }

  void addEditRecipient({
    required String name,
    required String email,
    required String phone,
    required String comment,
  }) {
    emit(state.copyWith(
      orderParams: state.orderParams.copyWith(
        recipientName: name,
        recipientEmail: email,
        recipientPhone: phone,
        deliveryNotes: comment,
      ),
    ));

    _createOrder();
  }

  Future<void> _createOrder() async {
    HelperFunc.showLoader();
    emit(state.copyWith(createEditOrderResponse: ProcessState.loading()));
    final response = await _orderRepository.createOrder(state.orderParams);
    response.when(
      success: (data) {
        emit(state.copyWith(
          createEditOrderResponse: ProcessState.success(data.message),
          negotiatingOrder: data.data,
          negotiationStatus: OrderNegotiationStatus.searchingRider,
        ));

        getOrders();

        if (data.data?.trackingId != null) {
          globalPopUntil(Routes.base);
          globalNavigateTo(route: Routes.selectDriver);
          _searchForDriver(data.data!.trackingId!);
        }
      },
      failure: (error) {
        globalPop();
        emit(
            state.copyWith(createEditOrderResponse: ProcessState.error(error)));
        HelperFunc.logger('${error.errorResponse?.message}');
        HelperFunc.toast(error.errorResponse?.message ?? 'An error occurred');
      },
    );
  }

  void resumePendingOrder(OrderDetails order) {
    emit(state.copyWith(
      negotiatingOrder: order,
    ));

    _searchForDriver(order.trackingId!);
  }

  Future<void> _searchForDriver(String trackingId) async {
    // HelperFunc.showLoader();
    _socketConnectionSubscription = null;
    _socketConnectionSubscription =
        socketService.connectionStatus.listen((status) {
      switch (status) {
        case SocketStatus.connected:
          _messagesSubscription = null;
          _messagesSubscription = socketService.messages.listen((message) {
            final event = message['event'] as String;
            switch (event) {
              case 'authenticated':
                break;
              case 'no_drivers':
              case 'no_bids':
                // globalPop();
                emit(state.copyWith(
                    negotiationStatus: OrderNegotiationStatus.noRiderFound));
                break;
              case 'riders_available':
                // globalPop();
                final riders = (message['bids'] as List<dynamic>)
                    .map((e) => RiderData.fromJson(e));

                emit(state.copyWith(
                    availableRiders: riders.toList(),
                    negotiationStatus: OrderNegotiationStatus.ridersFound));
                break;
              case 'price_accepted':
                globalReplaceWith(route: Routes.offerPlacedAccepted);
                // trackOrder(trackingId: trackingId);
                getOrders();
              case 'price_rejected':
                globalReplaceWith(route: Routes.offerPlacedRejected);
              default:
            }
          });
          break;
        case SocketStatus.disconnected:
          break;
        case SocketStatus.reconnecting:
          break;
      }
    });

    socketService.connect(trackingId);
  }

  void saveDraft() {}

  void cancelOrder() async {
    HelperFunc.showLoader();
    final orderId = state.negotiatingOrder?.trackingId;
    if (orderId != null) {
      final response = await _orderRepository.cancelOrder(orderId);
      response.when(success: (data) {
        emit(state.copyWith(negotiatingOrder: OrderDetails.empty()));
        getOrders();
        globalPop();
        globalPop();
      }, failure: (error) {
        globalPop();
        HelperFunc.logger('${error.errorResponse?.message}');
        HelperFunc.toast(error.errorResponse?.message ?? 'An error occurred');
      });
    }
  }

  void rateRider({required String riderId, required Rating rating}) {}

  void setLiveTracking(bool bool) {}

  void clearCreateOrderData() {}

  void checkPaymentStatus() async {
    HelperFunc.showLoader();
    final trackingId = state.negotiatingOrder!.trackingId!;
    final response = await _orderRepository.checkPayemtStatus(trackingId);
    response.when(success: (data) {
      if (data) {
        getOrders();
        emit(state.copyWith(
            negotiatingOrder:
                state.negotiatingOrder?.copyWith(status: 'payment_confirmed')));
        globalPop();
        globalReplaceWith(route: Routes.orderPlacedSuccess);
      } else {
        globalPop();
        HelperFunc.toast('Payment is yet to be received!!');
      }
    }, failure: (error) {
      globalPop();
      HelperFunc.logger('${error.errorResponse?.message}');
      HelperFunc.toast(error.errorResponse?.message ?? 'An error occurred');
    });
  }

  void researchRiders() {
    socketService.searchRiders();
    emit(state.copyWith(
        negotiationStatus: OrderNegotiationStatus.searchingRider,
        availableRiders: []));
  }

  void trackOrder({required String trackingId}) async {
    late OrderDetails trackingOrder;
    emit(state.copyWith(activeOrder: ProcessState.loading()));
    HelperFunc.showLoader();
    final order = await _orderRepository.getOrderDetails(trackingId);
    order.maybeWhen(
      orElse: () {},
      success: (data) {
        trackingOrder = data.data!;
        globalPop();
      },
      failure: (error) {
        emit(state.copyWith(activeOrder: ProcessState.error(error)));
        globalPop();
      },
    );
    emit(state.copyWith(activeOrder: ProcessState.success(trackingOrder)));
    _socketConnectionSubscription = null;
    _socketConnectionSubscription =
        socketService.connectionStatus.listen((status) {
      switch (status) {
        case SocketStatus.connected:
          _messagesSubscription = null;
          _messagesSubscription = socketService.messages.listen((message) {
            final event = message['event'] as String;
            switch (event) {
              case 'authenticated':
                // globalPop();
                break;
              case 'order_status':
                getOrders();
                break;
              default:
            }
          });
          break;
        case SocketStatus.disconnected:
          break;
        case SocketStatus.reconnecting:
          break;
      }
    });

    socketService.connect(trackingId);
  }

  @override
  Future<void> close() {
    _socketConnectionSubscription?.cancel();
    _messagesSubscription?.cancel();
    return super.close();
  }

  Future<void> createOffer({required num amount}) async {
    socketService.proposePrice(amount.toDouble());
  }

  Future<void> generatePaymentAccount() async {
    HelperFunc.showLoader();
    final response = await _orderRepository
        .generatePaymentAccount(state.negotiatingOrder!.trackingId!);
    response.when(
      success: (data) {
        globalPop();

        if (data.data != null) {
          globalPop();
          globalNavigateTo(route: Routes.onlinePayment, arguments: data.data);
        }
      },
      failure: (error) {
        globalPop();
      },
    );
  }

  void clearData() {}
}
