import "dart:async";

import "package:esim_open_source/presentation/enums/payment_type.dart";

class DcbPayment {
  DcbPayment._privateConstructor();

  static DcbPayment? _instance;

  static DcbPayment get instance {
    if (_instance == null) {
      _instance = DcbPayment._privateConstructor();
      unawaited(_instance?._initialise());
    }

    return _instance!;
  }

  Future<void> _initialise() async {}

  Future<void> prepareCheckout({
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  }) async {}

  Future<PaymentResult> processOrderPayment({
    required String billingCountryCode,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String merchantDisplayName = "ChillSIM",
    bool testEnv = false,
    String? iccID,
    String? orderID,
  }) async {
    return PaymentResult.otpRequested;
  }
}
