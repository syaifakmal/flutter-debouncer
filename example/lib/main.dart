import 'package:flutter/material.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyScreen(),
    );
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final Debouncer _debouncer = Debouncer();
  String normalText = '';
  String debouncedText = '';

  void _handleTextFieldChange(String value) {
    setState(() {
      normalText = value;
    });

    _debouncer.debounce(const Duration(milliseconds: 500), () {
      setState(() {
        debouncedText = value;
      });
    });
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
