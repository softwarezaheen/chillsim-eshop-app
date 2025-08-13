import "package:firebase_core/firebase_core.dart";
import "package:flutter/services.dart";
import "package:flutter_test/flutter_test.dart";

class FirebaseHelper {
  static const MethodChannel firebaseCoreChannel =
      MethodChannel("plugins.flutter.io/firebase_core");

  static const MethodChannel firebaseMessagingChannel =
      MethodChannel("plugins.flutter.io/firebase_messaging");

  static const MethodChannel firebaseCoreHostApiChannel = MethodChannel(
    "dev.flutter.pigeon.firebase_core_platform_interface.FirebaseCoreHostApi.initializeCore",
  );

  static Future<void> initFirebaseMock() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger

      // ✅ Mock the Pigeon FirebaseCoreHostApi channel
      ..setMockMethodCallHandler(firebaseCoreHostApiChannel,
          (MethodCall methodCall) async {
        if (methodCall.method == "initializeCore") {
          return <dynamic>[
            <String, Object>{
              "name": "[DEFAULT]",
              "options": <String, String>{
                "apiKey": "test-api-key",
                "appId": "test-app-id",
                "messagingSenderId": "test-sender-id",
                "projectId": "test-project-id",
              },
              "pluginConstants": <String, dynamic>{},
            }
          ];
        }
        return null;
      })

      // ✅ Mock the legacy Firebase Core channel
      ..setMockMethodCallHandler(firebaseCoreChannel,
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case "Firebase#initializeCore":
            return <String, dynamic>{
              "name": "[DEFAULT]",
              "options": <String, dynamic>{
                "apiKey": "test-api-key",
                "appId": "test-app-id",
                "messagingSenderId": "test-sender-id",
                "projectId": "test-project-id",
              },
              "pluginConstants": <String, dynamic>{},
            };
          case "Firebase#initializeApp":
            return <String, dynamic>{
              "name": methodCall.arguments?["appName"] ?? "[DEFAULT]",
              "options": methodCall.arguments?["options"] ??
                  <String, dynamic>{
                    "apiKey": "test-api-key",
                    "appId": "test-app-id",
                    "messagingSenderId": "test-sender-id",
                    "projectId": "test-project-id",
                  },
              "pluginConstants": <String, dynamic>{},
            };
          default:
            return null;
        }
      })

      // ✅ Mock Firebase Messaging
      ..setMockMethodCallHandler(firebaseMessagingChannel,
          (MethodCall methodCall) async {
        switch (methodCall.method) {
          case "Messaging#getToken":
            return "test-fcm-token";
          case "Messaging#requestPermission":
            return <String, dynamic>{
              "authorizationStatus": 1,
              "alert": true,
              "announcement": false,
              "badge": true,
              "carPlay": false,
              "criticalAlert": false,
              "provisional": false,
              "sound": true,
            };
          default:
            return null;
        }
      });

    try {
      await Firebase.initializeApp();
    } on Object catch (_) {
      // Ignore if already initialized
    }
  }

  static void deInitFirebaseMock() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      ..setMockMethodCallHandler(firebaseCoreHostApiChannel, null)
      ..setMockMethodCallHandler(firebaseCoreChannel, null)
      ..setMockMethodCallHandler(firebaseMessagingChannel, null);
  }
}
