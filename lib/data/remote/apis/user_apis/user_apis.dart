import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";

enum UserApis implements URlRequestBuilder {
  getUserConsumption,
  assignBundle,
  topUpBundle,
  getUserNotifications,
  setNotificationsRead,
  getBundleExists,
  getBundleLabel,
  getMyEsims,
  getMyEsimByIccID,
  getMyEsimByOrder,
  getRelatedTopUp,
  getOrderHistory,
  getOrderByID,
  topUpWallet,
  getWalletTransactions,
  cancelOrder,
  resendOrderOtp,
  verifyOrderOtp,
  setUserBillingInfo,
  getUserBillingInfo,
  getTaxes,
  // Auto Top-Up
  enableAutoTopup,
  disableAutoTopup,
  getAutoTopupConfig,
  getAutoTopupConfigs,
  updateAutoTopupConfig,
  // Payment Methods
  getPaymentMethods,
  setDefaultPaymentMethod,
  deletePaymentMethod,
  syncPaymentMethods;

  @override
  String get baseURL => "";

  @override
  String get path {
    switch (this) {
      case UserApis.getUserConsumption:
        return "/api/v1/user/consumption";
      case UserApis.assignBundle:
        return "/api/v1/user/bundle/assign";
      case UserApis.topUpBundle:
        return "/api/v1/user/bundle/assign-top-up";
      case UserApis.getUserNotifications:
        return "/api/v1/user/user-notification";
      case UserApis.setNotificationsRead:
        return "/api/v1/user/read-user-notification/";
      case UserApis.getBundleExists:
        return "/api/v1/user/bundle-exists";
      case UserApis.getBundleLabel:
        return "/api/v1/user/bundle-label-by-iccid";
      case UserApis.getMyEsims:
        return "/api/v1/user/my-esim";
      case UserApis.getMyEsimByIccID:
        return "/api/v1/user/my-esim";
      case UserApis.getMyEsimByOrder:
        return "/api/v1/user/my-esim-by-order";
      case UserApis.getRelatedTopUp:
        return "/api/v1/user/related-topup"; // /bundleCode/iccId
      case UserApis.getOrderHistory:
        return "/api/v1/user/order-history";
      case UserApis.getOrderByID:
        return "/api/v1/user/order-history";
      case UserApis.topUpWallet:
        return "/api/v1/wallet/top-up";
      case UserApis.getWalletTransactions:
        return "/api/v1/wallet/transactions";
      case UserApis.cancelOrder:
        return "/api/v1/user/order/cancel";
      case UserApis.resendOrderOtp:
        return "/api/v1/user/bundle/resend_order_otp";
      case UserApis.verifyOrderOtp:
        return "/api/v1/user/bundle/verify_order_otp";
      case UserApis.setUserBillingInfo:
        return "/api/v1/user/save-billing-info";
      case UserApis.getUserBillingInfo:
        return "/api/v1/user/get-billing-info";
      case UserApis.getTaxes:
        return "/api/v1/user/bundle/get-taxes";
      case UserApis.enableAutoTopup:
        return "/api/v1/user/auto-topup/enable";
      case UserApis.disableAutoTopup:
        return "/api/v1/user/auto-topup/disable";
      case UserApis.getAutoTopupConfig:
        return "/api/v1/user/auto-topup";
      case UserApis.getAutoTopupConfigs:
        return "/api/v1/user/auto-topup";
      case UserApis.updateAutoTopupConfig:
        return "/api/v1/user/auto-topup";
      case UserApis.getPaymentMethods:
        return "/api/v1/user/payment-methods";
      case UserApis.setDefaultPaymentMethod:
        return "/api/v1/user/payment-methods";
      case UserApis.deletePaymentMethod:
        return "/api/v1/user/payment-methods";
      case UserApis.syncPaymentMethods:
        return "/api/v1/user/payment-methods/sync";
    }
  }

  @override
  HttpMethod get method {
    switch (this) {
      case UserApis.getMyEsims:
      case UserApis.getMyEsimByIccID:
      case UserApis.getMyEsimByOrder:
      case UserApis.getRelatedTopUp:
      case UserApis.getUserConsumption:
      case UserApis.getUserNotifications:
      case UserApis.getBundleExists:
      case UserApis.getOrderHistory:
      case UserApis.getOrderByID:
      case UserApis.getWalletTransactions:
      case UserApis.getUserBillingInfo:
      case UserApis.getTaxes:
      case UserApis.getAutoTopupConfig:
      case UserApis.getAutoTopupConfigs:
      case UserApis.getPaymentMethods:
        return HttpMethod.GET;
      case UserApis.assignBundle:
      case UserApis.setNotificationsRead:
      case UserApis.topUpBundle:
      case UserApis.getBundleLabel:
      case UserApis.topUpWallet:
      case UserApis.resendOrderOtp:
      case UserApis.verifyOrderOtp:
      case UserApis.setUserBillingInfo:
      case UserApis.enableAutoTopup:
      case UserApis.disableAutoTopup:
      case UserApis.setDefaultPaymentMethod:
      case UserApis.syncPaymentMethods:
        return HttpMethod.POST;
      case UserApis.cancelOrder:
      case UserApis.deletePaymentMethod:
        return HttpMethod.DELETE;
      case UserApis.updateAutoTopupConfig:
        return HttpMethod.PUT;
    }
  }

  @override
  bool get hasAuthorization => true;

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers => const <String, String>{};
}
