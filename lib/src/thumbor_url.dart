import 'dart:convert';

import 'package:crypto/crypto.dart';

class TrimOrientation {
  const TrimOrientation(String value) : value = value;

  final String value;

  static const TrimOrientation topLeft = const TrimOrientation("top-left");
  static const TrimOrientation bottomRight =
      const TrimOrientation("bottom-right");
}

class ThumborUrl {
  final String host;
  final String key;
  final String imageUrl;
  static const PREFIX_UNSAFE = "unsafe/";
  static const PREFIX_TRIM = "trim";

  bool _hasTrim = false;
  TrimOrientation _trimOrientation;
  int _trimTolerance;

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

  void trim({TrimOrientation orientation, int tolerance = 0}) {
    this._hasTrim = true;
    this._trimOrientation = orientation;
    this._trimTolerance = tolerance;
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
    var encoded = base64Url.encode(digest.bytes);
    return host + "$encoded/" + config;
  }

  String _assembleConfig() {
    String config = "";

    if (_hasTrim) {
      config += PREFIX_TRIM;

      if (_trimOrientation != null) {
        config += ":${_trimOrientation.value}";
        if (_trimTolerance > 0) {
          config += ":${_trimTolerance.toString()}";
        }
      }
      config += "/";
    }

    config += imageUrl;
    return config;
  }
}
