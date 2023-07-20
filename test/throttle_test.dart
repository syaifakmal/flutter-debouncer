import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_debouncer/flutter_debouncer.dart';

void main() {
  group('Debouncer throttle', () {
    test('Throttle function should trigger the callback once within the duration', () async {
      final debouncer = Debouncer();
      const duration = Duration(milliseconds: 500);

      int callbackCount = 0;

      debouncer.throttle(duration, () {
        callbackCount++;
      });

      debouncer.throttle(duration, () {
        callbackCount++;
      });

      debouncer.throttle(duration, () {
        callbackCount++;
      });

      await Future.delayed(const Duration(milliseconds: 300));

      // Expect that the callback is triggered exactly once within the duration
      expect(callbackCount, 1);
    });
  });
}
