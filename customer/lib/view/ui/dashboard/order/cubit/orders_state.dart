part of 'orders_cubit.dart';

enum ViewOrdersByStatus {
  all('All'),
  onTransit('On Transit'),
  delivered('Delivered'),
  cancelled('Cancelled');

  final String title;

  const ViewOrdersByStatus(this.title);
}

class OrdersState extends Equatable {
  final ProcessState<List<OrderDetails>> orders;
  final ProcessState<OrderDetails> trackingOrder;
  final OrderDetails? negotiatingOrder;
  final ViewOrdersByStatus ordersByStatus;
  final OrderParams orderParams;
  final ProcessState<String?> createEditOrderResponse;
  final bool liveTracking;
  final List<RiderData> availableRiders;
  final OrderNegotiationStatus negotiationStatus;

  const OrdersState._({
    required this.orders,
    required this.trackingOrder,
    required this.ordersByStatus,
    required this.negotiatingOrder,
    required this.orderParams,
    required this.createEditOrderResponse,
    required this.liveTracking,
    required this.availableRiders,
    required this.negotiationStatus,
  });

  OrdersState.initial()
      : this._(
          orders: ProcessState.init([]),
          trackingOrder: ProcessState.init(OrderDetails.empty()),
          ordersByStatus: ViewOrdersByStatus.all,
          orderParams: OrderParams(),
          createEditOrderResponse: ProcessState.init(null),
          liveTracking: false,
          negotiatingOrder: null,
          availableRiders: [],
          negotiationStatus: OrderNegotiationStatus.initial,
        );

  OrdersState copyWith({
    ProcessState<List<OrderDetails>>? orders,
    ProcessState<OrderDetails>? activeOrder,
    ViewOrdersByStatus? ordersByStatus,
    OrderParams? orderParams,
    ProcessState<String?>? createEditOrderResponse,
    bool? liveTracking,
    OrderDetails? negotiatingOrder,
    List<RiderData>? availableRiders,
    OrderNegotiationStatus? negotiationStatus,
  }) {
    return OrdersState._(
      orders: orders ?? this.orders,
      trackingOrder: activeOrder ?? this.trackingOrder,
      ordersByStatus: ordersByStatus ?? this.ordersByStatus,
      orderParams: orderParams ?? this.orderParams,
      createEditOrderResponse:
          createEditOrderResponse ?? this.createEditOrderResponse,
      liveTracking: liveTracking ?? this.liveTracking,
      negotiatingOrder: negotiatingOrder ?? this.negotiatingOrder,
      availableRiders: availableRiders ?? this.availableRiders,
      negotiationStatus: negotiationStatus ?? this.negotiationStatus,
    );
  }

  @override
  List<Object?> get props => [
        orders,
        trackingOrder,
        ordersByStatus,
        orderParams,
        createEditOrderResponse,
        liveTracking,
        negotiatingOrder,
        availableRiders,
        negotiationStatus,
      ];
}
