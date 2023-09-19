import 'dart:async';

/// The `Debouncer` class provides a mechanism to debounce function calls,
/// ensuring that the function is only invoked after a specified duration of
/// inactivity.
class Debouncer {
  Timer? _debounceTimer;
  Timer? _throttleTimer;

  /// Debounces the provided [callback] function by canceling any existing
  /// timer and scheduling a new timer to invoke the callback after the
  /// specified [duration] of inactivity.
  ///
  /// The [callback] function is invoked only once, even if this method is
  /// called multiple times within the [duration].
  ///
  /// The [type] parameter specifies the debounce behavior. Use [BehaviorType.trailingEdge]
  /// to execute the [onDebounce] function after the [duration] has passed without
  /// any new calls. Use [BehaviorType.leadingEdge] to execute the [onDebounce]
  /// function immediately on the first call and postpone any subsequent calls
  /// within the [duration]. Use [BehaviorType.leadingAndTrailing] to execute
  /// the [onDebounce] function both on the leading and trailing edges of the
  /// timer.
  ///
  /// [isLeadingEdge] is deprecated and may not have the desired flexibility.
  /// It is recommended to use the [type] parameter instead.
  void debounce(
    Duration duration,
    Function() onDebounce, {
    @Deprecated("Please use the 'type' parameter instead.") bool isLeadingEdge = false,
    BehaviorType type = BehaviorType.trailingEdge,
  }) {
    if (type == BehaviorType.leadingEdge || type == BehaviorType.leadingAndTrailing) {
      onDebounce();
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      if (type == BehaviorType.trailingEdge || type == BehaviorType.leadingAndTrailing) {
        onDebounce();
      }
    });
  }

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
  void throttle(
    Duration duration,
    Function() onThrottle, {
    BehaviorType type = BehaviorType.leadingEdge,
  }) {
    if (_throttleTimer == null) {
      _throttleTimer = Timer(duration, () {
        _throttleTimer = null;
        if (type == BehaviorType.trailingEdge || type == BehaviorType.leadingAndTrailing) {
          onThrottle();
        }
      });
      onThrottle();
    }
  }

  /// Cancels any pending debounced or throttled callbacks.
  ///
  /// If there is an active debounce timer, it will be canceled, and the
  /// debounced callback associated with that timer will not be invoked.
  ///
  /// If there is an active throttle timer, it will be canceled, and the
  /// throttled callback associated with that timer will not be invoked.
  void cancel() {
    _debounceTimer?.cancel();
    _throttleTimer?.cancel();
    _throttleTimer = null;
  }
}

/// Specifies the behavior type for debouncing or throttling function calls.
///
/// The [BehaviorType] enum is used to define how function calls are handled
/// within the context of debouncing or throttling mechanisms. It provides
/// options for specifying when and how the callback function is executed.
///
/// - [BehaviorType.trailingEdge] : The callback function is executed after the
///   specified duration has passed without any new calls.
/// - [BehaviorType.leadingEdge] : The callback function is executed immediately
///   on the first call, and subsequent calls within the specified duration are
///   ignored.
/// - [BehaviorType.leadingAndTrailing] : The callback function is executed both
///   on the leading and trailing edges of the timer. It is invoked immediately
///   on the first call and after the specified duration has passed without any
///   new calls.
enum BehaviorType {
  /// The callback function is executed after the specified duration has passed
  /// without any new calls.
  trailingEdge,

  /// The callback function is executed immediately on the first call, and
  /// subsequent calls within the specified duration are ignored.
  leadingEdge,

  /// The callback function is executed both on the leading and trailing edges
  /// of the timer. It is invoked immediately on the first call and after the
  /// specified duration has passed without any new calls.
  leadingAndTrailing,
}
