import "package:esim_open_source/utils/constants.dart";
import "package:flutter_test/flutter_test.dart";

Future<void> main() async {
  group("Constants Tests", () {
    test("MAIN_BASE_URL is not empty", () {
      expect(MAIN_BASE_URL, isNotEmpty);
      expect(MAIN_BASE_URL, isA<String>());
    });

    test("TENANT is not empty", () {
      expect(TENANT, isNotEmpty);
      expect(TENANT, isA<String>());
    });

    test("POLICY_ID is not empty", () {
      expect(POLICY_ID, isNotEmpty);
      expect(POLICY_ID, isA<String>());
    });

    test("PARENT_ID is not empty", () {
      expect(PARENT_ID, isNotEmpty);
      expect(PARENT_ID, isA<String>());
    });

    test("MAIN_DOMAIN_AUTH_URL is not empty", () {
      expect(MAIN_DOMAIN_AUTH_URL, isNotEmpty);
      expect(MAIN_DOMAIN_AUTH_URL, isA<String>());
    });

    test("TERMS_AND_CONDITIONS_URL is valid URL format", () {
      expect(TERMS_AND_CONDITIONS_URL, isNotEmpty);
      expect(TERMS_AND_CONDITIONS_URL, startsWith("https://"));
    });

    test("pagination constants have valid values", () {
      expect(PAGE_SIZE, equals(10));
      expect(PAGE_SIZE, greaterThan(0));
      expect(PAGE_INDEX_START, equals(1));
      expect(PAGE_INDEX_START, greaterThan(0));
    });

    test("media upload constants have valid dimensions", () {
      expect(THUMBNAIL_WIDTH, equals(50));
      expect(THUMBNAIL_WIDTH, greaterThan(0));
      expect(THUMBNAIL_HEIGHT, equals(500));
      expect(THUMBNAIL_HEIGHT, greaterThan(0));
    });
  });
}
