import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/presentation/shared/deep_link_helper.dart";

class RedirectionsHelper {
  static RedirectionCategoryType fromNotificationValue({
    required String categoryID,
    String? iccID,
    String? cashbackPercent,
  }) {
    switch (categoryID) {
      case "1":
        return BuyBundle(); // get iccID and open qr code
      case "2":
        return BuyTopUp(); // get iccID and open qr code
      case "3":
        return RewardAvailable(); // not now
      case "4":
        return CashbackReward(cashbackPercent ?? ""); // not now
      case "5":
        return ConsumptionBundleDetail(iccID ?? ""); // get consumption details
      case "6":
        return PlanStarted(); // reload my eSIM
      case "7":
        return ShareBundleNotification(); // not now
      case "9":
        return WalletTopUpSuccess();
      case "10":
        return WalletTopUpFailed();
      default:
        return Empty();
    }
  }

  static RedirectionCategoryType fromDeepLinkValue(
    String value,
    Map<String, dynamic> params,
  ) {
    if (value.contains(DeepLinkDecodeKeys.referralCode.pathKey)) {
      return ReferAndEarn();
    } else if (value.contains(DeepLinkDecodeKeys.regionTab.pathKey)) {
      return RegionsTap();
    } else if (value.contains(DeepLinkDecodeKeys.countryTab.pathKey)) {
      return CountriesTap();
    } else if (value.contains(DeepLinkDecodeKeys.regionSelected.pathKey)) {
      String regionCode =
          params[DeepLinkDecodeKeys.regionSelected.decodingKey] ?? "";
      return RegionSelected(regionCode);
    } else if (value.contains(DeepLinkDecodeKeys.countrySelected.pathKey)) {
      String countryCode =
          params[DeepLinkDecodeKeys.countrySelected.decodingKey] ?? "";
      return CountrySelected(countryCode);
    }
    return Empty();
  }
}
