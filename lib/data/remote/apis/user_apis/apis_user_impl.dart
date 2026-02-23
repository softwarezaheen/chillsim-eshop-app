import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/user_apis/user_apis.dart";
import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_taxes_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/remote/responses/user/auto_topup_config_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/saved_payment_method_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/data/remote/responses/user/user_get_billing_info_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_notification_response.dart";
import "package:esim_open_source/data/remote/responses/user/wallet_transaction_response.dart";
import "package:esim_open_source/domain/data/api_user.dart";

class APIUserImpl extends APIService implements ApiUser {
  APIUserImpl._privateConstructor() : super.privateConstructor();

  static APIUserImpl? _instance;

  static APIUserImpl get instance {
    if (_instance == null) {
      _instance = APIUserImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMain<UserBundleConsumptionResponse?>> getUserConsumption({
    required String iccID,
  }) async {
    ResponseMain<UserBundleConsumptionResponse> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getUserConsumption,
        paramIDs: <String>[iccID],
      ),
      fromJson: UserBundleConsumptionResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<BundleAssignResponseModel?>> assignBundle({
    required String bundleCode,
    required String promoCode,
    required String referralCode,
    required String affiliateCode,
    required String paymentType,
    required RelatedSearchRequestModel relatedSearch,
    String? bearerToken,
    String? paymentMethodId,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "bundle_code": bundleCode,
      "promo_code": promoCode,
      "referral_code": referralCode,
      "affiliate_code": affiliateCode,
      "payment_type": paymentType,
      "related_search": relatedSearch.toJson(),
    };
    if (paymentMethodId != null && paymentMethodId.isNotEmpty) {
      params["payment_method_id"] = paymentMethodId;
    }

    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $bearerToken",
    };

    ResponseMain<BundleAssignResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.assignBundle,
        parameters: params,
        additionalHeaders:
            (bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: BundleAssignResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<BundleAssignResponseModel?>> topUpBundle({
    required String iccID,
    required String bundleCode,
    required String paymentType,
    bool enableAutoTopup = false,
    String? paymentMethodId,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "iccid": iccID,
      "bundle_code": bundleCode,
      "payment_type": paymentType,
      "enable_auto_topup": enableAutoTopup,
    };
    if (paymentMethodId != null && paymentMethodId.isNotEmpty) {
      params["payment_method_id"] = paymentMethodId;
    }

    ResponseMain<BundleAssignResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.topUpBundle,
        parameters: params,
      ),
      fromJson: BundleAssignResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<UserNotificationModel>>> getUserNotifications({
    required int pageIndex,
    required int pageSize,
  }) async {
    ResponseMain<List<UserNotificationModel>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getUserNotifications,
        queryParameters: <String, dynamic>{
          "page_index": pageIndex,
          "page_size": pageSize,
        },
      ),
      fromJson: UserNotificationModel.fromJsonList,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> setNotificationsRead() async {
    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.setNotificationsRead,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<bool?>> getBundleExists({
    required String code,
  }) async {
    ResponseMain<bool?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getBundleExists,
        paramIDs: <String>[code],
      ),
    );

    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> getBundleLabel({
    required String code,
    required String label,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{"label": label};
    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getBundleLabel,
        paramIDs: <String>[code],
        parameters: params,
      ),
      fromJson: EmptyResponse.fromJson,
    );

    return response;
  }

  @override
  Future<ResponseMain<PurchaseEsimBundleResponseModel?>> getMyEsimByIccID({
    required String iccID,
  }) async {
    ResponseMain<PurchaseEsimBundleResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getMyEsimByIccID,
        paramIDs: <String>[iccID],
      ),
      fromJson: PurchaseEsimBundleResponseModel.fromJson,
    );
    return response;
  }

