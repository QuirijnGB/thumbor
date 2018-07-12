import 'package:test/test.dart';
import 'package:thumbor/src/thumbor_url.dart';

void main() {
  test('creates an instance of ThumborUrl with just the hostname', () {
    var thumborUrl = new ThumborUrl(
        host: "hostname",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg");

    expect(thumborUrl.host, "hostname");
    expect(thumborUrl.key, isNull);
    expect(
      thumborUrl.imageUrl,
      "http://images.google.com/im-feeling-lucky.jpg",
    );
  });

  test('creates an unsafe instance of ThumborUrl and gets the url', () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg");

    expect(thumborUrl.toUrl(),
        "http://thumbor.example.com/unsafe/http://images.google.com/im-feeling-lucky.jpg");
  });

  test('creates an unsafe instance of ThumborUrl and gets the unsafe url', () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg");

    expect(thumborUrl.toUnsafeUrl(),
        "http://thumbor.example.com/unsafe/http://images.google.com/im-feeling-lucky.jpg");
  });

  test('creates a safe instance of ThumborUrl and gets the url', () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        key: "1234567890",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg");

    expect(thumborUrl.toUrl(),
        "http://thumbor.example.com/qZKaZJPvUX-spYpawhsBv320rmA=/http://images.google.com/im-feeling-lucky.jpg");
  });

  test('creates a safe instance of ThumborUrl then gets the safe url', () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        key: "1234567890",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg");

    expect(thumborUrl.toSafeUrl(),
        "http://thumbor.example.com/qZKaZJPvUX-spYpawhsBv320rmA=/http://images.google.com/im-feeling-lucky.jpg");
  });

  test(
      'creates an unsafe instance of ThumborUrl with trim and gets the unsafe url',
      () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg")
      ..trim();

    expect(thumborUrl.toUnsafeUrl(),
        "http://thumbor.example.com/unsafe/trim/http://images.google.com/im-feeling-lucky.jpg");
  });

  test(
      'creates an unsafe instance of ThumborUrl with trim and orientation and gets the unsafe url',
      () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg")
      ..trim(orientation: TrimOrientation.bottomRight);
    expect(thumborUrl.toUnsafeUrl(),
        "http://thumbor.example.com/unsafe/trim:bottom-right/http://images.google.com/im-feeling-lucky.jpg");
  });

  test(
      'creates an unsafe instance of ThumborUrl with trim, orientation and tolerance then gets the unsafe url',
      () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg")
      ..trim(orientation: TrimOrientation.bottomRight, tolerance: 155);

    expect(thumborUrl.toUnsafeUrl(),
        "http://thumbor.example.com/unsafe/trim:bottom-right:155/http://images.google.com/im-feeling-lucky.jpg");
  });

  test(
      'creates an unsafe instance of ThumborUrl with a crop then gets the unsafe url',
      () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg")
      ..crop(1, 2, 3, 4);

    expect(thumborUrl.toUnsafeUrl(),
        "http://thumbor.example.com/unsafe/2x1:4x3/http://images.google.com/im-feeling-lucky.jpg");
  });

  test(
      'creates an unsafe instance of ThumborUrl with a resize then gets the unsafe url',
      () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg")
      ..resize(height: 200, width: 300);

    expect(thumborUrl.toUnsafeUrl(),
        "http://thumbor.example.com/unsafe/300x200/http://images.google.com/im-feeling-lucky.jpg");
  });
}
