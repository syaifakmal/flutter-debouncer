import 'dart:async';

import 'behavior_type.dart';

/// The `Debouncer` class provides a mechanism to debounce function calls,
/// ensuring that the function is only invoked after a specified duration of
/// inactivity.
class Debouncer {
  Timer? _debounceTimer;

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
  /// within the [duration].
  void debounce({
    required Duration duration,
    required Function() onDebounce,
    BehaviorType type = BehaviorType.trailingEdge,
  }) {
    if (_debounceTimer == null && type == BehaviorType.leadingEdge) {
      onDebounce();
    }

    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      _debounceTimer = null;
      if (type == BehaviorType.trailingEdge) {
        onDebounce();
      }
    });
  }

  /// Cancels any pending debounced callbacks.
  ///
  /// If there is an active debounce timer, it will be canceled, and the
  /// debounced callback associated with that timer will not be invoked.
  void cancel() {
    _debounceTimer?.cancel();
    _debounceTimer = null;
  }
}
