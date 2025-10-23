import 'dart:async';

import 'behavior_type.dart';

/// The [Throttler] class helps manage the rate of function invocations by
/// ensuring that the function is only triggered after a specified duration of
/// inactivity.
class Throttler {
  Timer? _throttleTimer;

  /// Throttles the provided [onThrottle] function by executing it once, and
  /// preventing further invocations within the specified [duration].
  ///
  /// If the [throttle] method is called multiple times within the [duration],
  /// only the first call will trigger the function. Subsequent calls during
  /// this period will be ignored until the [duration] has passed, at which
  /// point the function can be triggered again.
  ///
  /// Note: The [onThrottle] function is executed immediately upon calling
  /// [throttle] if no previous call is active, otherwise, it will be delayed
  /// until the next eligible time slot after the [duration].
  void throttle({
    required Duration duration,
    required Function() onThrottle,
    @Deprecated("Throttle now uses leading-edge behavior by default.")
    BehaviorType type = BehaviorType.leadingEdge,
  }) {
    if (_throttleTimer == null) {
      _throttleTimer = Timer(duration, () {
        _throttleTimer = null;
      });
      onThrottle();
    }
  }

  /// Cancels any pending  throttled callbacks.
  ///
  /// If there is an active throttle timer, it will be canceled, and the
  /// throttled callback associated with that timer will not be invoked.
  void cancel() {
    _throttleTimer?.cancel();
    _throttleTimer = null;
  }
}
