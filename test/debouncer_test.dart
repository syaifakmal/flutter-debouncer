import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer', () {
    test('Callback is called after the specified duration', () async {
      final debouncer = Debouncer();
      var callbackCalled = false;
      const duration = Duration(milliseconds: 500);

      debouncer.debounce(
        duration: duration,
        onDebounce: () {
          callbackCalled = true;
        },
      );

      // Wait for a shorter duration than the debounce duration
      await Future.delayed(duration - const Duration(milliseconds: 100));

      expect(callbackCalled, false);

      // Wait for the debounce duration to elapse
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, true);
    });

    test('Multiple calls within the debounce duration cancel previous timers', () async {
      final debouncer = Debouncer();
      var callbackCalledCount = 0;
      const duration = Duration(milliseconds: 500);

      debouncer.debounce(
        duration: duration,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Wait for a shorter duration than the debounce duration
      await Future.delayed(duration - const Duration(milliseconds: 100));

      expect(callbackCalledCount, 0);

      // Call the debouncer multiple times within the debounce duration
      debouncer.debounce(
        duration: duration,
        onDebounce: () {
          callbackCalledCount++;
        },
      );
      debouncer.debounce(
        duration: duration,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Wait for the debounce duration to elapse
      await Future.delayed(duration);

      expect(callbackCalledCount, 1);
    });

    test('Cancel cancels the currently scheduled callback', () async {
      final debouncer = Debouncer();
      var callbackCalled = false;
      const duration = Duration(milliseconds: 500);

      debouncer.debounce(
        duration: duration,
        onDebounce: () {
          callbackCalled = true;
        },
      );

      // Wait for a shorter duration than the debounce duration
      await Future.delayed(duration - const Duration(milliseconds: 100));

      expect(callbackCalled, false);

      // Cancel the currently scheduled callback
      debouncer.cancel();

      // Wait for the debounce duration to elapse
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, false);
    });

    test('Leading edge: Callback is called immediately on the first call', () async {
      final debouncer = Debouncer();
      var callbackCalled = false;
      const duration = Duration(milliseconds: 500);

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalled = true;
        },
      );

      // Wait for a shorter duration than the debounce duration
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, true);

      // Wait for the debounce duration to elapse
      await Future.delayed(duration);

      // Ensure that the callback is called only once
      expect(callbackCalled, true);
    });

    test('Trailing and Leading Edge: Callback is called immediately on the first call and after the specified duration', () async {
      final debouncer = Debouncer();
      var callbackCalled = false;
      const duration = Duration(milliseconds: 500);

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.leadingAndTrailing,
        onDebounce: () {
          callbackCalled = !callbackCalled;
        },
      );

      // Wait for a shorter duration than the debounce duration
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, true);

      // Wait for the debounce duration to elapse
      await Future.delayed(duration);

      // Ensure that the callback is called only once
      expect(callbackCalled, false);
    });
  });
}
