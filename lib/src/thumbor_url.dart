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
  static const ORIGINAL_SIZE = -10000;

  bool _hasTrim = false;
  TrimOrientation _trimOrientation;
  int _trimTolerance;

  bool _hasCrop = false;
  int _cropTop = 0;
  int _cropLeft = 0;
  int _cropBottom = 0;
  int _cropRight = 0;

  bool _hasResize = false;
  int _resizeHeight;
  int _resizeWidth;

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

  void crop(int top, int left, int bottom, int right) {
    if (top < 0) {
      throw ArgumentError("Top must be greater or equal to zero");
    }
    if (left < 0) {
      throw ArgumentError("Left must be greater or equal to zero");
    }
    if (bottom < 0) {
      throw ArgumentError("Bottom must be greater or equal to zero");
    }
    if (right < 0) {
      throw ArgumentError("Right must be greater or equal to zero");
    }

    this._hasCrop = true;
    this._cropTop = top;
    this._cropLeft = left;
    this._cropBottom = bottom;
    this._cropRight = right;
  }

  void resize({int width = 0, int height = 0}) {
    if (width < 0 && width != ORIGINAL_SIZE) {
      throw ArgumentError("Width must be a positive number.");
    }
    if (height < 0 && height != ORIGINAL_SIZE) {
      throw ArgumentError("Height must be a positive number.");
    }
    if (width == 0 && height == 0) {
      throw ArgumentError("Both width and height must not be zero.");
    }

    this._hasResize = true;

    this._resizeHeight = height;
    this._resizeWidth = width;
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

    if (_hasCrop) {
      config += "${_cropLeft}x${_cropTop}:${_cropRight}x${_cropBottom}/";
    }

    if (_hasResize) {
      if (_resizeWidth == ORIGINAL_SIZE) {
        config += "orig";
      } else {
        config += "${_resizeWidth}";
      }

      config += "x";

      if (_resizeHeight == ORIGINAL_SIZE) {
        config += "orig";
      } else {
        config += "${_resizeHeight}";
      }

      config += "/";
    }

    config += imageUrl;
    return config;
  }
}
