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
  cancelOrder;

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
        return "/api/v1/user/bundle-label";
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
      case UserApis.cancelOrder:
        return "/api/v1/user/order/cancel";
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
        return HttpMethod.GET;
      case UserApis.assignBundle:
      case UserApis.setNotificationsRead:
      case UserApis.topUpBundle:
      case UserApis.getBundleLabel:
      case UserApis.topUpWallet:
        return HttpMethod.POST;
      case UserApis.cancelOrder:
        return HttpMethod.DELETE;
    }
  }

  @override
  bool get hasAuthorization => true;

  @override
  bool get isRefreshToken => false;

  @override
  Map<String, String> get headers => const <String, String>{};
}
