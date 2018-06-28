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
        "http://thumbor.example.com/qZKaZJPvUX+spYpawhsBv320rmA=/http://images.google.com/im-feeling-lucky.jpg");
  });

  test('creates a safe instance of ThumborUrl and gets the safe url', () {
    var thumborUrl = new ThumborUrl(
        host: "http://thumbor.example.com/",
        key: "1234567890",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg");

    expect(thumborUrl.toSafeUrl(),
        "http://thumbor.example.com/qZKaZJPvUX+spYpawhsBv320rmA=/http://images.google.com/im-feeling-lucky.jpg");
  });
}
