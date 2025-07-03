import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

class PackageInfoHelperTest {
  static MethodChannel channel =
      const MethodChannel("dev.fluttercommunity.plus/package_info");

  static void initPackageInfo() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case "getAll":
            return <String, dynamic>{
              "appName": "package_info_example",
              "buildNumber": "1",
              "packageName": "io.flutter.plugins.packageinfoexample",
              "version": "1.0",
              "installerStore": null,
            };
          default:
            assert(false);
            return null;
        }
      },
    );
  }

  static void deInitPackageInfo() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  }
}
