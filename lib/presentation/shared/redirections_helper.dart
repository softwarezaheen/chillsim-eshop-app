import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";
import "package:esim_open_source/presentation/shared/deep_link_helper.dart";

class RedirectionsHelper {
  static RedirectionCategoryType fromNotificationValue(
    String value,
    String? iccid,
  ) {
    switch (value) {
      case "1":
        return BuyBundle(); // get iccid and open qr code
      case "2":
        return BuyTopUp(); // get iccid and open qr code
      case "3":
        return RewardAvailable(); // not now
      case "4":
        return CashbackReward(); // not now
      case "5":
        return ConsumptionBundleDetail(iccid ?? ""); // get consumption details
      case "6":
        return PlanStarted(); // reload my esims
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
  ) {
    if (value.contains(DeepLinkDecodeKeys.referralCode.referralCodePathKey)) {
      return ReferAndEarn();
    }
    return Empty();
  }
}
