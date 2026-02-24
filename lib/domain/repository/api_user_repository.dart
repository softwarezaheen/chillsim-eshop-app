import "dart:async";

import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/user/auto_topup_config_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/saved_payment_method_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_notification_response.dart";
import "package:esim_open_source/data/remote/responses/user/wallet_transaction_response.dart";
import "package:esim_open_source/domain/util/resource.dart";

abstract interface class ApiUserRepository {
  FutureOr<dynamic> getUserConsumption({required String iccID});

  FutureOr<dynamic> assignBundle({
    required String bundleCode,
    required String promoCode,
    required String referralCode,
    required String affiliateCode,
    required String paymentType,
    required RelatedSearchRequestModel relatedSearch,
    String? bearerToken,
    String? paymentMethodId,
    bool enableAutoTopup = false,
  });

  FutureOr<dynamic> topUpBundle({
    required String iccID,
    required String bundleCode,
    required String paymentType,
    bool enableAutoTopup = false,
    String? paymentMethodId,
  });

  FutureOr<Resource<List<UserNotificationModel>>> getUserNotifications({
    required int pageIndex,
    required int pageSize,
  });

  FutureOr<dynamic> setNotificationsRead();

  FutureOr<dynamic> getBundleExists({
    required String code,
  });

  FutureOr<dynamic> getBundleLabel({
    required String code,
    required String label,
  });

  FutureOr<dynamic> getMyEsimByIccID({required String iccID});

  FutureOr<dynamic> getMyEsimByOrder({
    required String orderID,
    String? bearerToken,
  });

  FutureOr<dynamic> getMyEsims();

  FutureOr<dynamic> getRelatedTopUp({
    required String iccID,
    required String bundleCode,
  });

  FutureOr<Resource<List<OrderHistoryResponseModel>?>> getOrderHistory({
    required int pageIndex,
    required int pageSize,
  });

  FutureOr<dynamic> getOrderByID({
    required String orderID,
  });

  FutureOr<dynamic> topUpWallet({
    required double amount,
    required String currency,
    String? paymentMethodId,
  });

  FutureOr<dynamic> cancelOrder({
    required String orderID,
  });

  FutureOr<dynamic> resendOrderOtp({
    required String orderID,
  });

  FutureOr<dynamic> verifyOrderOtp({
    required String otp,
    required String iccid,
    required String orderID,
  });

  FutureOr<dynamic> getUserBillingInfo();

  FutureOr<dynamic> setUserBillingInfo({
    required String email,
    required String firstName, required String lastName, required String country, required String city, String? phone,
    String? state,
    String? billingAddress,
    String? companyName,
    String? vatCode,
    String? tradeRegistry,
    bool? confirm,
    String? verifyBy,
  });

  FutureOr<dynamic> getTaxes({
    required String bundleCode,
  });

  FutureOr<Resource<List<WalletTransactionResponse>?>> getWalletTransactions({
    required int pageIndex,
    required int pageSize,
  });

  // Auto Top-Up
  FutureOr<Resource<AutoTopupConfigResponseModel?>> enableAutoTopup({
    required String iccid,
    required String bundleCode,
    String? userProfileId,
  });

  FutureOr<dynamic> disableAutoTopup({required String iccid});

  FutureOr<dynamic> getAutoTopupConfig({required String iccid});

  FutureOr<dynamic> getAutoTopupConfigs();

  FutureOr<dynamic> updateAutoTopupConfig({
    required String iccid,
    required Map<String, dynamic> data,
  });

  // Payment Methods
  FutureOr<Resource<List<SavedPaymentMethodResponseModel>>> getPaymentMethods();

  FutureOr<Resource<SavedPaymentMethodResponseModel>> setDefaultPaymentMethod({required String pmId});

  FutureOr<dynamic> deletePaymentMethod({required String pmId});

  FutureOr<Resource<List<SavedPaymentMethodResponseModel>>> syncPaymentMethods();
}
