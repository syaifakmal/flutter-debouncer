## Flutter Debouncer

A Flutter plugin for debouncing can be used to simplify the implementation of debouncing logic in Flutter applications. It provides a convenient way to handle debouncing scenarios for user interactions, such as button presses or text input changes, in order to enhance the user experience and avoid unintended actions or frequent updates.

## Features

✅ &nbsp; Debouncing </br>

## Demo

|<img height=500 src="https://raw.githubusercontent.com/syaifakmal/flutter-debouncer/main/example/assets/debouncer_example.gif"/>|
|---|

## Quick Start

### Step 1: Include the package to your project

```yml
dependencies:
  flutter_debouncer: <latest version>
```

Run pub get and get packages.

### Step 2: Add this package to your project

```dart
import 'package:flutter_debouncer/flutter_debouncer.dart';
```

### Step 3: Initialize Debouncer

```dart
final Debouncer _debouncer = Debouncer();
```

## Example

### Debouncer

```dart
void _handleTextFieldChange(String value) {
    _debouncer.debounce(const Duration(milliseconds: 500), () {
      setState(() {
        debouncedText = value;
      });
    });
  }
```

## Project Created & Maintained By

### Syaif Akmal
<a href="https://www.instagram.com/syaifakmal"><img src="https://github.com/syaifakmal/flutter-debouncer/blob/main/example/assets/instagram.png?raw=true" width="60">&nbsp;&nbsp;
<a href="https://www.linkedin.com/in/syaifakmal/"><img src="https://github.com/syaifakmal/flutter-debouncer/blob/main/example/assets/linkedin.png?raw=true" width="60">&nbsp;&nbsp;
<a href="https://github.com/syaifakmal/"><img src="https://github.com/syaifakmal/flutter-debouncer/blob/main/example/assets/github.png?raw=true" width="60">

## License
Code released under the [GNU GENERAL PUBLIC LICENSE Version 3](./LICENSE).
