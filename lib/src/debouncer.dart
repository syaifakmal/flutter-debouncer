import 'dart:async';
import 'package:flutter/foundation.dart';

/// The `Debouncer` class provides a mechanism to debounce function calls,
/// ensuring that the function is only invoked after a specified duration of
/// inactivity.
class Debouncer {
  Timer? _timer;

  /// Debounces the provided [callback] function by canceling any existing
  /// timer and scheduling a new timer to invoke the callback after the
  /// specified [duration] of inactivity.
  ///
  /// The [callback] function is invoked only once, even if this method is
  /// called multiple times within the [duration].
  ///
  /// If an [error] occurs during the debounced callback execution, it will be
  /// caught and printed to the console in debug mode, along with the
  /// associated [stackTrace]. In release mode, the error will not be printed
  /// but will be silently ignored.
  void debounce(Duration duration, Function() callback) {
    _timer?.cancel();
    _timer = Timer(duration, () {
      try {
        callback();
      } catch (error, stackTrace) {
        if (kDebugMode) {
          print('Error occurred during debounced callback: $error');
          print(stackTrace);
        }
        return;
      }
    });
  }

  /// Cancels any pending debounced callback.
  ///
  /// If there is an active timer, it will be canceled, and the callback
  /// associated with that timer will not be invoked.
  void cancel() {
    _timer?.cancel();
  }
}

