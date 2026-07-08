import 'package:flutter/foundation.dart';

@immutable
class ProcessState<T> {
  const ProcessState.success(T data)
      : this._(status: StateStatus.success, data: data);

  const ProcessState._({
    this.status = StateStatus.idle,
    this.data,
    this.error,
  });

  const ProcessState.init(T? data)
      : this._(status: StateStatus.idle, data: data);

  const ProcessState.loading() : this._(status: StateStatus.loading);

  const ProcessState.error(Object error)
      : this._(status: StateStatus.error, error: error);
  final StateStatus status;
  final T? data;
  final Object? error;

  bool get hasSuccess => status == StateStatus.success && data != null;

  bool get hasError => status == StateStatus.error && error != null;

  bool get isLoading => status == StateStatus.loading;

  bool get isIdle => status == StateStatus.idle;

  @override
  String toString() =>
      'StatefulVariable(status: $status, data: $data, error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProcessState<T> &&
        other.status == status &&
        other.data == data &&
        other.error == error;
  }

  @override
  int get hashCode {
    return status.hashCode ^ data.hashCode ^ error.hashCode;
  }
}

enum StateStatus { loading, success, error, idle }

enum FormStatus { submitting, success, error, editing }
