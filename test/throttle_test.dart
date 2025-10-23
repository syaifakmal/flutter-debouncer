import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';

void main() {
  group('Throttler', () {
    test('Throttle: Callback should trigger only once within the throttle duration, ignoring rapid subsequent calls', () async {
      final throttler = Throttler();
      const duration = Duration(milliseconds: 500);

      int callbackCount = 0;

      throttler.throttle(
        duration: duration,
        onThrottle: () {
          callbackCount++;
        },
      );

      throttler.throttle(
        duration: duration,
        onThrottle: () {
          callbackCount++;
        },
      );

      throttler.throttle(
        duration: duration,
        onThrottle: () {
          callbackCount++;
        },
      );

      await Future.delayed(const Duration(milliseconds: 300));

      expect(callbackCount, 1, reason: 'Throttle should only trigger the callback once within the throttle window, ignoring rapid subsequent calls.');
    });

    test('Cancel: should stop the current throttle delay and allow immediate re-throttling', () async {
      final throttler = Throttler();
      const duration = Duration(milliseconds: 500);

      int callbackCount = 0;

      throttler.throttle(
        duration: duration,
        onThrottle: () async {
          callbackCount++;
          await Future.delayed(const Duration(milliseconds: 300));
          throttler.cancel();
        },
      );

      expect(callbackCount, 1, reason: 'Callback should execute immediately on the first call.');

      // Wait a bit to let the first call and cancel complete
      await Future.delayed(const Duration(milliseconds: 300));

      throttler.throttle(
        duration: duration,
        onThrottle: () {
          callbackCount++;
        },
      );

      expect(callbackCount, 2, reason: 'Canceling should reset the throttle period, allowing immediate re-throttling.');
    });
  });
}
