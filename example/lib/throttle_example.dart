import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class ThrottleExample extends StatefulWidget {
  const ThrottleExample({super.key});

  @override
  State<ThrottleExample> createState() => _ThrottleExampleState();
}

class _ThrottleExampleState extends State<ThrottleExample> {
  int rawCounter = 0;
  int throttledCounter = 0;

  final Throttler throttler = Throttler();
  final Duration throttlerDuration = const Duration(milliseconds: 500);

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      setState(() {
        rawCounter++;
      });

      throttler.throttle(
        duration: throttlerDuration,
        onThrottle: () {
          setState(() {
            throttledCounter++;
          });
        },
      );
    });
  }

  @override
  void dispose() {
    throttler.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Throttle Example'),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          height: MediaQuery.of(context).size.height * 2,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Number Called Without Throttle : '),
                  const SizedBox(width: 10),
                  Text(rawCounter.toString()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Number Called With Throttle : '),
                  const SizedBox(width: 10),
                  Text(throttledCounter.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
