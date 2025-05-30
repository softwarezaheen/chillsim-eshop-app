import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/promotion_apis/promotion_apis.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model.dart";
import "package:esim_open_source/domain/data/api_promotion.dart";

class APIPromotionImpl extends APIService implements APIPromotion {
  APIPromotionImpl._privateConstructor() : super.privateConstructor();

  static APIPromotionImpl? _instance;

  static APIPromotionImpl get instance {
    if (_instance == null) {
      _instance = APIPromotionImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMain<EmptyResponse?>> applyReferralCode({
    required String referralCode,
  }) async {
    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.applyReferralCode,
        parameters: <String, dynamic>{
          "referral_code": referralCode,
        },
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> redeemVoucher({
    required String voucherCode,
  }) async {
    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.redeemVoucher,
        parameters: <String, dynamic>{
          "code": voucherCode,
        },
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<BundleResponseModel?>> validatePromoCode({
    required String promoCode,
    required String bundleCode,
  }) async {
    Map<String, String> parameters = <String, String>{
      "promo_code": promoCode,
      "bundle_code": bundleCode,
    };

    ResponseMain<BundleResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.validatePromoCode,
        parameters: parameters,
      ),
      fromJson: BundleResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<RewardHistoryResponseModel>>>
      getRewardsHistory() async {
    ResponseMain<List<RewardHistoryResponseModel>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: PromotionApis.getRewardsHistory,
      ),
      fromJson: RewardHistoryResponseModel.fromJsonList,
    );
    return response;
  }
}
