import 'dart:async';

typedef DebounceCallBack = void Function();

class Debouncer {
  Debouncer({this.interval = const Duration(milliseconds: 500)});
  final Duration interval;

  DebounceCallBack? _action;
  Timer? _timer;

  void call(DebounceCallBack action) {
    _action = action;
    _timer?.cancel();
    _timer = Timer(interval, _callAction);
  }

  _callAction() {
    _action?.call();
    _timer = null;
  }

  void reset() {
    _action = null;
    _timer = null;
  }
}