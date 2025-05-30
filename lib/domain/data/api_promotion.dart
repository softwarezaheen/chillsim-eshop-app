import "dart:async";

abstract interface class APIPromotion {
  FutureOr<dynamic> redeemVoucher({
    required String voucherCode,
  });

  FutureOr<dynamic> applyReferralCode({
    required String referralCode,
  });

  FutureOr<dynamic> validatePromoCode({
    required String promoCode,
    required String bundleCode,
  });

  FutureOr<dynamic> getRewardsHistory();
}
