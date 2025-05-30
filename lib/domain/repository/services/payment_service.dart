abstract class PaymentService {
  Future<void> triggerPaymentSheet({
    required String billingCountryCode,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String merchantDisplayName = "Esim",
    bool testEnv = false,
  });

  Future<void> initializePaymentKeys({
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  });
}
