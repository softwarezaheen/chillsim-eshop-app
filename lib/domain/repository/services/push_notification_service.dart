abstract class PushNotificationService {
  Future<void> initialise({
    required void Function({
      required bool isClicked,
      required bool isInitial,
      Map<String, dynamic>? handlePushData,
    }) handlePushData,
  });
  Future<String?> getFcmToken();
}
