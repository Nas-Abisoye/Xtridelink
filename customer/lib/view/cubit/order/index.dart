// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:xtridelink/core/constants/enumerations.dart';
// import 'package:xtridelink/core/constants/extensions.dart';
// import 'package:xtridelink/core/constants/helpers.dart';
// import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
// import 'package:xtridelink/domain/model/api/location_prediction.dart';
// import 'package:xtridelink/domain/model/api/order_det.dart';
// import 'package:xtridelink/domain/model/api/puller_bank.dart';
// import 'package:xtridelink/domain/model/api/riders.dart';
// import 'package:xtridelink/core/services/api/order/index.dart';
// import 'package:xtridelink/core/services/storage/index.dart';
// import 'package:injectable/injectable.dart';
// import '../../../domain/model/api/track.dart';
// import '../../../core/services/navigation/index.dart';
// import '../../../core/services/navigation/routes.dart';
// import '../../../core/services/socket/index.dart';
// import '../../ui/dashboard/order/components/payment_options.dart';
// import '../../ui/dashboard/order/pages/order_details.dart';
// import '../chat/index.dart';

// class OrdersState {
//   bool isLoading;
//   OrderDetails? orderDet;
//   num? amount;
//   List<OrderDetails>? orders;
//   List<RiderData>? riderList;
//   TrackingData? trackingData;
//   bool liveTracking;
//   OrdersState(
//       {required this.isLoading,
//       required this.orderDet,
//       required this.orders,
//       required this.trackingData,
//       required this.riderList,
//       required this.liveTracking,
//       required this.amount});
// }

// @Injectable()
// class OrdersCubit extends Cubit<OrdersState> {
//   OrderApiServiceImpl orderApiServiceImpl;
//   NavigationServiceImpl navigationServiceImpl;
//   SocketService socketService;
//   StorageServiceImpl storageServiceImpl;
//   OrdersCubit(
//       {required this.orderApiServiceImpl,
//       required this.socketService,
//       required this.storageServiceImpl,
//       required this.navigationServiceImpl})
//       : super(OrdersState(
//             trackingData: null,
//             isLoading: false,
//             liveTracking: false,
//             orderDet: null,
//             amount: null,
//             orders: null,
//             riderList: null));

//   void _emitState() {
//     emit(OrdersState(
//         isLoading: state.isLoading,
//         orderDet: state.orderDet,
//         amount: state.amount,
//         liveTracking: state.liveTracking,
//         riderList: state.riderList,
//         trackingData: state.trackingData,
//         orders: state.orders));
//   }

//   void _setLoading(bool value) {
//     state.isLoading = value;
//     _emitState();
//   }

//   void setLiveTracking(bool value) {
//     state.liveTracking = value;
//     _emitState();
//   }

//   Future<void> getOrders() async {
//     _setLoading(true);
//     state.orders = await orderApiServiceImpl.getOrders() ?? state.orders;
//     _setLoading(false);
//   }

//   void createUpdateOrder(
//       {required String title,
//       required OrderState orderStatus,
//       required OrderType orderType,
//       required LocationData pickupLocation,
//       required LocationData deliveryLocation,
//       required String deliveryType,
//       // required String alertMethod,
//       // required bool has2faCode,
//       required String packageType,
//       required VehicleType vehicleType}) async {
//     HelperFunc.showLoader();
//     if (state.orderDet != null) {
//       // socketService.offEvent('orderMessage-${state.orderDet?.userId}');
//     }
//     OrderDetails? orderDet = await orderApiServiceImpl
//         .createUpdateOrder(orderId: state.orderDet?.id, map: {
//       'title': title,
//       ...(state.orderDet != null ? {'orderId': state.orderDet!.id} : {}),
//       'type': orderType.name.capitalizeFirstLetter,
//       'location_pickup': pickupLocation.address,
//       'location_delivery': deliveryLocation.address,
//       'delivery_location': {
//         'latitude': deliveryLocation.latitude.toString(),
//         'longitude': deliveryLocation.longitude.toString()
//       },
//       'pickup_location': {
//         'latitude': pickupLocation.latitude.toString(),
//         'longitude': pickupLocation.longitude.toString()
//       },
//       'delivery_type': deliveryType,
//       // 'alertMethod': alertMethod,
//       // 'has2faCode': has2faCode,
//       'package_type': packageType.toLowerCase(),
//       'payment_method': 'CASH',
//       'vehicle_type': vehicleType.name,
//     });
//     navigationServiceImpl.pop();
//     if (orderDet != null) {
//       orderDet.recipient = state.orderDet?.recipient;
//       navigationServiceImpl.navigateTo(Routes.recipientDet,
//           arguments: orderDet);
//       state.orderDet = orderDet;
//       _orderRequest(
//         userId: orderDet.userId,
//         location: pickupLocation.address,
//         longitude: pickupLocation.longitude.toString(),
//         latitude: pickupLocation.latitude.toString(),
//         vehicleType: vehicleType.name.toUpperCase(),
//         orderId: orderDet.id,
//       );
//     }
//   }

