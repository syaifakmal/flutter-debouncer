import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';

void main() {
  group('Debouncer throttle', () {
    test('Throttle function should trigger the callback once within the duration', () async {
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

      // Expect that the callback is triggered exactly once within the duration
      expect(callbackCount, 1);

      await Future.delayed(const Duration(milliseconds: 300));

      // Expect that the callback is triggered exactly once within the duration
      expect(callbackCount, 1);
    });

    test('Throttle function should trigger the callback on leading edge', () async {
      final throttler = Throttler();
      const duration = Duration(milliseconds: 500);

      int callbackCount = 0;

      throttler.throttle(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onThrottle: () {
          callbackCount++;
        },
      );

      throttler.throttle(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onThrottle: () {
          callbackCount++;
        },
      );

      throttler.throttle(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onThrottle: () {
          callbackCount++;
        },
      );

      await Future.delayed(const Duration(milliseconds: 300));

      // Expect that the callback is triggered immediately on leading edge
      expect(callbackCount, 1);

      await Future.delayed(const Duration(milliseconds: 300));

      // Expect that the callback is triggered once within the duration
      expect(callbackCount, 1);
    });

    test('Throttle function should trigger the callback on both edges', () async {
      final throttler = Throttler();
      const duration = Duration(milliseconds: 500);

      int callbackCount = 0;

      throttler.throttle(
        duration: duration,
        type: BehaviorType.leadingAndTrailing,
        onThrottle: () {
          callbackCount++;
        },
      );

      throttler.throttle(
        duration: duration,
        type: BehaviorType.leadingAndTrailing,
        onThrottle: () {
          callbackCount++;
        },
      );

      throttler.throttle(
        duration: duration,
        type: BehaviorType.leadingAndTrailing,
        onThrottle: () {
          callbackCount++;
        },
      );

      await Future.delayed(const Duration(milliseconds: 300));

      // Expect that the callback is triggered immediately on leading edge
      expect(callbackCount, 1);

      await Future.delayed(const Duration(milliseconds: 300));

      // Expect that the callback is triggered once within the duration
      expect(callbackCount, 2);
    });
  });
}
