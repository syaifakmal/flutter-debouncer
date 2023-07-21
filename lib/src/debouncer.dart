import 'dart:async';
import 'package:flutter/foundation.dart';

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
  ///If [isLeadingEdge] is set to `true`, the [onDebounce] function will be
  /// invoked immediately on the first call, and any subsequent calls within
  /// the [duration] will reset the timer, postponing the function execution
  /// until the [duration] has elapsed without any new calls. If [isLeadingEdge]
  /// is set to `false` (the default), the [onDebounce] function will execute
  /// after the [duration] has passed without any new calls.
  ///
  /// If an [error] occurs during the debounced callback execution, it will be
  /// caught and printed to the console in debug mode, along with the
  /// associated [stackTrace]. In release mode, the error will not be printed
  /// but will be silently ignored.
  void debounce(Duration duration, Function() onDebounce, {bool isLeadingEdge = false}) {
    if (_debounceTimer == null && isLeadingEdge) {
      onDebounce();
    }
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      try {
        onDebounce();
      } catch (error, stackTrace) {
        if (kDebugMode) {
          print('Error occurred during debounced callback: $error');
          print(stackTrace);
        }
        rethrow;
      }
    });
  }

  /// Throttles the provided [callback] function by executing it once, and
  /// preventing further invocations within the specified [duration].
  ///
  /// If the [throttle] method is called multiple times within the [duration],
  /// only the first call will trigger the callback. Subsequent calls during
  /// this period will be ignored until the [duration] has passed, at which
  /// point the callback can be triggered again.
  ///
  /// If an [error] occurs during the throttled callback execution, it will be
  /// caught and printed to the console in debug mode, along with the
  /// associated [stackTrace]. In release mode, the error will not be printed
  /// but will be silently ignored.
  ///
  /// Note: The [callback] function is executed immediately upon calling
  /// [throttle] if no previous call is active, otherwise, it will be delayed
  /// until the next eligible time slot after the [duration].
  void throttle(Duration duration, Function() onThrottle) {
    if (_throttleTimer == null) {
      _throttleTimer = Timer(duration, () {
        _throttleTimer = null;
      });
      try {
        onThrottle();
      } catch (error, stackTrace) {
        if (kDebugMode) {
          print('Error occurred during throttle callback: $error');
          print(stackTrace);
        }
        rethrow;
      }
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