//   void updatePayment(
//       {required String? paymentMethod, VoidCallback? onSuccess}) async {
//     HelperFunc.showLoader();
//     OrderDetails? orderDet = await orderApiServiceImpl
//         .updateOrder(orderId: state.orderDet?.id ?? '', map: {
//       'orderId': state.orderDet?.id,
//       ...(paymentMethod != null ? {'paymentMethod': paymentMethod} : {})
//     });
//     navigationServiceImpl.pop();
//     if (orderDet != null) {
//       state.orderDet?.paymentMethod = orderDet.paymentMethod;
//       if (state.orders?.any((element) => element.id == orderDet.id) == true) {
//         state.orders
//             ?.firstWhere((element) => element.id == orderDet.id)
//             .paymentMethod = orderDet.paymentMethod;
//         _emitState();
//       }
//       getOrders();
//       if (onSuccess != null) onSuccess();
//     }
//   }

//   void addEditRecipient(
//       {required String name,
//       required String email,
//       required String phone,
//       required String comment}) async {
//     HelperFunc.showLoader();
//     OrderRecipientData? recipient =
//         await orderApiServiceImpl.addOrderRecipient(map: {
//       'orderId': state.orderDet?.id ?? '',
//       ...(state.orderDet?.recipient != null
//           ? {'orderReciepientId': state.orderDet?.recipient?.id}
//           : {}),
//       'name': name,
//       ...(email.isNotEmpty ? {'email': email} : {}),
//       'phone': phone,
//       ...(comment.isNotEmpty ? {'comment': comment} : {})
//     });
//     navigationServiceImpl.pop();
//     if (recipient != null) {
//       navigationServiceImpl.navigateTo(Routes.selectDriver);
//       state.orderDet?.recipient = recipient;
//     }
//   }

//   Future<void> createOffer(
//       {required num amount, required String receiverId}) async {
//     // _makeOffer(
//     //     amount: amount,
//     //     riderId: receiverId,
//     //     orderId: state.orderDet?.id ?? '',
//     //     senderId: state.orderDet?.userId ?? '');
//     // state.amount = amount;
//     // state.orderDet?.finalPrice = amount;
//   }

//   void researchRiders() {
//     // socketService.offEvent('general-error-${state.orderDet?.userId}');
//     // socketService.offEvent('orderMessage-${state.orderDet?.userId}');
//     // _orderRequest(
//     //     userId: state.orderDet?.userId ?? '',
//     //     location: state.orderDet?.locationPickup ?? '',
//     //     longitude: state.orderDet?.pickupLocation.longitude.toString() ?? '',
//     //     latitude: state.orderDet?.pickupLocation.latitude.toString() ?? '',
//     //     vehicleType: state.orderDet?.vehicleType ?? '',
//     //     orderId: state.orderDet?.id ?? '');
//   }

//   void _orderRequest(
//       {required String userId,
//       required String location,
//       required String longitude,
//       required String latitude,
//       required String vehicleType,
//       required String orderId}) async {
//     var orderRequestData = {
//       'id': userId,
//       'token': await storageServiceImpl.getToken(),
//       'vehicleType': vehicleType,
//       'data': {
//         'location': location,
//         'longitude': longitude,
//         'latitude': latitude,
//         'orderId': orderId,
//         'vehicleType': vehicleType
//       },
//     };
//     // socketService.socket.on('general-error-$userId', (data) {
//     //   HelperFunc.logger('general-error: ${jsonEncode(data)}');
//     //   HelperFunc.toast(data['message'] ?? data['error'] ?? 'An error occurred');
//     // });
//     // socketService.emitEvent('order-request', orderRequestData);
//     // socketService.socket.on('orderMessage-$userId', (data) {
//     //   HelperFunc.logger('orderMessage: ${jsonEncode(data)}');
//     //   AvailableRidersModel availableRidersModel =
//     //       AvailableRidersModel.fromJson(data);
//     //   state.riderList = availableRidersModel.data;
//     //   _emitState();
//     // });
//   }

