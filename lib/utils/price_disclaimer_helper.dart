import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class PriceDisclaimerHelper {
  /// Generates dynamic price disclaimer text based on tax_mode and fee_enabled configurations
  /// 
  /// Returns appropriate disclaimer based on:
  /// - tax_mode: "inclusive", "exclusive", or "none"
  /// - fee_enabled: true or false
  static String getPriceDisclaimerText() {
    try {
      final appConfig = locator<AppConfigurationService>();
      final taxMode = appConfig.taxMode.toLowerCase();
      final feeEnabled = appConfig.feeEnabled;

      // Tax mode: inclusive - tax is already included in displayed price
      // Tax mode: exclusive - tax will be added at checkout  
      // Tax mode: none - no tax applied
      // Fee enabled: true - transaction fee will be added
      // Fee enabled: false - no transaction fee

      if (taxMode == "inclusive") {
        if (feeEnabled) {
          // Price includes tax, but fees will be added
          return "bundleInfo_priceDisclaimerText_inclusive_with_fees".tr();
        } else {
          // Price includes tax, no fees
          return "bundleInfo_priceDisclaimerText_inclusive_no_fees".tr();
        }
      } else if (taxMode == "exclusive") {
        if (feeEnabled) {
          // Tax and fees both added at checkout
          return "bundleInfo_priceDisclaimerText_exclusive_with_fees".tr();
        } else {
          // Only tax added at checkout
          return "bundleInfo_priceDisclaimerText_exclusive_no_fees".tr();
        }
      } else {
        // tax_mode == "none"
        if (feeEnabled) {
          // No tax, but fees apply
          return "bundleInfo_priceDisclaimerText_none_with_fees".tr();
        } else {
          // No tax, no fees - final price
          return "bundleInfo_priceDisclaimerText_none_no_fees".tr();
        }
      }
    } catch (e) {
      // Fallback to default if configurations aren't loaded yet
      return LocaleKeys.bundleInfo_priceDisclaimerText.tr();
    }
  }
}
