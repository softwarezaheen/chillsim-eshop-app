abstract interface class DynamicLinkingService {
  Future<void> initialize({
    required Function({
      required Uri uri,
      required bool isInitial,
    }) onDeepLink,
    bool enableLogging = true,
    bool validateSDKIntegration = false,
  });

  Future<DynamicLinkingTrackingStatus> requestTrackingAuthorization();

  Future<DynamicLinkingTrackingStatus> getTrackingAuthorizationStatus();

  Future<String?> generateBranchLink({
    required String deepLinkUrl,
    String? referUserID,
    String? title,
    String? description,
  });
}

enum DynamicLinkingTrackingStatus {
  /// The user has not yet received an authorization request dialog
  notDetermined,
  /// The device is restricted, tracking is disabled and the system can't show a request dialog
  restricted,
  /// The user denies authorization for tracking
  denied,
  /// The user authorizes access to tracking
  authorized,
  /// The platform is not iOS or the iOS version is below 14.0
  notSupported,
}
