import "dart:developer";
import "dart:ui";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/dynamic_linking_service.dart";
import "package:esim_open_source/presentation/shared/deep_link_helper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:share_plus/share_plus.dart";

class ShareReferralCodeBottomSheetViewModel extends BaseModel {
  String get referralCode => userAuthenticationService.referralCode;

  String get deepLink =>
      "https://${AppEnvironment.appEnvironmentHelper.websiteUrl}/${DeepLinkDecodeKeys.referralCode.pathKey}?${DeepLinkDecodeKeys.referralCode.decodingKey}=$referralCode";

  String get referredDiscountPercentage => locator<AppConfigurationService>().referredDiscountPercentage;
  String get referAndEarnAmount => locator<AppConfigurationService>().referAndEarnAmount;

  Future<void> shareButtonTapped({required Rect sharePositionOrigin}) async {
    if (isBusy) {
      return;
    }
    setBusy(true);
    try {
      final bool useBranch = AppEnvironment.appEnvironmentHelper.enableBranchIO;

      String? link;
      if (useBranch) {
        link = await locator<DynamicLinkingService>()
            .generateBranchLink(deepLinkUrl: deepLink, referUserID: referralCode);
      }

      log(deepLink);

      final String shareLink = (useBranch ? link : null) ?? deepLink;

      await SharePlus.instance.share(
        ShareParams(
          text: LocaleKeys.shareReferral_fullLinkText.tr(
            namedArgs: <String, String>{
              "amount": referredDiscountPercentage,
              "code": referralCode,
              "link": shareLink,
            },
          ),
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } on Object catch (e) {
      debugPrint("Error sharing referral code: $e");
    } finally {
      setBusy(false);
    }
  }
}
