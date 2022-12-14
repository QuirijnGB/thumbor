import 'package:flutter_test/flutter_test.dart';
import 'package:thumbor/src/thumbor_url.dart';

void main() {
  test('creates an instance of ThumborUrl with just the hostname', () {
    final thumborUrl = ThumborUrl(
      host: 'hostname',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    );

    expect(thumborUrl.host, 'hostname');
    expect(thumborUrl.key, isNull);
    expect(
      thumborUrl.imageUrl,
      'http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test('creates an unsafe instance of ThumborUrl and gets the url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    );

    expect(
      thumborUrl.toUrl(),
      'http://thumbor.example.com/unsafe/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test('creates an unsafe instance of ThumborUrl and gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    );

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test('creates a safe instance of ThumborUrl and gets the url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      key: '1234567890',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    );

    expect(
      thumborUrl.toUrl(),
      'http://thumbor.example.com/qZKaZJPvUX-spYpawhsBv320rmA=/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test('creates a safe instance of ThumborUrl then gets the safe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      key: '1234567890',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    );

    expect(
      thumborUrl.toSafeUrl(),
      'http://thumbor.example.com/qZKaZJPvUX-spYpawhsBv320rmA=/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with trim and gets the '
      'unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..trim();

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/trim/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with trim and orientation '
      'and gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..trim(orientation: TrimOrientation.bottomRight);
    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/trim:bottom-right/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with trim, orientation '
      'and tolerance then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..trim(orientation: TrimOrientation.bottomRight, tolerance: 155);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/trim:bottom-right:155/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a '
      'crop then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..crop(1, 2, 3, 4);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/2x1:4x3/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a resize '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..resize(height: 200, width: 300);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/300x200/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a resize '
      'and an original height then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..resize(height: ThumborUrl.originalSize, width: 300);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/300xorig/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a resize '
      'and an original width then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..resize(height: 200, width: ThumborUrl.originalSize);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/origx200/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a resize horizontal flip '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..flipHorizontally();

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/-300x200/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a resize vertical flip '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..flipVertically();

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/300x-200/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a smart resize '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..smart();

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/300x200/smart/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a horizontal align '
      'resize then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..horizontalAlign(HorizontalAlignment.right);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/300x200/right/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a vertical align '
      'resize then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..verticalAlign(VerticalAlignment.middle);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/300x200/middle/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a vertical and horizontal '
      'align resize then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..horizontalAlign(HorizontalAlignment.right)
      ..verticalAlign(VerticalAlignment.middle);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/300x200/right/middle/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a vertical and '
      'horizontal align resize then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..fitIn(FitInStyle.adaptive);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/adaptive-fit-in/300x200/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a vertical and '
      'horizontal align resize then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..fitIn(FitInStyle.normal);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/fit-in/300x200/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a vertical '
      'and horizontal align resize then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )
      ..resize(height: 200, width: 300)
      ..fitIn(FitInStyle.full);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/full-fit-in/300x200/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a brightness filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.brightness(80)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:brightness(80)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a contrast filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.contrast(80)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:contrast(80)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a noise filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.noise(80)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:noise(80)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a quality filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.quality(80)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:quality(80)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a rgb filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.rgb(0, 1, 2)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:rgb(0,1,2)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a round_corner filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.roundCorner(10, 20, 0xFFFFFF)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:round_corner(10|20,255,255,255)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a watermark filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([
        ThumborUrl.watermark(
          'http://images.google.com/watermark.jpg',
          0,
          10,
          50,
        )
      ]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:watermark(http://images.google.com/watermark.jpg,0,10,50)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a sharpen filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([
        ThumborUrl.sharpenLuminacenceOnly(
          10,
          20,
        )
      ]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:sharpen(10.0,20.0,true)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a fill filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.fill(0xFF00FF)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:fill(ff00ff)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a format filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.format(ImageFormat.gif)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:format(gif)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a format filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.format(ImageFormat.jpeg)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:format(jpeg)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a format filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.format(ImageFormat.png)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:format(png)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a format filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.format(ImageFormat.webp)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:format(webp)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a frame filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.frame('http://images.google.com/frame.jpg')]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:frame(http://images.google.com/frame.jpg)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a stripICC filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.stripicc()]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:strip_icc()/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a grayscale filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.grayscale()]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:grayscale()/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a equalize filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.equalize()]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:equalize()/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a blur filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.blur(100, 300)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:blur(100,300)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a no_upscale filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.noUpscale()]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:no_upscale()/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a rotate filter '
      'then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.rotate(90)]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:rotate(90)/http://images.google.com/im-feeling-lucky.jpg',
    );
  });

  test(
      'creates an unsafe instance of ThumborUrl with a rotate '
      'and noUpscale filter then gets the unsafe url', () {
    final thumborUrl = ThumborUrl(
      host: 'http://thumbor.example.com/',
      imageUrl: 'http://images.google.com/im-feeling-lucky.jpg',
    )..filter([ThumborUrl.rotate(90), ThumborUrl.noUpscale()]);

    expect(
      thumborUrl.toUnsafeUrl(),
      'http://thumbor.example.com/unsafe/filters:rotate(90):no_upscale()/http://images.google.com/im-feeling-lucky.jpg',
    );
  });
}

