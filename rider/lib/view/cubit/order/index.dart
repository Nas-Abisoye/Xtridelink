import 'dart:async';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xtridelink_driver/core/constants/debouncer.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/services/notification/index.dart';
import 'package:xtridelink_driver/domain/model/api/customer_price_proposal.dart';
import 'package:xtridelink_driver/domain/model/api/new_order_bid_request.dart';
import 'package:xtridelink_driver/domain/model/api/offers.dart';
import 'package:xtridelink_driver/domain/model/api/ongoing_orders.dart';
import 'package:xtridelink_driver/core/services/api/order/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/gen/assets.gen.dart';
import 'package:xtridelink_driver/view/cubit/chat/index.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import 'package:xtridelink_driver/view/cubit/wallet/index.dart';
import '../../../core/constants/enumerations.dart';
import '../../../core/services/location/index.dart';
import '../../../core/services/navigation/index.dart';
import '../../../core/services/socket/index.dart';
import '../../../core/services/storage/index.dart';

class OrderFlowState {
  bool isLoading;
  List<OrderDetails>? ongoingOrders;
  List<OrderDetails>? orderHistory;
  List<OfferData>? allOffers;
  NewOrderBidRequest? bidRequest;
  CustomerPriceProposal? customerPriceProposal;
  List<String> newNotifications;
  RiderOrderTab orderTab;
  OrderFlowState({
    required this.isLoading,
    required this.allOffers,
    required this.orderTab,
    required this.orderHistory,
    required this.newNotifications,
    required this.ongoingOrders,
    required this.bidRequest,
    required this.customerPriceProposal,
  });
}

class OrderFlowCubit extends Cubit<OrderFlowState> {
  OrderApiServiceImpl orderApiServiceImpl;
  NavigationServiceImpl navigationServiceImpl;
  SocketService socketService;
  StorageServiceImpl storageServiceImpl;
  LocationMapService locationMapService;

  OrderFlowCubit(
      {required this.orderApiServiceImpl,
      required this.socketService,
      required this.storageServiceImpl,
      required this.locationMapService,
      required this.navigationServiceImpl})
      : super(OrderFlowState(
          isLoading: false,
          allOffers: null,
          ongoingOrders: null,
          orderHistory: null,
          newNotifications: [],
          orderTab: RiderOrderTab.pending,
          bidRequest: null,
          customerPriceProposal: null,
        ));

  final _debouncer = Debouncer();

  StreamSubscription<SocketStatus>? _notifConnectionSubscription;
  StreamSubscription<SocketStatus>? _ordersConnectionSubscription;

  void _emitState() {
    emit(OrderFlowState(
      isLoading: state.isLoading,
      ongoingOrders: state.ongoingOrders,
      orderHistory: state.orderHistory,
      allOffers: state.allOffers,
      newNotifications: state.newNotifications,
      orderTab: state.orderTab,
      bidRequest: state.bidRequest,
      customerPriceProposal: state.customerPriceProposal,
    ));
  }

  void _setLoading(bool value) {
    state.isLoading = value;
    _emitState();
  }

  void submitBid({required String orderId, required double amount}) {
    socketService.submitBid(orderId, amount);
    clearBidRequest();
    HelperFunc.toast('Bid submitted');
  }

  void clearBidRequest() {
    state.bidRequest = null;
    state.customerPriceProposal = null;
    _emitState();
  }

  void setOrderTab(RiderOrderTab value) {
    state.orderTab = value;
    _emitState();
  }

  Future<void> getAllOffers() async {
    _setLoading(true);
    state.allOffers =
        await orderApiServiceImpl.getAllOffers() ?? state.allOffers;
    _setLoading(false);
  }

  Future<void> getOngoingOrders() async {
    _setLoading(true);
    state.ongoingOrders =
        await orderApiServiceImpl.getOngoingOrders() ?? state.ongoingOrders;
    _setLoading(false);
  }