//   void _makeOffer({
//     required num amount,
//     required String riderId,
//     required String orderId,
//     required String senderId,
//   }) async {
//     // if (!socketService.socket.connected) {
//     //   HelperFunc.toast('Please check your internet connection');
//     //   return;
//     // }
//     var makeOfferData = {
//       'id': senderId,
//       'token': await storageServiceImpl.getToken(),
//       'data': {
//         'senderId': senderId,
//         'orderId': orderId,
//         'riderId': riderId,
//         'amount': amount
//       }
//     };
//     // socketService.emitEvent('make-offer', makeOfferData);
//   }

//   void listenToSocket() async {
//     final String userId = await storageServiceImpl.getUserId();
//     HelperFunc.logger('trackingUpdated-$userId');
//     // socketService.socket.on('trackingUpdated-$userId', (data) {
//     //   HelperFunc.logger('trackingUpdated: ${jsonEncode(data)}');
//     //   OrderTrackData orderTrackData = OrderTrackEventData.fromJson(data).data;
//     //   try {
//     //     state.orders
//     //         ?.firstWhere((element) => element.id == orderTrackData.orderId)
//     //         .trackingId = orderTrackData;
//     //     _emitState();
//     //   } catch (e) {
//     //     getOrders();
//     //   }
//     //   if (orderTrackData.packageDelivered != null) {
//     //     navigationServiceImpl.navigateTo(Routes.packageDelivered,
//     //         arguments: orderTrackData);
//     //     getOrders();
//     //   }
//     // });
//     // socketService.socket.on('notification-$userId', (data) {
//     //   HelperFunc.logger('notification: ${jsonEncode(data)}');
//     //   navigationServiceImpl.navigationKey.currentContext
//     //       ?.read<ChatCubit>()
//     //       .addChatNotification(data?['orderId'] ?? '');
//     // });
//   }

//   void trackOrder({required String trackingId}) async {
//     HelperFunc.showLoader();
//     TrackingData? trackingData =
//         await orderApiServiceImpl.trackOrder(trackingId: trackingId);
//     navigationServiceImpl.pop();
//     state.trackingData = trackingData;
//     if (trackingData != null) {
//       state.trackingData?.order.trackingId = OrderTrackData(
//           id: trackingData.id,
//           orderId: trackingData.orderId,
//           riderId: trackingData.riderId,
//           otp: trackingData.otp,
//           orderLocation: trackingData.orderLocation,
//           packagePicking: trackingData.packagePicking,
//           packagePickedup: trackingData.packagePickedup,
//           packageOnTransit: trackingData.packageOnTransit,
//           packageDelivered: trackingData.packageDelivered);
//     }
//     _emitState();
//   }

//   void generatePaymentAccount() async {
//     HelperFunc.showLoader();
//     PullerBank? pullerBank = await orderApiServiceImpl.generatePaymentAccount(
//         orderId: state.orderDet?.id ?? '',
//         amount: state.amount ?? state.orderDet?.amount ?? 0);
//     navigationServiceImpl.pop();
//     if (pullerBank != null) {
//       navigationServiceImpl.pop();
//       navigationServiceImpl.navigateTo(Routes.onlinePayment,
//           arguments: pullerBank);
//     }
//   }

//   void verifyPayment({required String reference}) async {
//     HelperFunc.showLoader();
//     String? status =
//         await orderApiServiceImpl.verifyPayment(reference: reference);
//     navigationServiceImpl.pop();
//     _handlePaymentAfterMath(status);
//   }

//   void setPaymentVerification({required String reference}) {
//     var verifyPaymentData = {
//       'userId': state.orderDet?.userId ?? '',
//       'reference': reference
//     };
//     // socketService.emitEvent('getTransactionStatus', verifyPaymentData);
//     // socketService.socket.on('transactionStatus', (data) {
//     //   HelperFunc.logger('transactionStatus: ${jsonEncode(data)}');
//     //   print(data?['status']);
//     //   if (data?['status'] != 'COMPLETED' && data?['status'] != 'FAILED') {
//     //     socketService.emitEvent('getTransactionStatus', verifyPaymentData);
//     //     return;
//     //   }
//     //   _handlePaymentAfterMath(data?['status'] ?? '');
//     //   socketService.offEvent('transactionStatus');
//     // });
//   }

