// date_time_utils_test.dart

import "package:esim_open_source/utils/date_time_utils.dart";
import "package:flutter_test/flutter_test.dart";

Future<void> main() async {
  // await EasyLocalization.ensureInitialized();

  setUp(() async {});

  test("call formatTimestampToDate returns value", () {
    String result = DateTimeUtils.formatTimestampToDate(
      timestamp: 1753865728,
      format: DateTimeUtils.ddMmYyyy,
    );
    expect(result, isNotEmpty);
  });
  test("call formatTimestampToDate returns value", () {
    String result = DateTimeUtils.formatTimestampToDate(
      timestamp: 175381056056028,
      format: DateTimeUtils.ddMmYyyy,
    );
    expect(result, isEmpty);
  });

  tearDown(() async {
    // await tearDownTest();
  });

  tearDownAll(() async {
    // await tearDownAllTest();
  });
}
