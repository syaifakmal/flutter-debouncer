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

    test('Multiple calls within the debounce duration cancel previous timers',
        () async {
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

    test(
        'Leading edge: Callback is called immediately on first call'
        ' and subsequent calls are ignored during debounce period', () async {
      final debouncer = Debouncer();
      var callbackCalledCount = 0;
      const debounceDuration = Duration(milliseconds: 500);
      const initialDelay = Duration(milliseconds: 200);
      const safetyMargin = Duration(milliseconds: 10);

      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called immediately on first call
      expect(callbackCalledCount, 1);

      // Wait for a duration shorter than debounce period
      await Future.delayed(initialDelay);

      // Second call within debounce period
      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback count should remain the same as second call is ignored
      expect(callbackCalledCount, 1);

      // Wait until the debounce period should have expired if we didn't have
      // the 2nd call
      final oriEndDelay = debounceDuration - initialDelay + safetyMargin;
      await Future.delayed(oriEndDelay);

      // Callback count should still be 1 as the timer was reset
      expect(callbackCalledCount, 1);

      // Wait for full debounce duration to ensure no additional calls
      await Future.delayed(debounceDuration - oriEndDelay + safetyMargin);

      // Final verification that callback was only called once
      expect(callbackCalledCount, 1);
    });

    test(
        'Leading edge: Calling after the debounce period will start a new period',
        () async {
      final debouncer = Debouncer();
      var callbackCalledCount = 0;
      const debounceDuration = Duration(milliseconds: 500);
      const safetyMargin = Duration(milliseconds: 10);

      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called immediately on first call
      expect(callbackCalledCount, 1);

      // Wait for the debounce period to elapse
      await Future.delayed(debounceDuration + safetyMargin);

      // Second call after 1st debounce period
      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called again because a new debounce period has started
      expect(callbackCalledCount, 2);
    });

    test('Leading edge: Calling after cancel will start a new period',
        () async {
      final debouncer = Debouncer();
      var callbackCalledCount = 0;
      const debounceDuration = Duration(milliseconds: 500);
      const initialDelay = Duration(milliseconds: 100);

      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called immediately on first call
      expect(callbackCalledCount, 1);

      // Wait for a duration shorter than debounce period
      await Future.delayed(initialDelay);

      // Cancel the debounce timer
      debouncer.cancel();

      // Second call after cancel
      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingEdge,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called again because a new debounce period has started
      expect(callbackCalledCount, 2);
    });

    test(
        'Trailing and Leading Edge: Callback is called immediately on the first'
        ' call and after the specified duration', () async {
      final debouncer = Debouncer();
      var callbackCalledCount = 0;
      const debounceDuration = Duration(milliseconds: 500);
      const initialDelay = Duration(milliseconds: 200);
      const safetyMargin = Duration(milliseconds: 10);

      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingAndTrailing,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called immediately on first call
      expect(callbackCalledCount, 1);

      // Wait for a duration shorter than debounce period
      await Future.delayed(initialDelay);

      // Second call within debounce period
      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingAndTrailing,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback count should remain the same as second call is ignored
      expect(callbackCalledCount, 1);

      // Wait until the debounce period should have expired if we didn't have
      // the 2nd call
      final oriEndDelay = debounceDuration - initialDelay + safetyMargin;
      await Future.delayed(oriEndDelay);

      // Callback count should still be 1 as the timer was reset
      expect(callbackCalledCount, 1);

      // Wait until just before the debounce period
      await Future.delayed(debounceDuration - oriEndDelay - safetyMargin);

      // The callback shouldn't be called yet
      expect(callbackCalledCount, 1);

      // Wait for the debounce period to elapse
      await Future.delayed(safetyMargin * 2);

      // Callback should be called again after the debounce period
      expect(callbackCalledCount, 2);
    });

    test(
        'Trailing and Leading Edge: Calling after the debounce period will'
        ' start a new period', () async {
      final debouncer = Debouncer();
      var callbackCalledCount = 0;
      const debounceDuration = Duration(milliseconds: 500);
      const safetyMargin = Duration(milliseconds: 10);

      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingAndTrailing,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called immediately on first call
      expect(callbackCalledCount, 1);

      // Wait for the debounce period to elapse
      await Future.delayed(debounceDuration + safetyMargin);

      // Callback should be called after the debounce period
      expect(callbackCalledCount, 2);

      // Second call after the 1st debounce period
      debouncer.debounce(
        duration: debounceDuration,
        type: BehaviorType.leadingAndTrailing,
        onDebounce: () {
          callbackCalledCount++;
        },
      );

      // Callback should be called again because a new debounce period has started
      expect(callbackCalledCount, 3);

      // Wait for the 2nd debounce period to elapse
      await Future.delayed(debounceDuration + safetyMargin);

      // Callback should be called again after the 2nd debounce period
      expect(callbackCalledCount, 4);
    });
  });
}
