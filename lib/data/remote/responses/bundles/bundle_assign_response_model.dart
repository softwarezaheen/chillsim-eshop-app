class BundleAssignResponseModel {
  BundleAssignResponseModel({
    this.publishableKey,
    this.merchantIdentifier,
    this.billingCountryCode,
    this.paymentIntentClientSecret,
    this.customerId,
    this.customerEphemeralKeySecret,
    this.testEnv,
    this.merchantDisplayName,
    this.stripeUrlScheme,
    this.orderId,
    this.paymentStatus,
  });

  factory BundleAssignResponseModel.fromJson({dynamic json}) {
    return BundleAssignResponseModel(
      publishableKey: json["publishable_key"],
      merchantIdentifier: json["merchant_identifier"],
      billingCountryCode: json["billing_country_code"],
      paymentIntentClientSecret: json["payment_intent_client_secret"],
      customerId: json["customer_id"],
      customerEphemeralKeySecret: json["customer_ephemeral_key_secret"],
      testEnv: json["test_env"],
      merchantDisplayName: json["merchant_display_name"],
      stripeUrlScheme: json["stripe_url_scheme"],
      orderId: json["order_id"],
      paymentStatus: json["payment_status"],
    );
  }

  final String? publishableKey;
  final String? merchantIdentifier;
  final String? billingCountryCode;
  final String? paymentIntentClientSecret;
  final String? customerId;
  final String? customerEphemeralKeySecret;
  final bool? testEnv;
  final String? merchantDisplayName;
  final String? stripeUrlScheme;
  final String? orderId;
  final String? paymentStatus;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "publishable_key": publishableKey,
      "merchant_identifier": merchantIdentifier,
      "billing_country_code": billingCountryCode,
      "payment_intent_client_secret": paymentIntentClientSecret,
      "customer_id": customerId,
      "customer_ephemeral_key_secret": customerEphemeralKeySecret,
      "test_env": testEnv,
      "merchant_display_name": merchantDisplayName,
      "stripe_url_scheme": stripeUrlScheme,
      "order_id": orderId,
      "payment_status": paymentStatus,
    };
  }
}
