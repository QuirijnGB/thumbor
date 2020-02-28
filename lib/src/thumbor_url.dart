import 'dart:convert';

import 'package:crypto/crypto.dart';

class TrimOrientation {
  const TrimOrientation(String value) : value = value;

  final String value;

  static const TrimOrientation topLeft = TrimOrientation("top-left");
  static const TrimOrientation bottomRight = TrimOrientation("bottom-right");
}

class HorizontalAlignment {
  const HorizontalAlignment(String value) : value = value;

  final String value;

  static const HorizontalAlignment left = HorizontalAlignment("left");
  static const HorizontalAlignment center = HorizontalAlignment("center");
  static const HorizontalAlignment right = HorizontalAlignment("right");
}

class VerticalAlignment {
  const VerticalAlignment(String value) : value = value;

  final String value;

  static const VerticalAlignment top = VerticalAlignment("top");
  static const VerticalAlignment middle = VerticalAlignment("middle");
  static const VerticalAlignment bottom = VerticalAlignment("bottom");
}

class FitInStyle {
  const FitInStyle(String value) : value = value;

  final String value;

  static const FitInStyle normal = FitInStyle("fit-in");
  static const FitInStyle full = FitInStyle("full-fit-in");
  static const FitInStyle adaptive = FitInStyle("adaptive-fit-in");
}

class ImageFormat {
  const ImageFormat(String value) : value = value;

  final String value;

  static const ImageFormat GIF = ImageFormat("gif");
  static const ImageFormat JPEG = ImageFormat("jpeg");
  static const ImageFormat PNG = ImageFormat("png");
  static const ImageFormat WEBP = ImageFormat("webp");
}

class ThumborUrl {
  final String host;
  final String key;
  final String imageUrl;
  static const PREFIX_UNSAFE = "unsafe/";
  static const PREFIX_TRIM = "trim";
  static const ORIGINAL_SIZE = -10000;

  static const _FILTER_BRIGHTNESS = "brightness";
  static const _FILTER_CONTRAST = "contrast";
  static const _FILTER_NOISE = "noise";
  static const _FILTER_QUALITY = "quality";
  static const _FILTER_RGB = "rgb";
  static const _FILTER_ROUND_CORNER = "round_corner";
  static const _FILTER_WATERMARK = "watermark";
  static const _FILTER_SHARPEN = "sharpen";
  static const _FILTER_FILL = "fill";
  static const _FILTER_FORMAT = "format";
  static const _FILTER_FRAME = "frame";
  static const _FILTER_STRIP_ICC = "strip_icc";
  static const _FILTER_GRAYSCALE = "grayscale";
  static const _FILTER_EQUALIZE = "equalize";
  static const _FILTER_BLUR = "blur";
  static const _FILTER_NO_UPSCALE = "no_upscale";
  static const _FILTER_ROTATE = "rotate";

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

  bool _flipVertically = false;
  bool _flipHorizontally = false;
  bool _smart = false;

  HorizontalAlignment _horizontalAlign;
  VerticalAlignment _verticalAlign;

  FitInStyle _fitInStyle;

  List<String> _filters;

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

  void flipVertically() {
    if (!this._hasResize) {
      throw StateError("Resize must be called first");
    }
    this._flipVertically = true;
  }

  void flipHorizontally() {
    if (!this._hasResize) {
      throw StateError("Resize must be called first");
    }
    this._flipHorizontally = true;
  }

  void smart() {
    if (!this._hasResize) {
      throw StateError("Resize must be called first");
    }
    this._smart = true;
  }

  void horizontalAlign(HorizontalAlignment align) {
    if (!this._hasResize) {
      throw StateError("Resize must be called first");
    }

    this._horizontalAlign = align;
  }

  void verticalAlign(VerticalAlignment align) {
    if (!this._hasResize) {
      throw StateError("Resize must be called first");
    }

    this._verticalAlign = align;
  }

  void fitIn(FitInStyle style) {
    if (!this._hasResize) {
      throw StateError("Resize must be called first");
    }

    this._fitInStyle = style;
  }

  void filter(List<String> filters) {
    if (filters.isEmpty) {
      throw ArgumentError("You must provide at least one filter.");
    }
    if (this._filters == null) {
      this._filters = List();
    }

    filters.forEach((filter) {
      if (filter == null || filter.isEmpty) {
        throw ArgumentError("Filter must not be blank.");
      }
      this._filters.add(filter);
    });
  }

  String toUrl() {
    return key == null ? toUnsafeUrl() : toSafeUrl();
  }

  String toUnsafeUrl() {
    return host + PREFIX_UNSAFE + _assembleConfig();
  }

