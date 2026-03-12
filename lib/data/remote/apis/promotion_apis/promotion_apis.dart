import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum PromotionApis implements URlRequestBuilder {
  redeemVoucher,
  applyReferralCode,
  validatePromoCode,
  getRewardsHistory,
  getReferralProgress;

  @override
  String get baseURL => "";

  @override
  String get path {
    switch (this) {
      case PromotionApis.redeemVoucher:
        return "/api/v1/voucher/redeem";
      case PromotionApis.applyReferralCode:
        return "/api/v1/promotion/referral_code";
      case PromotionApis.validatePromoCode:
        return "/api/v1/promotion/validation";
      case PromotionApis.getRewardsHistory:
        return "/api/v1/promotion/usage-history"; // Updated to new endpoint
      case PromotionApis.getReferralProgress:
        return "/api/v1/promotion/referral-progress";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case PromotionApis.redeemVoucher:
      case PromotionApis.applyReferralCode:
      case PromotionApis.validatePromoCode:
        return HttpMethod.POST;
      case PromotionApis.getRewardsHistory:
      case PromotionApis.getReferralProgress:
        return HttpMethod.GET;
    }
  }

  @override
  bool get hasAuthorization => true;

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers => const <String, String>{};
}
