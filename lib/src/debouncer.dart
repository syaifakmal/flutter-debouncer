import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  Timer? _timer;

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
      }
    });
  }

  void cancel() {
    _timer?.cancel();
  }
}
