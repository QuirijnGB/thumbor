import 'package:test/test.dart';
import 'package:thumbor/thumbor.dart';

void main() {
  test('creates an instance of Thumbor with just the hostname', () {
    var thumbor = new Thumbor(host: "hostname");

    expect(thumbor.host, "hostname");
    expect(thumbor.key, isNull);
  });
  test('creates an instance of Thumbor with the hostname and a key', () {
    var thumbor = new Thumbor(host: "hostname", key: "4s3cr37k3y");

    expect(thumbor.host, "hostname");
    expect(thumbor.key, "4s3cr37k3y");
  });
}
