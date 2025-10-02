abstract class AnalyticEvent {
  const AnalyticEvent(this.eventName);
  factory AnalyticEvent.appCheckApp() => AnalyticsEvent("app_check_app");
  factory AnalyticEvent.appCheckBackend() =>
      AnalyticsEvent("app_check_backend");
  factory AnalyticEvent.contactUsClicked() =>
      AnalyticsEvent("contact_us_clicked");
  factory AnalyticEvent.userGuideOpened() =>
      AnalyticsEvent("user_guide_opened");
  factory AnalyticEvent.regionsClicked() => AnalyticsEvent("regions_clicked");
  // Restored non-ecommerce event (was removed inadvertently): used when user saves billing info during checkout
  factory AnalyticEvent.cartSaveBillingInfoApp() =>
    AnalyticsEvent("cart_save_billing_info_app");
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
  // Deprecated ecommerce factories removed in favor of strongly typed dual-provider events.
  // Use new classes from ecommerce_events.dart: ViewItemListEvent, ViewItemEvent, AddToCartEvent,
  // BeginCheckoutEvent, PurchaseEvent.
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

  Future<void> dispose();
}
