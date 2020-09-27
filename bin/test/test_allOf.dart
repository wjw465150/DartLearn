import 'package:test/test.dart';

void main() {
  test('.split() splits the string on the delimiter', () {
    expect(
        'foo,bar,baz',
        allOf([
          contains('foo'),
          isNot(startsWith('bar')),
          // ignore: prefer_single_quotes
          endsWith("baz")
        ]));
  });
}
