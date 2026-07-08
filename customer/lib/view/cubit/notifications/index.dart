// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:xtridelink/domain/model/api/notifications.dart';
// import 'package:xtridelink/core/services/api/notification/index.dart';
// import '../../../core/services/navigation/index.dart';

// class NotificationsState {
//   bool isLoading;
//   List<NotificationData>? notifications;
//   NotificationsState({required this.isLoading, required this.notifications});
// }

// class NotificationsCubit extends Cubit<NotificationsState> {
//   NotificationApiServiceImpl notificationApiServiceImpl;
//   NavigationServiceImpl navigationServiceImpl;

//   NotificationsCubit(
//       {required this.notificationApiServiceImpl,
//         required this.navigationServiceImpl})
//       : super(NotificationsState(isLoading: false, notifications: null));

//   void _emitState() {
//     emit(NotificationsState(
//         isLoading: state.isLoading, notifications: state.notifications));
//   }

//   void _setLoading(bool value) {
//     state.isLoading = value;
//     _emitState();
//   }

//   void getNotifications() async {
//     _setLoading(true);
//     state.notifications = await notificationApiServiceImpl.getNotifications() ??
//         state.notifications;
//     _setLoading(false);
//   }

//   void clearData() {
//     state.notifications = null;
//     _emitState();
//   }
// }