  @override
  Future<ResponseMain<PurchaseEsimBundleResponseModel?>> getMyEsimByOrder({
    required String orderID,
    String? bearerToken,
  }) async {
    Map<String, String> headers = <String, String>{
      "Authorization": "Bearer $bearerToken",
    };

    ResponseMain<PurchaseEsimBundleResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getMyEsimByOrder,
        paramIDs: <String>[orderID],
        additionalHeaders:
            (bearerToken?.isNotEmpty ?? false) ? headers : <String, String>{},
      ),
      fromJson: PurchaseEsimBundleResponseModel.fromJson,
    );
    return response;
  }

  @override
  Future<ResponseMain<List<PurchaseEsimBundleResponseModel>?>>
      getMyEsims() async {
    ResponseMain<List<PurchaseEsimBundleResponseModel>?> response =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getMyEsims,
      ),
      fromJson: PurchaseEsimBundleResponseModel.fromJsonList,
    );
    return response;
  }

  @override
  Future<ResponseMain<List<BundleResponseModel>?>> getRelatedTopUp({
    required String iccID,
    required String bundleCode,
  }) async {
    ResponseMain<List<BundleResponseModel>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getRelatedTopUp,
        paramIDs: <String>[bundleCode, iccID],
      ),
      fromJson: BundleResponseModel.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<OrderHistoryResponseModel>?>> getOrderHistory({
    required int pageIndex,
    required int pageSize,
  }) async {
    ResponseMain<List<OrderHistoryResponseModel>?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getOrderHistory,
        queryParameters: <String, dynamic>{
          "page_index": pageIndex,
          "page_size": pageSize,
        },
      ),
      fromJson: OrderHistoryResponseModel.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<OrderHistoryResponseModel?>> getOrderByID({
    required String orderID,
  }) async {
    ResponseMain<OrderHistoryResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getOrderByID,
        paramIDs: <String>[orderID],
      ),
      fromJson: OrderHistoryResponseModel.fromJson,
    );
    return response;
  }

  @override
  Future<ResponseMain<BundleAssignResponseModel?>> topUpWallet({
    required double amount,
    required String currency,
    String? paymentMethodId,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "amount": amount,
      "currency": currency,
    };
    if (paymentMethodId != null && paymentMethodId.isNotEmpty) {
      params["payment_method_id"] = paymentMethodId;
    }

    ResponseMain<BundleAssignResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.topUpWallet,
        parameters: params,
      ),
      fromJson: BundleAssignResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> cancelOrder({
    required String orderID,
  }) async {
    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.cancelOrder,
        paramIDs: <String>[orderID],
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> resendOrderOtp({
    required String orderID,
  }) async {
    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.resendOrderOtp,
        paramIDs: <String>[orderID],
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> verifyOrderOtp({
    required String otp,
    required String iccid,
    required String orderID,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "otp": otp,
      "iccid": iccid,
      "order_id": orderID,
    };

    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.verifyOrderOtp,
        parameters: params,
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> setUserBillingInfo({
    required Map<String, dynamic> billingInfo,
  }) async {
    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.setUserBillingInfo,
        parameters: billingInfo,
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<UserGetBillingInfoResponseModel?>> getUserBillingInfo() async {
    ResponseMain<UserGetBillingInfoResponseModel?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getUserBillingInfo,
      ),
      fromJson: ({dynamic json}) => UserGetBillingInfoResponseModel.fromJson(json: json),
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<BundleTaxesResponseModel?>> getTaxes(
      {required String bundleCode, String? promoCode,}
  ) async {
    Map<String, dynamic> queryParams = <String, dynamic>{};
    if (promoCode != null && promoCode.isNotEmpty) {
      queryParams["promo_code"] = promoCode;
    }

    ResponseMain<BundleTaxesResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getTaxes,
        paramIDs: <String>[bundleCode],
        queryParameters: queryParams,
      ),
      fromJson: ({dynamic json}) => BundleTaxesResponseModel.fromJson(json: json),
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<WalletTransactionResponse>?>> getWalletTransactions({
    required int pageIndex,
    required int pageSize,
  }) async {
    ResponseMain<List<WalletTransactionResponse>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getWalletTransactions,
        queryParameters: <String, dynamic>{
          "page_index": pageIndex,
          "page_size": pageSize,
        },
      ),
      fromJson: ({dynamic json}) => (json as List<dynamic>)
          .map((dynamic item) => WalletTransactionResponse.fromJson(json: item))
          .toList(),
    );
    return response;
  }

  // ===================== Auto Top-Up =====================

  @override
  FutureOr<ResponseMain<AutoTopupConfigResponseModel?>> enableAutoTopup({
    required String iccid,
    required String bundleCode,
    String? userProfileId,
  }) async {
    ResponseMain<AutoTopupConfigResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.enableAutoTopup,
        parameters: <String, dynamic>{
          "iccid": iccid,
          "bundle_id": bundleCode,  // Backend expects bundle_id, not bundle_code
          "payment_method_id": null,  // Use user's default payment method
        },
      ),
      fromJson: AutoTopupConfigResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> disableAutoTopup({
    required String iccid,
  }) async {
    ResponseMain<EmptyResponse> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.disableAutoTopup,
        parameters: <String, dynamic>{
          "iccid": iccid,
        },
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<AutoTopupConfigResponseModel?>> getAutoTopupConfig({
    required String iccid,
  }) async {
    ResponseMain<AutoTopupConfigResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getAutoTopupConfig,
        paramIDs: <String>[iccid],
      ),
      fromJson: AutoTopupConfigResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<AutoTopupConfigResponseModel>?>>
      getAutoTopupConfigs() async {
    ResponseMain<List<AutoTopupConfigResponseModel>> response =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getAutoTopupConfigs,
      ),
      fromJson: ({dynamic json}) {
        // Backend returns: { "configs": [...], "count": 2 }
        final List<dynamic> configs = json["configs"] ?? <dynamic>[];
        return configs
            .map((dynamic item) => AutoTopupConfigResponseModel.fromJson(json: item))
            .toList();
      },
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<AutoTopupConfigResponseModel?>> updateAutoTopupConfig({
    required String iccid,
    required Map<String, dynamic> data,
  }) async {
    ResponseMain<AutoTopupConfigResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.updateAutoTopupConfig,
        paramIDs: <String>[iccid],
        parameters: data,
      ),
      fromJson: AutoTopupConfigResponseModel.fromJson,
    );
    return response;
  }

  // ===================== Payment Methods =====================

  @override
  FutureOr<ResponseMain<List<SavedPaymentMethodResponseModel>?>>
      getPaymentMethods() async {
    ResponseMain<List<SavedPaymentMethodResponseModel>> response =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.getPaymentMethods,
      ),
      fromJson: ({dynamic json}) {
        // Backend returns: { "payment_methods": [...], "count": 2 }
        final List<dynamic> paymentMethods = json["payment_methods"] ?? <dynamic>[];
        return paymentMethods
            .map((dynamic item) => SavedPaymentMethodResponseModel.fromJson(json: item))
            .toList();
      },
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<SavedPaymentMethodResponseModel?>> setDefaultPaymentMethod({
    required String pmId,
  }) async {
    ResponseMain<SavedPaymentMethodResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.setDefaultPaymentMethod,
        paramIDs: <String>[pmId, "default"],
      ),
      fromJson: SavedPaymentMethodResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<EmptyResponse?>> deletePaymentMethod({
    required String pmId,
  }) async {
    ResponseMain<EmptyResponse> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.deletePaymentMethod,
        paramIDs: <String>[pmId],
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<SavedPaymentMethodResponseModel>?>> syncPaymentMethods() async {
    ResponseMain<List<SavedPaymentMethodResponseModel>> response =
        await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: UserApis.syncPaymentMethods,
      ),
      fromJson: ({dynamic json}) {
        // Backend returns: { "payment_methods": [...], "count": N }
        final List<dynamic> paymentMethods = json["payment_methods"] ?? <dynamic>[];
        return paymentMethods
            .map((dynamic item) => SavedPaymentMethodResponseModel.fromJson(json: item))
            .toList();
      },
    );
    return response;
  }
}
