import 'package:thumbor/src/thumbor_url.dart';

class Thumbor {
  final String host;
  final String key;

  Thumbor({
    this.host,
    this.key,
  }) : assert(host != null) {
    if (host.isEmpty) {
      throw ArgumentError("Host may not be empty");
    }
  }

  ThumborUrl buildImage(String imageUrl) {
    return new ThumborUrl(host: host, key: key, imageUrl: imageUrl);
  }
}
