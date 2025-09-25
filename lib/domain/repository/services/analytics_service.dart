sealed class AnalyticEvent {
  const AnalyticEvent(this.eventName);
  factory AnalyticEvent.appCheckApp() => AnalyticsEvent("app_check_app");
  factory AnalyticEvent.appCheckBackend() =>
      AnalyticsEvent("app_check_backend");
  factory AnalyticEvent.contactUsClicked() =>
      AnalyticsEvent("contact_us_clicked");
  factory AnalyticEvent.userGuideOpened() =>
      AnalyticsEvent("user_guide_opened");
  factory AnalyticEvent.regionsClicked() => AnalyticsEvent("regions_clicked");
  factory AnalyticEvent.firstOpenCampaign({
    required String utm,
    required String platform,
  }) =>
      CampaignEvent(
        "first_open_campaign",
        utm: utm,
        platform: platform,
      );
  factory AnalyticEvent.loginSuccess({
    required String utm,
    required String platform,
  }) =>
      CampaignEvent(
        "campaign_login",
        utm: utm,
        platform: platform,
      );
  factory AnalyticEvent.buySuccess({
    required String utm,
    required String platform,
    required String amount,
    required String currency,
  }) =>
      PurchaseSuccessEvent(
        "campaign_buy",
        utm: utm,
        platform: platform,
        amount: amount,
        currency: currency,
      );
  factory AnalyticEvent.buyTopUpSuccess({
    required String utm,
    required String platform,
    required String amount,
    required String currency,
  }) =>
      PurchaseSuccessEvent(
        "campaign_topup",
        utm: utm,
        platform: platform,
        amount: amount,
        currency: currency,
      );
  factory AnalyticEvent.checkoutApp({
    required String orderId,
    required String bundleId,
    required String bundleName,
    required String amount,
    required String currency,
    required String fee,
    required String tax,
    required String total,
  }) =>
      EcommerceEvent(
        "checkout_app",
        ecommerce: <String, Object>{
          "order_id": orderId,
          "bundle_id": bundleId,
          "bundle_name": bundleName,
          "amount": amount,
          "currency": currency,
          "fee": fee,
          "tax": tax,
          "total": total,
        },
      );
  factory AnalyticEvent.purchasedBundleApp({
    required String orderId,
    required String productId,
    required String productName,
    required String amount,
    required String currency,
    required String fee,
    required String tax,
    required String total,
    required String paymentType,
    required String promoCode,
    required String discount,
  }) =>
      EcommerceEvent(
        "purchased_bundle_app",
        ecommerce: <String, Object>{
          "order_id": orderId,
          "product_id": productId,
          "product_name": productName,
          "amount": amount,
          "currency": currency,
          "fee": fee,
          "tax": tax,
          "total": total,
          "payment_type": paymentType,
          "promo_code": promoCode,
          "discount": discount,
        },
      );
  factory AnalyticEvent.purchasedTopupApp({
    required String orderId,
    required String productId,
    required String productName,
    required String amount,
    required String currency,
    required String fee,
    required String tax,
    required String total,
    required String paymentType,
    required String promoCode,
    required String discount,
    required String iccid,
  }) =>
      EcommerceEvent(
        "purchased_topup_app",
        ecommerce: <String, Object>{
          "order_id": orderId,
          "product_id": productId,
          "product_name": productName,
          "amount": amount,
          "currency": currency,
          "fee": fee,
          "tax": tax,
          "total": total,
          "payment_type": paymentType,
          "promo_code": promoCode,
          "discount": discount,
          "iccid": iccid,
        },
      );
  factory AnalyticEvent.productSearchApp({
    required String country,
  }) =>
      AnalyticsEventWithParams(
        "product_search_app",
        parameters: <String, Object>{
          "country": country,
        },
      );
  factory AnalyticEvent.viewTopupDetailsApp({
    required String bundleId,
    required String bundleName,
    required String amount,
    required String currency,
    required String iccid,
  }) =>
      EcommerceEvent(
        "view_topup_details_app",
        ecommerce: <String, Object>{
          "bundle_id": bundleId,
          "bundle_name": bundleName,
          "amount": amount,
          "currency": currency,
          "iccid": iccid,
        },
      );
  factory AnalyticEvent.viewProductDetailsApp({
    required String bundleId,
    required String bundleName,
    required String amount,
    required String currency,
  }) =>
      EcommerceEvent(
        "view_product_details_app",
        ecommerce: <String, Object>{
          "bundle_id": bundleId,
          "bundle_name": bundleName,
          "amount": amount,
          "currency": currency,
        },
      );
  factory AnalyticEvent.addToCartTopupApp({
    required String bundleId,
    required String bundleName,
    required String amount,
    required String currency,
    required int quantity,
    required String iccid,
  }) =>
      EcommerceEvent(
        "add_to_cart_topup_app",
        ecommerce: <String, Object>{
          "bundle_id": bundleId,
          "bundle_name": bundleName,
          "amount": amount,
          "currency": currency,
          "quantity": quantity,
          "iccid": iccid,
        },
      );
  factory AnalyticEvent.cartSaveBillingInfoApp() =>
      AnalyticsEvent("cart_save_billing_info_app");
  factory AnalyticEvent.addToCartBundleApp({
    required String bundleId,
    required String bundleName,
    required String amount,
    required String currency,
    required int quantity,
  }) =>
      EcommerceEvent(
        "add_to_cart_bundle_app",
        ecommerce: <String, Object>{
          "bundle_id": bundleId,
          "bundle_name": bundleName,
          "amount": amount,
          "currency": currency,
          "quantity": quantity,
        },
      );
  factory AnalyticEvent.viewRegionProducts({
    required String region,
  }) =>
      AnalyticsEventWithParams(
        "view_region_products",
        parameters: <String, Object>{
          "region": region,
        },
      );
  factory AnalyticEvent.viewCountryProducts({
    required String country,
  }) =>
      AnalyticsEventWithParams(
        "view_country_products",
        parameters: <String, Object>{
          "country": country,
        },
      );
  final String eventName;
  Map<String, Object>? get parameters;
}

class AnalyticsEvent extends AnalyticEvent {
  AnalyticsEvent(super.eventName);

  @override
  Map<String, Object>? get parameters => null;
}

class CampaignEvent extends AnalyticEvent {
  CampaignEvent(
    super.eventName, {
    required this.utm,
    required this.platform,
  });
  final String utm;
  final String platform;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "utm": utm,
        "platform": platform,
      };
}

class PurchaseSuccessEvent extends AnalyticEvent {
  PurchaseSuccessEvent(
    super.eventName, {
    required this.utm,
    required this.platform,
    required this.amount,
    required this.currency,
  });
  final String utm;
  final String platform;
  final String amount;
  final String currency;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "utm": utm,
        "platform": platform,
        "amount": amount,
        "currency": currency,
      };
}

class EcommerceEvent extends AnalyticEvent {
  EcommerceEvent(
    super.eventName, {
    required this.ecommerce,
  });
  final Map<String, Object> ecommerce;

  @override
  Map<String, Object>? get parameters => <String, Object>{
        "ecommerce": ecommerce,
      };
}

class AnalyticsEventWithParams extends AnalyticEvent {
  AnalyticsEventWithParams(
    super.eventName, {
    required Map<String, Object> parameters,
  }) : _parameters = parameters;
  final Map<String, Object> _parameters;

  @override
  Map<String, Object>? get parameters => _parameters;
}

abstract class AnalyticsService {
  Future<void> configure({
    bool firebaseAnalytics = true,
    bool facebookAnalytics = true,
  });

  Future<void> logEvent({
    required AnalyticEvent event,
  });
}
