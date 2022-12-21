import 'dart:convert';

import 'package:crypto/crypto.dart';

enum TrimOrientation {
  topLeft('top-left'),
  bottomRight('bottom-right');

  const TrimOrientation(this.value);

  final String value;
}

enum HorizontalAlignment {
  left('left'),
  center('center'),
  right('right');

  const HorizontalAlignment(this.value);

  final String value;
}

enum VerticalAlignment {
  top('top'),
  middle('middle'),
  bottom('bottom');

  const VerticalAlignment(this.value);

  final String value;
}

enum FitInStyle {
  normal('fit-in'),
  full('full-fit-in'),
  adaptive('adaptive-fit-in');

  const FitInStyle(this.value);

  final String value;
}

enum ImageFormat {
  gif('gif'),
  jpeg('jpeg'),
  png('png'),
  webp('webp');

  const ImageFormat(this.value);

  final String value;
}

class ThumborUrl {
  ThumborUrl({
    required this.host,
    this.key,
    required this.imageUrl,
  }) {
    if (host.isEmpty) {
      throw ArgumentError('Host may not be empty');
    }
  }

  final String host;
  final String? key;
  final String imageUrl;
  static const _prefixUnsafe = 'unsafe/';
  static const _prefixTrim = 'trim';
  static const originalSize = -10000;

  static const _filterBrightness = 'brightness';
  static const _filterContrast = 'contrast';
  static const _filterNoise = 'noise';
  static const _filterQuality = 'quality';
  static const _filterRGB = 'rgb';
  static const _filterRoundCorner = 'round_corner';
  static const _filterWatermark = 'watermark';
  static const _filterSharpen = 'sharpen';
  static const _filterFill = 'fill';
  static const _filterFormat = 'format';
  static const _filterFrame = 'frame';
  static const _filterStripICC = 'strip_icc';
  static const _filterGrayscale = 'grayscale';
  static const _filterEqualize = 'equalize';
  static const _filterBlur = 'blur';
  static const _filterNoUpscale = 'no_upscale';
  static const _filterRotate = 'rotate';

  bool _hasTrim = false;
  TrimOrientation? _trimOrientation;
  late int _trimTolerance;

  bool _hasCrop = false;
  int _cropTop = 0;
  int _cropLeft = 0;
  int _cropBottom = 0;
  int _cropRight = 0;

  bool _hasResize = false;
  int? _resizeHeight;
  int? _resizeWidth;

  bool _flipVertically = false;
  bool _flipHorizontally = false;
  bool _smart = false;

  HorizontalAlignment? _horizontalAlign;
  VerticalAlignment? _verticalAlign;

  FitInStyle? _fitInStyle;

  final List<String> _filters = [];

  void trim({TrimOrientation? orientation, int tolerance = 0}) {
    _hasTrim = true;
    _trimOrientation = orientation;
    _trimTolerance = tolerance;
  }

  void crop(int top, int left, int bottom, int right) {
    if (top < 0) {
      throw ArgumentError('Top must be greater or equal to zero');
    }
    if (left < 0) {
      throw ArgumentError('Left must be greater or equal to zero');
    }
    if (bottom < 0) {
      throw ArgumentError('Bottom must be greater or equal to zero');
    }
    if (right < 0) {
      throw ArgumentError('Right must be greater or equal to zero');
    }

    _hasCrop = true;
    _cropTop = top;
    _cropLeft = left;
    _cropBottom = bottom;
    _cropRight = right;
  }

  void resize({int width = 0, int height = 0}) {
    if (width < 0 && width != originalSize) {
      throw ArgumentError('Width must be a positive number.');
    }
    if (height < 0 && height != originalSize) {
      throw ArgumentError('Height must be a positive number.');
    }
    if (width == 0 && height == 0) {
      throw ArgumentError('Both width and height must not be zero.');
    }

    _hasResize = true;

    _resizeHeight = height;
    _resizeWidth = width;
  }

  void flipVertically() {
    if (!_hasResize) {
      throw StateError('Resize must be called first');
    }
    _flipVertically = true;
  }

  void flipHorizontally() {
    if (!_hasResize) {
      throw StateError('Resize must be called first');
    }
    _flipHorizontally = true;
  }

  void smart() {
    if (!_hasResize) {
      throw StateError('Resize must be called first');
    }
    _smart = true;
  }

  void horizontalAlign(HorizontalAlignment align) {
    if (!_hasResize) {
      throw StateError('Resize must be called first');
    }

    _horizontalAlign = align;
  }

  void verticalAlign(VerticalAlignment align) {
    if (!_hasResize) {
      throw StateError('Resize must be called first');
    }

    _verticalAlign = align;
  }

  void fitIn(FitInStyle style) {
    if (!_hasResize) {
      throw StateError('Resize must be called first');
    }

    _fitInStyle = style;
  }

  void filter(List<String> filters) {
    _filters.addAll(filters.where((element) => element.isNotEmpty));
  }

  String toUrl() {
    if (key != null) {
      return toSafeUrl();
    } else {
      return toUnsafeUrl();
    }
  }

  String toUnsafeUrl() {
    return host + _prefixUnsafe + _assembleConfig();
  }

  String toSafeUrl() {
    final config = _assembleConfig();

    final hmac = Hmac(sha1, utf8.encode(key!));
    final digest = hmac.convert(utf8.encode(config));
    final encoded = base64Url.encode(digest.bytes);
    return '$host$encoded/$config';
  }

