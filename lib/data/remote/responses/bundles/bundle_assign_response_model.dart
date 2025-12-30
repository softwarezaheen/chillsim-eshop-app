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
    this.fee,
    this.vat,
    this.originalAmount,
    this.exchangeRate,
    this.currency,
    this.displayCurrency,
    this.taxMode,
    this.feeEnabled,
  });

  factory BundleAssignResponseModel.fromJson({dynamic json}) {
    // Helper function to safely parse numeric values that may come as int, double, or String
    int? parseIntSafe(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return double.tryParse(value)?.toInt();
      return null;
    }

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
      fee: parseIntSafe(json["fee"]),
      vat: parseIntSafe(json["vat"]),
      originalAmount: parseIntSafe(json["original_amount"]),
      exchangeRate: json["exchange_rate"]?.toDouble(),
      currency: json["currency"],
      displayCurrency: json["display_currency"],
      taxMode: json["tax_mode"] ?? "exclusive", // inclusive, exclusive, none
      feeEnabled: json["fee_enabled"] ?? true,
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
  final int? fee;
  final int? vat;
  final int? originalAmount;
  final double? exchangeRate;
  final String? currency;
  final String? displayCurrency;
  final String? taxMode; // "inclusive", "exclusive", "none"
  final bool? feeEnabled;

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
      "fee": fee,
      "vat": vat,
      "original_amount": originalAmount,
      "exchange_rate": exchangeRate,
      "currency": currency,
      "display_currency": displayCurrency,
      "tax_mode": taxMode,
      "fee_enabled": feeEnabled,
    };
  }
}
