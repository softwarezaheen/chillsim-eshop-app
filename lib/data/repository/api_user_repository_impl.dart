import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/data_source/esims_local_data_source.dart";
import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/data/remote/responses/user/user_notification_response.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiUserRepositoryImpl implements ApiUserRepository {
  ApiUserRepositoryImpl({
    required this.apiUserBundles,
    required this.repository,
  });

  final ApiUser apiUserBundles;
  final EsimsLocalDataSource repository;

  @override
  FutureOr<Resource<UserBundleConsumptionResponse?>> getUserConsumption({
    required String iccID,
  }) {
    return responseToResource(
      apiUserBundles.getUserConsumption(iccID: iccID),
    );
  }

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> assignBundle({
    required String bundleCode,
    required String promoCode,
    required String referralCode,
    required String affiliateCode,
    required String paymentType,
    required RelatedSearchRequestModel relatedSearch,
    String? bearerToken,
  }) {
    return responseToResource(
      apiUserBundles.assignBundle(
        bundleCode: bundleCode,
        promoCode: promoCode,
        referralCode: referralCode,
        affiliateCode: affiliateCode,
        paymentType: paymentType,
        bearerToken: bearerToken,
        relatedSearch: relatedSearch,
      ),
    );
  }

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> topUpBundle({
    required String iccID,
    required String bundleCode,
    required String paymentType,
  }) {
    return responseToResource(
      apiUserBundles.topUpBundle(
        iccID: iccID,
        bundleCode: bundleCode,
        paymentType: paymentType,
      ),
    );
  }

  @override
  FutureOr<Resource<List<UserNotificationModel>>> getUserNotifications({
    required int pageIndex,
    required int pageSize,
  }) {
    return responseToResource(
      apiUserBundles.getUserNotifications(
        pageIndex: pageIndex,
        pageSize: pageSize,
      ),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> setNotificationsRead() {
    return responseToResource(
      apiUserBundles.setNotificationsRead(),
    );
  }

  @override
  FutureOr<Resource<bool?>> getBundleExists({
    required String code,
  }) {
    return responseToResource(
      apiUserBundles.getBundleExists(code: code),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> getBundleLabel({
    required String code,
    required String label,
  }) {
    return responseToResource(
      apiUserBundles.getBundleLabel(code: code, label: label),
    );
  }

  @override
  FutureOr<Resource<PurchaseEsimBundleResponseModel?>> getMyEsimByIccID({
    required String iccID,
  }) {
    return responseToResource(
      apiUserBundles.getMyEsimByIccID(
        iccID: iccID,
      ),
    );
  }

  @override
  FutureOr<Resource<PurchaseEsimBundleResponseModel?>> getMyEsimByOrder({
    required String orderID,
    String? bearerToken,
  }) {
    return responseToResource(
      apiUserBundles.getMyEsimByOrder(
        orderID: orderID,
        bearerToken: bearerToken,
      ),
    );
  }

  @override
  FutureOr<Resource<List<PurchaseEsimBundleResponseModel>?>>
      getMyEsims() async {
    // no internet connection
    if (!await locator<ConnectivityService>().isConnected()) {
      List<PurchaseEsimBundleResponseModel>? dbEsim =
          repository.getPurchasedEsims();
      if (dbEsim != null) {
        return Resource<List<PurchaseEsimBundleResponseModel>?>.success(
          dbEsim,
          message: "",
        );
      } else {
        return Resource<List<PurchaseEsimBundleResponseModel>?>.error(
          "No internet connection",
        );
      }
    }

    try {
      Resource<List<PurchaseEsimBundleResponseModel>?> response =
          await responseToResource(
        apiUserBundles.getMyEsims(),
      );

      if (response.resourceType == ResourceType.success) {
        repository.replacePurchasedEsims(response.data);
      }

      return response;
    } on Object catch (ex) {
      log(ex.toString());
      List<PurchaseEsimBundleResponseModel>? dbEsim =
          repository.getPurchasedEsims();
      if (dbEsim != null) {
        return Resource<List<PurchaseEsimBundleResponseModel>?>.success(
          dbEsim,
          message: "",
        );
      } else {
        rethrow;
      }
    }
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>?>> getRelatedTopUp({
    required String iccID,
    required String bundleCode,
  }) {
    return responseToResource(
      apiUserBundles.getRelatedTopUp(
        iccID: iccID,
        bundleCode: bundleCode,
      ),
    );
  }

  @override
  FutureOr<Resource<List<OrderHistoryResponseModel>?>> getOrderHistory({
    required int pageIndex,
    required int pageSize,
  }) {
    return responseToResource(
      apiUserBundles.getOrderHistory(
        pageIndex: pageIndex,
        pageSize: pageSize,
      ),
    );
  }

  @override
  FutureOr<Resource<OrderHistoryResponseModel?>> getOrderByID({
    required String orderID,
  }) {
    return responseToResource(
      apiUserBundles.getOrderByID(
        orderID: orderID,
      ),
    );
  }

  @override
  FutureOr<Resource<BundleAssignResponseModel?>> topUpWallet({
    required double amount,
    required String currency,
  }) async {
    return responseToResource(
      apiUserBundles.topUpWallet(
        amount: amount,
        currency: currency,
      ),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> cancelOrder({
    required String orderID,
  }) async {
    return responseToResource(
      apiUserBundles.cancelOrder(
        orderID: orderID,
      ),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> resendOrderOtp({
    required String orderID,
  }) async {
    return responseToResource(
      apiUserBundles.resendOrderOtp(
        orderID: orderID,
      ),
    );
  }

  @override
  FutureOr<Resource<EmptyResponse?>> verifyOrderOtp({
    required String otp,
    required String iccid,
    required String orderID,
  }) async {
    return responseToResource(
      apiUserBundles.verifyOrderOtp(
        otp: otp,
        iccid: iccid,
        orderID: orderID,
      ),
    );
  }
}
