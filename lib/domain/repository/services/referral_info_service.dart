abstract class ReferralInfoService {
  String get getReferralMessage;
  String get getReferralAmount;
  String get getReferralCurrency;
  String get getReferralAmountAndCurrency;

  Future<void> refreshReferralInfo();
}
