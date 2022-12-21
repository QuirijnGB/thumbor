# Dart Thumbor client

Dart client for the [Thumbor image service][1] 

## Usage


Add `thumbor` dependency to your `pubspec.yaml`:

```yaml
dependencies:
  thumbor: 1.0.4
```


In your Dart code, import `package:thumbor/thumbor.dart` and create a `Thumbor` using the hostname of your server and optionally your key:

```dart
import 'package:thumbor/thumbor.dart';

final thumbor = Thumbor(host: "http://thumbor.example.com", key: "123456789");
```

Then you can use this instance to create `ThumborUrl`
```dart

final thumbor = Thumbor(host: "http://thumbor.example.com", key: "123456789");
thumbor
  .buildImage("http://images.google.com/im-feeling-lucky.jpg")
  .toUrl();

```


[1]: https://github.com/globocom/thumbor
