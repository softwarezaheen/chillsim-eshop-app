import "package:esim_open_source/presentation/enums/payment_type.dart";

abstract class PaymentService {
  Future<void> prepareCheckout({
    required PaymentType paymentType,
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  });

  Future<PaymentResult> processOrderPayment({
    required PaymentType paymentType,
    required String billingCountryCode,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String merchantDisplayName = "ChillSIM",
    bool testEnv = false,
    String? iccID,
    String? orderID,
  });
}