  String _assembleConfig() {
    var config = '';

    if (_hasTrim) {
      config += _prefixTrim;

      if (_trimOrientation != null) {
        config += ':${_trimOrientation?.value ?? ''}';
        if (_trimTolerance > 0) {
          config += ':${_trimTolerance.toString()}';
        }
      }
      config += '/';
    }

    if (_hasCrop) {
      config += '${_cropLeft}x$_cropTop:${_cropRight}x$_cropBottom/';
    }

    if (_hasResize) {
      if (_fitInStyle != null) {
        config += '${_fitInStyle?.value}/';
      }

      if (_flipHorizontally) {
        config += '-';
      }
      if (_resizeWidth == originalSize) {
        config += 'orig';
      } else {
        config += '$_resizeWidth';
      }

      config += 'x';

      if (_flipVertically) {
        config += '-';
      }
      if (_resizeHeight == originalSize) {
        config += 'orig';
      } else {
        config += '$_resizeHeight';
      }

      if (_smart) {
        config += '/smart';
      } else {
        if (_horizontalAlign != null) {
          config += '/${_horizontalAlign!.value}';
        }
        if (_verticalAlign != null) {
          config += '/${_verticalAlign!.value}';
        }
      }

      config += '/';
    }
    if (_filters.isNotEmpty) {
      config += 'filters:';

      config += _filters.join(':');
      config += '/';
    }

    return config + imageUrl;
  }

  static String brightness(int amount) {
    if (amount < -100 || amount > 100) {
      throw ArgumentError('Amount must be between -100 and 100, inclusive.');
    }
    return '$_filterBrightness($amount)';
  }

  static String contrast(int amount) {
    if (amount < -100 || amount > 100) {
      throw ArgumentError('Amount must be between -100 and 100, inclusive.');
    }
    return '$_filterContrast($amount)';
  }

  static String noise(int amount) {
    if (amount < 0 || amount > 100) {
      throw ArgumentError('Amount must be between 0 and 100, inclusive');
    }
    return '$_filterNoise($amount)';
  }

  static String quality(int amount) {
    if (amount < 0 || amount > 100) {
      throw ArgumentError('Amount must be between 0 and 100, inclusive.');
    }
    return '$_filterQuality($amount)';
  }

  static String rgb(int r, int g, int b) {
    if (r < -100 || r > 100) {
      throw ArgumentError('Red value must be between -100 and 100, inclusive.');
    }
    if (g < -100 || g > 100) {
      throw ArgumentError(
        'Green value must be between -100 and 100, inclusive.',
      );
    }
    if (b < -100 || b > 100) {
      throw ArgumentError(
        'Blue value must be between -100 and 100, inclusive.',
      );
    }
    return '$_filterRGB($r,$g,$b)';
  }

  static String roundCorner(int radiusInner, int radiusOuter, int color) {
    if (radiusInner < 1) {
      throw ArgumentError('Radius must be greater than zero.');
    }
    if (radiusOuter < 0) {
      throw ArgumentError(
        'Outer radius must be greater than or equal to zero.',
      );
    }

    var builder = '$_filterRoundCorner($radiusInner';

    if (radiusOuter > 0) {
      builder += '|';
      builder += '$radiusOuter';
    }
    final r = (color & 0xFF0000) >> 16;
    final g = (color & 0xFF00) >> 8;
    final b = color & 0xFF;

    return builder += ',$r,$g,$b)';
  }

  static String watermark(String imageUrl, int x, int y, int transparency) {
    if (imageUrl.isEmpty) {
      throw ArgumentError('Image URL must not be blank.');
    }
    if (transparency < 0 || transparency > 100) {
      throw ArgumentError('Transparency must be between 0 and 100, inclusive.');
    }
    return '$_filterWatermark($imageUrl,$x,$y,$transparency)';
  }

  static String sharpenLuminacenceOnly(double amount, double radius) {
    return '$_filterSharpen($amount,$radius,true)';
  }

  static String sharpen(double amount, double radius) {
    return '$_filterSharpen($amount,$radius,false)';
  }

  static String fill(int color) {
    return '$_filterFill(${color.toRadixString(16)})';
  }

  static String format(ImageFormat format) {
    return '$_filterFormat(${format.value})';
  }

  static String frame(String imageUrl) {
    if (imageUrl.isEmpty) {
      throw ArgumentError('Image URL must not be blank.');
    }
    return '$_filterFrame($imageUrl)';
  }

  static String stripicc() {
    return '$_filterStripICC()';
  }

  static String grayscale() {
    return '$_filterGrayscale()';
  }

  static String equalize() {
    return '$_filterEqualize()';
  }

  static String blur(int radius, int sigma) {
    if (radius < 1) {
      throw ArgumentError('Radius must be greater than zero.');
    }
    if (radius > 150) {
      throw ArgumentError('Radius must be lower or equal than 150.');
    }
    if (sigma < 0) {
      throw ArgumentError('Sigma must be greater than zero.');
    }
    return '$_filterBlur($radius,$sigma)';
  }

  static String noUpscale() {
    return '$_filterNoUpscale()';
  }

  static String rotate(int angle) {
    if (angle % 90 != 0) {
      throw ArgumentError('Angle must be multiple of 90°');
    }
    return '$_filterRotate($angle)';
  }
}
