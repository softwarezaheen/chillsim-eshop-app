import "package:esim_open_source/core/presentation/util/flag_util.dart";
import "package:flutter_test/flutter_test.dart";

Future<void> main() async {
  // await EasyLocalization.ensureInitialized();

  setUp(() async {});

  test("call fromString returns value", () {
    BundleType.fromString("value");
  });

  test("call fromString returns value then call toString()", () {
    BundleType? type = BundleType.fromString("global");
    expect(type.toString(), "global");
  });
}
