import 'package:flutter_debouncer/flutter_debouncer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Debouncer', () {
    test('Trailing Edge: Callback is called after the specified duration', () async {
      final debouncer = Debouncer();
      const duration = Duration(milliseconds: 500);

      bool callbackCalled = false;

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.trailingEdge,
        onDebounce: () {
          callbackCalled = true;
        },
      );

      await Future.delayed(duration - const Duration(milliseconds: 100));

      expect(callbackCalled, false, reason: 'Callbacks should not execute before the full debounce duration.');

      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, true, reason: 'Callbacks should execute after the debounce duration has fully elapsed.');
    });

    test('Trailing Edge: Multiple calls within the debounce duration should cancel previous timers, executing only the last callback', () async {
      final debouncer = Debouncer();
      const duration = Duration(milliseconds: 500);

      int callbackCalledCount = 0;

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.trailingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Wait slightly less than the debounce duration to stay within the active debounce window
      await Future.delayed(duration - const Duration(milliseconds: 100));

      expect(callbackCalledCount, 0, reason: 'Trailing-edge callbacks should only run after the full duration.');

      // Call debounce again before the duration ends — this should cancel the previous timer
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

      // Wait for the final debounce duration to complete
      await Future.delayed(duration);

      expect(callbackCalledCount, 1, reason: 'Each new call within the debounce window should cancel the previous one, leaving only the last callback to execute.');
    });

    test('Trailing Edge: Cancel should prevent the scheduled callback from executing', () async {
      final debouncer = Debouncer();
      const duration = Duration(milliseconds: 500);

      bool callbackCalled = false;

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.trailingEdge,
        onDebounce: () {
          callbackCalled = true;
        },
      );

      await Future.delayed(duration - const Duration(milliseconds: 100));

      expect(callbackCalled, false, reason: 'Callback should not have executed before duration ends.');

      debouncer.cancel();

      // Wait slightly less than the debounce duration to stay within the active debounce window
      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalled, false, reason: 'Callback should remain uncalled after cancellation.');

      // Schedule another debounced callback after cancellation
      debouncer.debounce(
        duration: duration,
        type: BehaviorType.trailingEdge,
        onDebounce: () {
          callbackCalled = true;
        },
      );

      await Future.delayed(duration);

      expect(callbackCalled, true, reason: 'Callback should execute after re-scheduling.');
    });

    test('Leading Edge: Callback should be executed immediately on the first call', () async {
      final debouncer = Debouncer();
      const duration = Duration(milliseconds: 500);

      bool callbackCalled = false;

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalled = true;
        },
      );

      // Wait slightly less than the debounce duration to stay within the active debounce window
      await Future.delayed(duration - const Duration(milliseconds: 100));

      expect(callbackCalled, true, reason: 'The callback should execute immediately on the first invocation.');
    });

    test('Leading Edge: Subsequent calls within the active debounce period should be ignored', () async {
      final debouncer = Debouncer();
      const duration = Duration(milliseconds: 500);

      int callbackCalledCount = 0;

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      expect(callbackCalledCount, 1, reason: 'The first leading-edge call should execute immediately.');

      // Wait slightly less than the debounce duration to stay within the active debounce window
      await Future.delayed(duration - const Duration(milliseconds: 100));

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      await Future.delayed(const Duration(milliseconds: 100));

      expect(callbackCalledCount, 1, reason: 'Subsequent calls within the debounce window should be ignored when using leading-edge behavior.');
    });

    test('Leading Edge: Cancel should end the current debounce period, allowing immediate new calls', () async {
      final debouncer = Debouncer();
      const duration = Duration(milliseconds: 500);

      int callbackCount = 0;

      debouncer.debounce(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onDebounce: () async {
          callbackCount++;
          // Cancel the current debounce cycle early
          await Future.delayed(const Duration(milliseconds: 300));
          debouncer.cancel();
        },
      );

      // Wait briefly to ensure the first call executes and cancels the period
      await Future.delayed(const Duration(milliseconds: 300));

      // Immediately trigger another leading-edge debounce call after cancellation
      debouncer.debounce(
        duration: duration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCount++;
        },
      );

      expect(callbackCount, 2, reason: 'Canceling the debounce should allow immediate re-invocation.');
    });
  });
}
