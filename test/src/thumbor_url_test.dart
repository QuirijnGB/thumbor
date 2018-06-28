import 'package:flutter_thumbor/src/thumbor_url.dart';
import 'package:test/test.dart';

void main() {
  test('creates an instance of ThumborUrl with just the hostname', () {
    var thumborUrl = ThumborUrl(
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
    var thumborUrl = ThumborUrl(
        host: "http://thumbor.example.com/",
        imageUrl: "http://images.google.com/im-feeling-lucky.jpg");

    expect(thumborUrl.url(),
        "http://thumbor.example.com/unsafe/http://images.google.com/im-feeling-lucky.jpg");
  });
}
