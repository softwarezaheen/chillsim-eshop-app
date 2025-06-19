import "dart:async";

import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:flutter/foundation.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:flutter_branch_sdk/flutter_branch_sdk.dart";

class DynamicLinkingServiceImpl implements DynamicLinkingService {
  StreamSubscription<Map<dynamic, dynamic>>? _streamSubscription;

  void _validateSDKIntegration() {
    return FlutterBranchSdk.validateSDKIntegration();
  }

  @override
  Future<DynamicLinkingTrackingStatus> requestTrackingAuthorization() async {
    AppTrackingStatus appTrackingStatus =
        await FlutterBranchSdk.requestTrackingAuthorization();
    return switch (appTrackingStatus) {
      AppTrackingStatus.notDetermined =>
        DynamicLinkingTrackingStatus.notDetermined,
      AppTrackingStatus.restricted => DynamicLinkingTrackingStatus.restricted,
      AppTrackingStatus.denied => DynamicLinkingTrackingStatus.denied,
      AppTrackingStatus.authorized => DynamicLinkingTrackingStatus.authorized,
      AppTrackingStatus.notSupported =>
        DynamicLinkingTrackingStatus.notSupported,
    };
  }

  @override
  Future<DynamicLinkingTrackingStatus> getTrackingAuthorizationStatus() async {
    AppTrackingStatus appTrackingStatus =
        await FlutterBranchSdk.getTrackingAuthorizationStatus();
    return switch (appTrackingStatus) {
      AppTrackingStatus.notDetermined =>
        DynamicLinkingTrackingStatus.notDetermined,
      AppTrackingStatus.restricted => DynamicLinkingTrackingStatus.restricted,
      AppTrackingStatus.denied => DynamicLinkingTrackingStatus.denied,
      AppTrackingStatus.authorized => DynamicLinkingTrackingStatus.authorized,
      AppTrackingStatus.notSupported =>
        DynamicLinkingTrackingStatus.notSupported,
    };
  }

  @override
  Future<String?> generateBranchLink({
    required String deepLinkUrl,
    String? referUserID,
    String? title,
    String? description,
  }) async {
    try {
      // Create Branch Universal Object
      BranchUniversalObject buo = BranchUniversalObject(
        canonicalIdentifier:
            "app/generated_link_${DateTime.now().millisecondsSinceEpoch}",
        canonicalUrl: deepLinkUrl,
        title: title ?? referUserID ?? "Shared Content",
        contentDescription:
            description ?? "Generated link for user: $referUserID",
        contentMetadata: BranchContentMetaData()
          ..addCustomMetadata("userID", referUserID ?? "")
          ..addCustomMetadata("original_url", deepLinkUrl),
      );

      // Create Link Properties
      BranchLinkProperties linkProperties = BranchLinkProperties(
        channel: "app_share",
        feature: "sharing",
        campaign: "user_referral",
        tags: <String>["flutter", "user_generated"],
      )

        // Add control parameters
        ..addControlParam(r"$desktop_url", deepLinkUrl);

      if (referUserID != null) {
        linkProperties.addControlParam("userID", referUserID);
      }

      // Generate short URL
      BranchResponse<dynamic> response = await FlutterBranchSdk.getShortUrl(
        buo: buo,
        linkProperties: linkProperties,
      );

      if (response.success) {
        String generatedUrl = response.result;
        debugPrint("Successfully generated Branch link: $generatedUrl");
        return generatedUrl;
      } else {
        debugPrint(
          "Error generating Branch link: ${response.errorCode} - ${response.errorMessage}",
        );
        return null;
      }
    } on Object catch (e) {
      debugPrint("Exception generating Branch link: $e");
      return null;
    }
  }

  @override
  Future<void> initialize({
    required Function({
      required Uri uri,
      required bool isInitial,
    }) onDeepLink,
    bool enableLogging = true,
    bool validateSDKIntegration = false,
  }) async {
    await FlutterBranchSdk.init(
      enableLogging: enableLogging,
    );

    if (validateSDKIntegration) {
      _validateSDKIntegration();
    }

    _streamSubscription = FlutterBranchSdk.listSession().listen(
      (Map<dynamic, dynamic> data) {
        debugPrint("listenDynamicLinks - DeepLink Data: $data");
        // controllerData.sink.add(data);
        if(data.containsKey("original_url")){
          Uri? initialLink = Uri.tryParse(data["original_url"]);

          if (initialLink != null) {
            onDeepLink(uri: initialLink, isInitial: false);
          }
        }
        // if (data.containsKey("+clicked_branch_link") &&
        //     data["+clicked_branch_link"] == true) {
        //   //Link clicked. Add logic to get link data and route user to correct screen
        //   debugPrint('Custom string: ${data["custom_string"]}');
        // }
      },
      onError: (dynamic error) {
        PlatformException platformException = error as PlatformException;
        debugPrint(
          "InitSession error: ${platformException.code} - ${platformException.message}",
        );
      },
    );
  }

  Future<void> dispose() async {
    _streamSubscription?.cancel(); // Clean up listener
    _streamSubscription = null;
  }
}