  Future<OrderDetails?> getOrder({required OrderDetails order}) async {
    HelperFunc.showLoader();
    OrderDetails? orderDetails =
        await orderApiServiceImpl.getOrder(order.trackingId!);
    navigationServiceImpl.pop();
    if (orderDetails == null) return null;

    if (orderDetails.paymentCompletedAt == null) {
      HelperFunc.toast('Payment is not completed');
    }
    _emitState();
    return orderDetails;
  }

  void acceptDeclineOffer({
    required bool isAccepted,
    String? orderId,
    String? userId,
    required String offerId,
  }) async {
    if (isAccepted) {
      socketService.acceptPrice(offerId);
    } else {
      socketService.rejectPrice(offerId);
    }

    if (isAccepted) state.orderTab = RiderOrderTab.ongoing;

    state.customerPriceProposal = null;
    _emitState();

    if (isAccepted) getOngoingOrders();
  }

  Future<bool> completeOrder(
      {required String trackingId, required String deliveryCode}) async {
    // HelperFunc.showLoader();
    bool success = await orderApiServiceImpl.completeOrder(
        trackingId: trackingId, deliveryCode: deliveryCode);
    navigationServiceImpl.pop();
    if (success) {
      navigationServiceImpl.navigateTo(Routes.orderCompletedSuccess);
      state.ongoingOrders
          ?.removeWhere((element) => element.trackingId == trackingId);
      _emitState();
      _reloadDetailsOnComplete();
      return true;
    }

    return false;
  }

  void _reloadDetailsOnComplete() {
    getHistory();
    navigationServiceImpl.navigationKey.currentContext!
        .read<WalletCubit>()
        .loadWalletDetails();
    navigationServiceImpl.navigationKey.currentContext!
        .read<ProfileCubit>()
        .getRiderAnalytics();
  }

  Future<bool> userUnreachable({required String orderId}) async {
    HelperFunc.showLoader();
    bool success = await orderApiServiceImpl.userUnreachable(orderId: orderId);
    navigationServiceImpl.pop();
    return success;
  }

  Future<bool> verify2FA(
      {required String orderId,
      required String trackingId,
      required String otp}) async {
    HelperFunc.showLoader();
    bool success = await orderApiServiceImpl.verify2FA(
        orderId: orderId, trackingId: trackingId, otp: otp);
    navigationServiceImpl.pop();
    return success;
  }

  Future<void> getHistory() async {
    _setLoading(true);
    state.orderHistory =
        await orderApiServiceImpl.getHistory() ?? state.orderHistory;
    _setLoading(false);
  }

  void updateOrderStatus(
      {required String trackingId, required String status}) async {
    HelperFunc.showLoader();
    bool success = await orderApiServiceImpl.updateTracking(
        trackingId: trackingId, orderLocation: status);
    navigationServiceImpl.pop();
    if (success) {
      getOngoingOrders();
    }
  }

//clrufv7hi0037mh3xxzx0lb1q
  //clrufv7hi0037mh3xxzx0lb1q
  void clearData() {
    state.ongoingOrders = null;
    state.allOffers = null;
    state.isLoading = false;
    state.orderTab = RiderOrderTab.pending;
    _emitState();
  }

  void listenForNewOrders() async {
    _notifConnectionSubscription = null;
    _notifConnectionSubscription =
        socketService.notificationChannelStatus.listen((status) {
      switch (status) {
        case SocketStatus.connected:
          socketService.notificationMessages.listen((data) {
            HelperFunc.logger('notification: ${jsonEncode(data)}');
            final event = data['event'];
            switch (event) {
              case 'new_order_bid_request':
                final bid = NewOrderBidRequest.fromJson(data);
                state.bidRequest = bid;
                _emitState();
                break;
              case 'customer_price_proposal':
                final proposal = CustomerPriceProposal.fromJson(data);
                HelperFunc.logger(
                    'customer_price_proposal: ${jsonEncode(proposal)}');
                state.customerPriceProposal = proposal;

                _emitState();
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

    socketService.connectToNotificationsChannel();
  }

  void stopListeningForNewOrders() {
    socketService.disconnectFromNotifications();
  }

  @override
  Future<void> close() {
    _notifConnectionSubscription?.cancel();
    _ordersConnectionSubscription?.cancel();
    return super.close();
  }
}
