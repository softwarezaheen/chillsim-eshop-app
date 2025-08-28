import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

class HapticHelperTest {
  static MethodChannel channel = const MethodChannel("vibrate");

  static void implementHaptic() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  }

  static void deInitHaptic() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  }
}
