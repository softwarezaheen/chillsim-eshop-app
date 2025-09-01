// ignore_for_file: avoid_single_cascade_in_expression_statements

import "dart:developer";
import "dart:io";

import "package:esim_open_source/data/services/local_notification_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/main.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";

typedef HandlePushData = void Function({
  required bool isInitial,
  required bool isClicked,
  Map<String, dynamic>? handlePushData,
});

class PushNotificationServiceImpl implements PushNotificationService {
  PushNotificationServiceImpl._privateConstructor();

  static PushNotificationServiceImpl? _instance;

  static PushNotificationServiceImpl getInstance() {
    _instance ??= PushNotificationServiceImpl._privateConstructor();
    return _instance!;
  }

  HandlePushData? _handlePushData;

  static const String _channelID = "high_importance_channel"; // id
  static const String _channelTitle = "High Importance Notifications"; // title
  // static const String _channelDescription = "High Importance Notifications"; // title

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    _channelID, // id
    _channelTitle, // title
    importance: Importance.max,
  );

  @override
  Future<void> initialise({
    required void Function({
      required bool isClicked,
      required bool isInitial,
      Map<String, dynamic>? handlePushData,
    }) handlePushData,
  }) async {
    _handlePushData = handlePushData;
    if (Platform.isIOS) {
      NotificationSettings settings = await _messaging.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        log("User granted permission");
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        log("User granted provisional permission");
      } else {
        log("User declined or has not accepted permission");
      }
    } else if (Platform.isAndroid) {
      bool? accepted = await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      if (accepted ?? false) {
        log("User granted permission");
        await LocalNotificationService.getInstance();
        await _flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(_channel);
      } else {
        log("User declined or has not accepted permission");
      }
    }
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log("Got a message whilst in the foreground!");
      log("Message data: ${message.data}");

      if (message.notification != null) {
        log(
          "Message also contained a notification: ${message.notification}",
        );

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        _serialiseAndNavigate(message.data, false, false);

        if (notification != null && android != null) {
          if (android.imageUrl != null) {
            await LocalNotificationService.getInstance()
              ..showBigPictureNotificationHiddenLargeIcon(
                id: notification.hashCode,
                iconURL: android.imageUrl!,
                largeIconURL: android.imageUrl!,
                title: notification.title,
                summaryText: notification.body,
                payload: message.data,
              );
          } else {
            await LocalNotificationService.getInstance()
              ..showBigTextNotification(
                id: notification.hashCode,
                title: notification.title,
                bigText: notification.body,
                summaryText: notification.body,
                payload: message.data,
              );
          }
        }
      }
    });

    await LocalNotificationService.getInstance()
      ..selectNotificationSubject
          .stream
          .listen((Map<String, dynamic>? payload) async {
        _serialiseAndNavigate(payload, false, true);
      });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      _firebaseMessagingBackgroundHandler(
        message,
        false,
        true,
      );
    });

    // Handle when user taps on notification to open app
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) => _firebaseMessagingBackgroundHandler(
        message,
        false,
        true,
      ),
    );

    // Handle initial message if app was terminated
    final RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _firebaseMessagingBackgroundHandler(initialMessage, true, true);
    }
  }

  @override
  Future<String?> getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    log("FCM Token ====> $token");
    return token;
  }

  void _serialiseAndNavigate(
    Map<String, dynamic>? message,
    bool isInitial,
    bool isClicked,
  ) {
    log("Service: Push redirection triggered ==>> $message");
    _handlePushData?.call(
      handlePushData: message,
      isInitial: isInitial,
      isClicked: isClicked,
    );
  }
}

@pragma("vm:entry-point")
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
  bool isInitial,
  bool isClicked,
) async {
  await initializeFirebaseApp();

  log("Handling a background message: ${message.messageId}");
  PushNotificationServiceImpl.getInstance()
    .._serialiseAndNavigate(message.data, isInitial, isClicked);
}
