import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";

class DynamicLinkingServiceEmptyImpl implements DynamicLinkingService {
  @override
  Future<String?> generateBranchLink({
    required String deepLinkUrl,
    String? referUserID,
    String? title,
    String? description,
  }) async {
    return "";
  }

  @override
  Future<DynamicLinkingTrackingStatus> getTrackingAuthorizationStatus() async {
    return DynamicLinkingTrackingStatus.notDetermined;
  }

  @override
  Future<void> initialize({
    required Function({
      required bool isInitial,
      required Uri uri,
    }) onDeepLink,
    bool enableLogging = true,
    bool validateSDKIntegration = false,
  }) async {}

  @override
  Future<DynamicLinkingTrackingStatus> requestTrackingAuthorization() async {
    return DynamicLinkingTrackingStatus.notDetermined;
  }
}
