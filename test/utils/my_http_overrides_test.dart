import "dart:io";

import "package:esim_open_source/utils/my_http_overrides.dart";
import "package:flutter_test/flutter_test.dart";

Future<void> main() async {
  group("MyHttpOverrides Tests", () {
    test("creates instance successfully", () {
      final MyHttpOverrides overrides = MyHttpOverrides();
      expect(overrides, isA<MyHttpOverrides>());
      expect(overrides, isA<HttpOverrides>());
    });

    test("is subclass of HttpOverrides", () {
      final MyHttpOverrides overrides = MyHttpOverrides();
      expect(overrides, isA<HttpOverrides>());
    });

    test("multiple instances are independent", () {
      final MyHttpOverrides overrides1 = MyHttpOverrides();
      final MyHttpOverrides overrides2 = MyHttpOverrides();

      expect(overrides1, isNot(same(overrides2)));
      expect(overrides1, isA<MyHttpOverrides>());
      expect(overrides2, isA<MyHttpOverrides>());
    });
  });
}
