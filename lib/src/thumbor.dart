import 'package:meta/meta.dart';

class Thumbor {
  final String host;
  final String key;

  Thumbor({
    @required this.host,
    this.key,
  }) : assert(host != null) {
    if (host.isEmpty) {
      throw ArgumentError("Host may not be empty");
    }
  }

  buildImage(String imageUrl) {}
}
