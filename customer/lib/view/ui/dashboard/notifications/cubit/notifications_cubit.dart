import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/base/process_state.dart';
import 'package:xtridelink/domain/model/api/notifications.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';

part 'notifications_state.dart';

@Injectable()
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._authenticationRepository)
      : super(NotificationsState.initial());

  final AuthenticationRepository _authenticationRepository;

  Future<void> loadNotifications() async {
    emit(state.copyWith(notifications: ProcessState.loading()));
    final result = await _authenticationRepository.getUserNotifications();
    result.when(success: (data) {
      emit(state.copyWith(
          notifications: ProcessState.success(data.data!.results ?? [])));
    }, failure: (error) {
      emit(state.copyWith(notifications: ProcessState.error(error)));
    });
  }

  void clearNotifications() {
    emit(
        state.copyWith(notifications: ProcessState.init(<NotificationData>[])));
  }
}