  String toSafeUrl() {
    if (key == null) {
      throw StateError("Cannot build safe URL without a key.");
    }

    String config = _assembleConfig();

    var hmac = Hmac(sha1, utf8.encode(key));
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
      if (_fitInStyle != null) {
        config += "${_fitInStyle.value}/";
      }

      if (_flipHorizontally) {
        config += "-";
      }
      if (_resizeWidth == ORIGINAL_SIZE) {
        config += "orig";
      } else {
        config += "${_resizeWidth}";
      }

      config += "x";

      if (_flipVertically) {
        config += "-";
      }
      if (_resizeHeight == ORIGINAL_SIZE) {
        config += "orig";
      } else {
        config += "${_resizeHeight}";
      }

      if (_smart) {
        config += "/smart";
      } else {
        if (_horizontalAlign != null) {
          config += "/${_horizontalAlign.value}";
        }
        if (_verticalAlign != null) {
          config += "/${_verticalAlign.value}";
        }
      }

      config += "/";
    }

    if (_filters != null) {
      config += "filters";

      _filters.forEach((filter) {
        config += ":$filter";
      });
      config += "/";
    }

    config += imageUrl;
    return config;
  }

  static String brightness(int amount) {
    if (amount < -100 || amount > 100) {
      throw ArgumentError("Amount must be between -100 and 100, inclusive.");
    }
    return "$_FILTER_BRIGHTNESS($amount)";
  }

  static String contrast(int amount) {
    if (amount < -100 || amount > 100) {
      throw ArgumentError("Amount must be between -100 and 100, inclusive.");
    }
    return "$_FILTER_CONTRAST($amount)";
  }

  static String noise(int amount) {
    if (amount < 0 || amount > 100) {
      throw ArgumentError("Amount must be between 0 and 100, inclusive");
    }
    return "$_FILTER_NOISE($amount)";
  }

  static String quality(int amount) {
    if (amount < 0 || amount > 100) {
      throw ArgumentError("Amount must be between 0 and 100, inclusive.");
    }
    return "$_FILTER_QUALITY($amount)";
  }

  static String rgb(int r, int g, int b) {
    if (r < -100 || r > 100) {
      throw ArgumentError("Red value must be between -100 and 100, inclusive.");
    }
    if (g < -100 || g > 100) {
      throw ArgumentError(
          "Green value must be between -100 and 100, inclusive.");
    }
    if (b < -100 || b > 100) {
      throw ArgumentError(
          "Blue value must be between -100 and 100, inclusive.");
    }
    return "$_FILTER_RGB($r,$g,$b)";
  }

  static String roundCorner(int radiusInner, int radiusOuter, int color) {
    if (radiusInner < 1) {
      throw ArgumentError("Radius must be greater than zero.");
    }
    if (radiusOuter < 0) {
      throw ArgumentError(
          "Outer radius must be greater than or equal to zero.");
    }

    String builder = "$_FILTER_ROUND_CORNER($radiusInner";

    if (radiusOuter > 0) {
      builder += "|";
      builder += "$radiusOuter";
    }
    final int r = (color & 0xFF0000) >> 16;
    final int g = (color & 0xFF00) >> 8;
    final int b = color & 0xFF;

    builder += ",$r,$g,$b)";

    return builder;
  }

  static String watermark(String imageUrl, int x, int y, int transparency) {
    if (imageUrl == null || imageUrl.length == 0) {
      throw ArgumentError("Image URL must not be blank.");
    }
    if (transparency < 0 || transparency > 100) {
      throw ArgumentError("Transparency must be between 0 and 100, inclusive.");
    }
    return "$_FILTER_WATERMARK($imageUrl,$x,$y,$transparency)";
  }

  static String sharpen(double amount, double radius, bool luminanceOnly) {
    return "$_FILTER_SHARPEN($amount,$radius,$luminanceOnly)";
  }

  static String fill(int color) {
    return "$_FILTER_FILL(${color.toRadixString(16)})";
  }

  static String format(ImageFormat format) {
    if (format == null) {
      throw ArgumentError("You must specify an image format.");
    }
    return "$_FILTER_FORMAT(${format.value})";
  }

  static String frame(String imageUrl) {
    if (imageUrl == null || imageUrl.length == 0) {
      throw ArgumentError("Image URL must not be blank.");
    }
    return "$_FILTER_FRAME($imageUrl)";
  }

  static String stripicc() {
    return "$_FILTER_STRIP_ICC()";
  }

  static String grayscale() {
    return "$_FILTER_GRAYSCALE()";
  }

  static String equalize() {
    return "$_FILTER_EQUALIZE()";
  }

  static String blur(int radius, int sigma) {
    if (radius < 1) {
      throw ArgumentError("Radius must be greater than zero.");
    }
    if (radius > 150) {
      throw ArgumentError("Radius must be lower or equal than 150.");
    }
    if (sigma < 0) {
      throw ArgumentError("Sigma must be greater than zero.");
    }
    return "$_FILTER_BLUR($radius,$sigma)";
  }

  static String noUpscale() {
    return "$_FILTER_NO_UPSCALE()";
  }

  static String rotate(int angle) {
    if (angle % 90 != 0) {
      throw ArgumentError("Angle must be multiple of 90°");
    }
    return "$_FILTER_ROTATE($angle)";
  }
}
