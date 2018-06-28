# Dart Thumbor client

Dart client for the [Thumbor image service][1] 

## Usage


Add `thumbor` dependency to your `pubspec.yaml`:

```yaml
dependencies:
  thumbor: any
```


In your Dart code, import `package:thumbor/thumbor.dart` and create a `Thumbor` using the hostname of your server and optionally your key:

```dart
import 'package:thumbor/thumbor.dart';

final Thumbor thumbor = new Thumbor(hostname: "http://thumbor.example.com", key: "123456789");
```

Then you can use this instance to create `ThumborUrl`
```dart

final Thumbor thumbor = new Thumbor(hostname: "http://thumbor.example.com", key: "123456789");
thumbor
  .buildImage("http://images.google.com/im-feeling-lucky.jpg")
  .toUrl();

```


[1]: https://github.com/globocom/thumbor