import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

class FlutterEsimHelperTest {
  static MethodChannel channel = const MethodChannel("flutter_esim");

  static void implementFlutterEsim() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  }

  static void deInitFlutterEsim() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  }
}
