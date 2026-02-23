import "dart:async";

import "package:esim_open_source/data/remote/request/related_search.dart";

abstract interface class ApiUser {
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
  });

  FutureOr<dynamic> topUpBundle({
    required String iccID,
    required String bundleCode,
    required String paymentType,
    bool enableAutoTopup = false,
    String? paymentMethodId,
  });

  FutureOr<dynamic> getUserNotifications({
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

  FutureOr<dynamic> getMyEsims();

  FutureOr<dynamic> getMyEsimByIccID({
    required String iccID,
  });

  FutureOr<dynamic> getMyEsimByOrder({
    required String orderID,
    String? bearerToken,
  });

  FutureOr<dynamic> getRelatedTopUp({
    required String iccID,
    required String bundleCode,
  });

  FutureOr<dynamic> getOrderHistory({
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

  FutureOr<dynamic> setUserBillingInfo({
    required Map<String, dynamic> billingInfo,
  });

  FutureOr<dynamic> getUserBillingInfo();

  FutureOr<dynamic> getTaxes({
    required String bundleCode,
    String? promoCode,
  });

  FutureOr<dynamic> getWalletTransactions({
    required int pageIndex,
    required int pageSize,
  });

  // Auto Top-Up
  FutureOr<dynamic> enableAutoTopup({
    required String iccid,
    required String bundleCode,
    String? userProfileId,
  });

  FutureOr<dynamic> disableAutoTopup({
    required String iccid,
  });

  FutureOr<dynamic> getAutoTopupConfig({
    required String iccid,
  });

  FutureOr<dynamic> getAutoTopupConfigs();

  FutureOr<dynamic> updateAutoTopupConfig({
    required String iccid,
    required Map<String, dynamic> data,
  });

  // Payment Methods
  FutureOr<dynamic> getPaymentMethods();

  FutureOr<dynamic> setDefaultPaymentMethod({
    required String pmId,
  });

  FutureOr<dynamic> deletePaymentMethod({
    required String pmId,
  });

  FutureOr<dynamic> syncPaymentMethods();
}
