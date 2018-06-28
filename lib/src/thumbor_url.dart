import 'dart:convert';

import 'package:crypto/crypto.dart';

class ThumborUrl {
  final String host;
  final String key;
  final String imageUrl;
  static const PREFIX_UNSAFE = "unsafe/";

  ThumborUrl({
    this.host,
    this.key,
    this.imageUrl,
  })  : assert(host != null),
        assert(imageUrl != null) {
    if (host.isEmpty) {
      throw ArgumentError("Host may not be empty");
    }
  }

  String toUrl() {
    return key == null ? toUnsafeUrl() : toSafeUrl();
  }

  String toUnsafeUrl() {
    return host + PREFIX_UNSAFE + _assembleConfig();
  }

  String toSafeUrl() {
    if (key == null) {
      throw new StateError("Cannot build safe URL without a key.");
    }

    String config = _assembleConfig();

    var hmac = new Hmac(sha1, utf8.encode(key));
    var digest = hmac.convert(utf8.encode(config));
    var encoded = base64.encode(digest.bytes);
    return host + "$encoded/" + config;
  }

  String _assembleConfig() {
    return imageUrl;
  }
}
