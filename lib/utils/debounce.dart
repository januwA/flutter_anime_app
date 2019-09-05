import 'dart:async';

Function(int) debounce(Function(int) fn, [int t = 30]) {
  Timer _debounce;
  return (int i) {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: t), () {
      fn(i);
    });
  };
}
