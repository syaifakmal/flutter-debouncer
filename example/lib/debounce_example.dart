import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class DebounceExample extends StatefulWidget {
  const DebounceExample({super.key});

  @override
  State<DebounceExample> createState() => _DebounceExampleState();
}

class _DebounceExampleState extends State<DebounceExample> {
  final Debouncer _debouncer = Debouncer();
  final Duration debounceDuration = const Duration(milliseconds: 500);
  String normalText = '';
  String debouncedText = '';

  void _handleTextFieldChange(String value) {
    setState(() {
      normalText = value;
    });

    _debouncer.debounce(
      duration: debounceDuration,
      onDebounce: () {
        setState(() {
          debouncedText = value;
        });
      },
    );
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debouncer Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: _handleTextFieldChange,
                decoration: const InputDecoration(
                  labelText: 'Enter text',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('normalText : '),
                  const SizedBox(width: 10),
                  Text(normalText),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('debouncedText : '),
                  const SizedBox(width: 10),
                  Text(debouncedText),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
