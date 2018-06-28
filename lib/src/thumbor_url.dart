import 'package:meta/meta.dart';

class ThumborUrl {
  final String host;
  final String key;
  final String imageUrl;
  static const PREFIX_UNSAFE = "unsafe/";

  ThumborUrl({
    @required this.host,
    this.key,
    this.imageUrl,
  })  : assert(host != null),
        assert(imageUrl != null) {
    if (host.isEmpty) {
      throw ArgumentError("Host may not be empty");
    }
  }

  String url() {
    return toUnsafeUrl();
  }

  String toUnsafeUrl() {
    return host + PREFIX_UNSAFE + imageUrl;
  }
}
