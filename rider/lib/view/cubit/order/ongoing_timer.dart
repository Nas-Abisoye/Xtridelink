import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/services/api/order/index.dart';
import '../../../core/services/navigation/index.dart';

class OngoingTimerState {
  Map<String, Duration> timers;
  OngoingTimerState({required this.timers});
}

class OngoingTimerCubit extends Cubit<OngoingTimerState> {
  OrderApiServiceImpl orderApiServiceImpl;
  NavigationServiceImpl navigationServiceImpl;

  OngoingTimerCubit(
      {required this.orderApiServiceImpl, required this.navigationServiceImpl})
      : super(OngoingTimerState(timers: {}));

  Future<bool> _generate2FA({required String orderId}) async {
    HelperFunc.showLoader();
    bool success = await orderApiServiceImpl.generate2FA(orderId: orderId);
    navigationServiceImpl.pop();
    return success;
  }

  Future<bool> setTimer(String id) async {
    if (state.timers.containsKey(id) && (state.timers[id]?.inSeconds ?? 0) > 0)
      return true;
    bool success = await _generate2FA(orderId: id);
    if (!success) return false;
    state.timers[id] = const Duration(minutes: 20);
    Timer? timerT;
    timerT = Timer.periodic(const Duration(seconds: 1), (timer) {
      state.timers[id] = Duration(seconds: state.timers[id]!.inSeconds - 1);
      if (state.timers[id]!.inSeconds <= 0) {
        timer.cancel();
        timerT?.cancel();
        state.timers.remove(id);
      }
      emit(OngoingTimerState(timers: state.timers));
    });
    return true;
  }
}
