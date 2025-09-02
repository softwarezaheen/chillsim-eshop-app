import "dart:async";

import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/remote/responses/promotion/referral_info_response_model.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model.dart";
import "package:esim_open_source/domain/data/api_promotion.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiPromotionRepositoryImpl implements ApiPromotionRepository {
  ApiPromotionRepositoryImpl({
    required APIPromotion apiPromotion,
  }) : _apiPromotion = apiPromotion;

  final APIPromotion _apiPromotion;

  @override
  FutureOr<Resource<EmptyResponse?>> redeemVoucher({
    required String voucherCode,
  }) async {
    return responseToResource(
      _apiPromotion.redeemVoucher(voucherCode: voucherCode),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> applyReferralCode({
    required String referralCode,
  }) async {
    return responseToResource(
      _apiPromotion.applyReferralCode(referralCode: referralCode),
    );
  }

  @override
  FutureOr<Resource<BundleResponseModel?>> validatePromoCode({
    required String promoCode,
    required String bundleCode,
  }) async {
    return responseToResource(
      _apiPromotion.validatePromoCode(
        promoCode: promoCode,
        bundleCode: bundleCode,
      ),
    );
  }

  @override
  FutureOr<Resource<List<RewardHistoryResponseModel>>>
      getRewardsHistory() async {
    return responseToResource(
      _apiPromotion.getRewardsHistory(),
    );
  }

  @override
  FutureOr<Resource<ReferralInfoResponseModel?>> getReferralInfo() {
    return responseToResource(
      _apiPromotion.getReferralInfo(),
    );
  }
}