//   void _handlePaymentAfterMath(String? status) {
//     if (status?.toUpperCase() == 'PENDING') {
//       HelperFunc.toast('Transaction pending');
//     } else if (status?.toUpperCase() == 'COMPLETED') {
//       navigationServiceImpl.replaceWith(Routes.orderPlacedSuccess);
//       updatePayment(paymentMethod: 'ONLINE');
//     } else if (status?.toUpperCase() == 'FAILED') {
//       HelperFunc.toast('Payment failed');
//     } else {
//       HelperFunc.toast('Couldn\'t verify payment');
//     }
//   }

//   void rateRider({required String riderId, required Rating rating}) async {
//     HelperFunc.showLoader();
//     bool success = await orderApiServiceImpl.rateRider(
//         riderId: riderId, rating: rating.name.toUpperCase());
//     navigationServiceImpl.pop();
//     if (success) {
//       navigationServiceImpl.pop();
//       HelperFunc.toast(
//           'Rider rated ${Rating.values.indexOf(rating)} star${rating == Rating.one ? '' : 's'}');
//     }
//   }

//   void cancelOrder() async {
//     HelperFunc.showLoader();
//     bool success = await orderApiServiceImpl.cancelOrder(
//       orderId: state.orderDet?.id ?? '',
//     );
//     navigationServiceImpl.popUntil(Routes.base);
//     if (success) {
//       state.orderDet?.status = 'Canceled';
//       if (state.orderDet != null) {
//         state.orders = [
//           state.orderDet!,
//           ...(state.orders ?? [])
//               .where((element) => element.id != state.orderDet?.id)
//         ];
//       }
//     }
//     clearCreateOrderData();
//   }

//   void saveDraft() async {
//     if (state.orderDet == null) return;
//     state.orders = [
//       state.orderDet!,
//       ...(state.orders ?? [])
//           .where((element) => element.id != state.orderDet?.id)
//     ];
//     _emitState();
//     navigationServiceImpl.popUntil(Routes.base);
//     clearCreateOrderData();
//   }

//   void continueDraftCreation(OrderDetails orderDet) async {
//     state.orderDet = orderDet;
//     navigationServiceImpl.navigateTo(Routes.provideOrderDet,
//         arguments: PackageOrderParam(
//             packageType: switch (orderDet.packageType) {
//               'PARCEL' => PackageType.parcel,
//               'GROCERIES' => PackageType.groceries,
//               _ => null,
//             },
//             orderType:
//                 orderDet.type == 'SENDING' ? OrderType.send : OrderType.recieve,
//             generalPackageType: null,
//             orderDet: orderDet));
//     _emitState();
//   }

//   void confirmPayment(OrderDetails orderDet) async {
//     state.orderDet = orderDet;
//     state.amount = orderDet.finalPrice!.toDouble();
//     HelperFunc.showFittedBottomSheet(
//         isDismissible: false,
//         showBackButton: false,
//         context: buildContext,
//         child: const PaymentOptionsSheet());
//     _emitState();
//   }

//   void clearCreateOrderData() {
//     emit(OrdersState(
//         isLoading: state.isLoading,
//         orderDet: null,
//         liveTracking: state.liveTracking,
//         orders: state.orders,
//         trackingData: state.trackingData,
//         riderList: null,
//         amount: null));
//   }

//   void setTrackingData({required OrderTrackData trackingData}) async {
//     if (trackingData.id.isNotEmpty) {
//       state.orderDet?.trackingId = trackingData;
//       state.orderDet?.otp = trackingData.otp;
//       if (state.orderDet?.trackingId != null) {
//         state.orders = [
//           if (state.orderDet != null) state.orderDet!,
//           ...state.orders ?? []
//         ];
//         _emitState();
//       }
//     }
//     // socketService.offEvent('orderMessage-${state.orderDet?.userId}');
//     // socketService.offEvent('general-error-${state.orderDet?.userId}');
//   }

//   void clearData() {
//     emit(OrdersState(
//         isLoading: false,
//         liveTracking: false,
//         orderDet: null,
//         orders: null,
//         trackingData: null,
//         riderList: null,
//         amount: null));
//   }
// }
