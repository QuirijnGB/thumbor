import 'package:thumbor/src/thumbor_url.dart';

class Thumbor {
  Thumbor({
    required this.host,
    this.key,
  }) {
    if (host.isEmpty) {
      throw ArgumentError('Host may not be empty');
    }
  }

  final String host;
  final String? key;

  ThumborUrl buildImage(String imageUrl) {
    return ThumborUrl(host: host, key: key, imageUrl: imageUrl);
  }
}
