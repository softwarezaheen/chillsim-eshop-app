import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/shared/deep_link_helper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:share_plus/share_plus.dart";

class ShareReferralCodeBottomSheetViewModel extends BaseModel {
  String get referralCode => userAuthenticationService.referralCode;

  String get deepLink =>
      "https://${AppEnvironment.appEnvironmentHelper.websiteUrl}/${DeepLinkDecodeKeys.referralCode.referralCodePathKey}?${DeepLinkDecodeKeys.referralCode}=$referralCode";

  String get amount => "5 USD";

  Future<void> shareButtonTapped() async {
    Share.share(
      LocaleKeys.shareReferral_fullLinkText.tr(
        namedArgs: <String, String>{
          "amount": amount,
          "code": referralCode,
          "link": deepLink,
        },
      ),
    );
  }
}
