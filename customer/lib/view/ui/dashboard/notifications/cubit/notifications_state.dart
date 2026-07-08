part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final ProcessState<List<NotificationData>> notifications;

  const NotificationsState._({
    required this.notifications,
  });

  NotificationsState.initial() : this._(notifications: ProcessState.init([]));

  NotificationsState copyWith({
    ProcessState<List<NotificationData>>? notifications,
  }) {
    return NotificationsState._(
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object> get props => [notifications];
}
