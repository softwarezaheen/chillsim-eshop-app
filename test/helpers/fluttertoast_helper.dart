import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

class FluttertoastHelperTest {
  static const MethodChannel channel =
      MethodChannel("PonnamKarthik/fluttertoast");

  static void implementFluttertoast() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      return null;
    });
  }

  static void deInitFluttertoast() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  }
}
