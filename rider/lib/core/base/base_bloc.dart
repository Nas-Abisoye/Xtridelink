import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:xtridelink_driver/core/base/base_event.dart';
import 'package:xtridelink_driver/core/base/base_state.dart';
import 'package:xtridelink_driver/core/network/api_result.dart';

abstract class BaseBloc<E extends BaseEvent, S extends BaseState>
    extends Bloc<E, S> {
  BaseBloc(super.initialState);

  final logger = Logger();

  Future<void> launchUseCase<T>(
    Future<T> Function() futureUseCase, {
    bool showError = true,
    bool showLoading = false,
    void Function()? doOnLoading,
    void Function(T)? doOnSuccess,
    void Function(Object)? doOnError,
  }) async {
    if (!isClosed) doOnLoading?.call();
    if (showLoading && !isClosed) {
      emit(state.copyWith(isLoading: true) as S);
    }

    try {
      final data = await futureUseCase.call();
      if (!isClosed) doOnSuccess?.call(data);
    } catch (e, stack) {
      logger.e(e, stackTrace: stack);
      if (!isClosed) doOnError?.call(e);
      if (showError && !isClosed) {
        if (e is Exception) {
          emit(state.copyWith(exception: e) as S);
        }
      }
    } finally {
      if (showLoading && !isClosed) {
        emit(state.copyWith(isLoading: false) as S);
      }
    }
  }

  Future<void> launchApiCall<T>(
    Future<ApiResult<T>> Function() future, {
    bool showError = true,
    bool showLoading = false,
    void Function()? doOnLoading,
    void Function(T)? doOnSuccess,
    void Function(Object)? doOnError,
  }) async {
    if (!isClosed) doOnLoading?.call();
    if (showLoading && !isClosed) {
      emit(state.copyWith(isLoading: true) as S);
    }
    final data = await future.call();
    data.when(
      success: (data) {
        if (!isClosed) doOnSuccess?.call(data);
        if (showLoading && !isClosed) {
          emit(state.copyWith(isLoading: false) as S);
        }
      },
      failure: (error) {
        if (!isClosed) doOnError?.call(error);
        if (showError && !isClosed) {
          emit(state.copyWith(exception: error) as S);
        }
        if (showLoading && !isClosed) {
          emit(state.copyWith(isLoading: false) as S);
        }
      },
    );
  }
}
