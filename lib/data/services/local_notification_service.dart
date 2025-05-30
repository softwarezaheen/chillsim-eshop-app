import "dart:convert";
import "dart:io";

import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:http/http.dart" as http;
import "package:path_provider/path_provider.dart";
import "package:rxdart/rxdart.dart";

class LocalNotificationService {
  LocalNotificationService._privateConstructor();

  static LocalNotificationService? _instance;

  static Future<LocalNotificationService> getInstance() async {
    if (_instance == null) {
      _instance = LocalNotificationService._privateConstructor();
      await _instance?._initialise();
    }
    return _instance!;
  }

  int _id = 0;

  static const String _channelID = "high_importance_channel"; // id
  static const String _channelTitle = "High Importance Notifications"; // title
  static const String _channelDescription =
      "High Importance Notifications"; // title

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<Map<String, dynamic>?> selectNotificationSubject =
      BehaviorSubject<Map<String, dynamic>?>();

  Future<void> _initialise() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@drawable/ic_notification");

    /// Note: permissions aren't requested here just to demonstrate that can be
    /// done later
    final DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        Map<String, dynamic>? payload;
        if (details.payload != null && details.payload!.isNotEmpty) {
          try {
            payload = jsonDecode(details.payload ?? "");
          } on Object catch (_) {}
        }
        selectNotificationSubject.add(payload);
      },
    );
  }

  Future<void> showBigPictureNotificationHiddenLargeIcon({
    required String iconURL,
    required String largeIconURL,
    required String? title,
    required String? summaryText,
    int? id,
    Map<String, dynamic>? payload,
  }) async {
    final String largeIconPath =
        await _downloadAndSaveFile(iconURL, "largeIcon");
    final String bigPicturePath =
        await _downloadAndSaveFile(largeIconURL, "bigPicture");
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath),
      hideExpandedLargeIcon: true,
      contentTitle: title,
      htmlFormatContentTitle: true,
      summaryText: summaryText,
      htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      _channelID,
      _channelTitle,
      channelDescription: _channelDescription,
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );
    String? payloadStr;
    if (payload != null) {
      payloadStr = jsonEncode(payload);
    }
    await flutterLocalNotificationsPlugin.show(
      id ?? _id++,
      title,
      summaryText,
      platformChannelSpecifics,
      payload: payloadStr,
    );
  }

  Future<void> showBigTextNotification({
    int? id,
    String? bigText,
    String? title,
    String? summaryText,
    Map<String, dynamic>? payload,
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      _channelID,
      _channelTitle,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      icon: "@drawable/ic_notification",
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(),
    );

    String? payloadStr;
    if (payload != null) {
      payloadStr = jsonEncode(payload);
    }

    await flutterLocalNotificationsPlugin.show(
      id ?? _id++,
      title,
      summaryText,
      platformChannelSpecifics,
      payload: payloadStr,
    );
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = "${directory.path}/$fileName";
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}
