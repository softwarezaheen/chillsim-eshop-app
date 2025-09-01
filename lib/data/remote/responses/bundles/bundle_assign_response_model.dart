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
    this.taxPriceDisplay,
    this.subtotalPriceDisplay,
    this.totalPriceDisplay,
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
      taxPriceDisplay: json["tax_price_display"],
      totalPriceDisplay: json["total_price_display"],
      subtotalPriceDisplay: json["subtotal_price_display"],
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
  final String? subtotalPriceDisplay;
  final String? taxPriceDisplay;
  final String? totalPriceDisplay;

  bool isTaxExist() {
    String numericPart =
        (taxPriceDisplay ?? "").replaceAll(RegExp(r"[^0-9\.\-]"), "");
    double value = double.tryParse(numericPart) ?? 0.0;
    return value > 0.0;
  }

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
      "tax_price_display": taxPriceDisplay,
      "total_price_display": totalPriceDisplay,
      "subtotal_price_display": subtotalPriceDisplay,
    };
  }
}
