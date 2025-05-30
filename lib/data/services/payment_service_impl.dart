import "dart:async";
import "dart:developer";

import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:flutter_stripe/flutter_stripe.dart";

class PaymentServiceImpl extends PaymentService {
  PaymentServiceImpl._privateConstructor();

  static PaymentServiceImpl? _instance;

  static PaymentServiceImpl get instance {
    if (_instance == null) {
      _instance = PaymentServiceImpl._privateConstructor();
      unawaited(_instance?._initialise());
    }

    return _instance!;
  }

  Future<void> _initialise() async {}

  @override
  Future<void> initializePaymentKeys({
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  }) async {
    Stripe.publishableKey = publishableKey;
    Stripe.merchantIdentifier = merchantIdentifier;
    Stripe.urlScheme = urlScheme;
    await Stripe.instance.applySettings();
  }

  @override
  Future<void> triggerPaymentSheet({
    required String billingCountryCode,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String merchantDisplayName = "Esim",
    bool testEnv = false,
  }) async {
    try {
      // 1. create payment
      // create some billing details
      final BillingDetails billingDetails = BillingDetails(
        address: Address(
          city: null,
          country: billingCountryCode,
          line1: null,
          line2: null,
          postalCode: null,
          state: null,
        ),
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: merchantDisplayName,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          applePay: PaymentSheetApplePay(
            merchantCountryCode: billingCountryCode,
          ),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: billingCountryCode,
            testEnv: testEnv,
          ),
          billingDetails: billingDetails,
        ),
      );

      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      log("Error from Stripe: ${e.error.localizedMessage}");
      throw Exception(e.error.message);
    } catch (e) {
      log("Unforeseen error: $e");
      rethrow;
    }
  }

  // // Sample Usage
  // Future<void> initiatePayment() async {
  //   try {
  //     await paymentService.initializePaymentKeys(
  //       publishableKey:
  //       "pk_test_51QrDdiC7R0nTf9YLxr69CwkZzkoWU8xaEkPSrNx7DNSz8CkvrJO6lxz1XwWYA6P0IWBOvkikQOEwzkCZgbVPvMKR009EZ1wNHd",
  //       merchantIdentifier: "merchant.mmesim.stripe.montypay",
  //     );
  //
  //     final Map<String, dynamic> data = await createTestPaymentSheet();
  //
  //     await paymentService.triggerPaymentSheet(
  //       billingCountryCode: "GB",
  //       paymentIntentClientSecret: data["paymentIntent"],
  //       customerId: data["customer"],
  //       customerEphemeralKeySecret: data["ephemeralKey"],
  //       testEnv:AppEnvironment.appEnvironmentHelper.enableTestPayment,
  //     );
  //   } on Exception catch (e) {
  //     snackBarService.showSnackbar(message: e.toString());
  //     return;
  //   }
  //   snackBarService.showSnackbar(message: "Payment successfully completed");
  // }
  //
  // Future<Map<String, dynamic>> createTestPaymentSheet() async {
  //   final Uri url =
  //   Uri.parse("https://amethyst-carnation-lemur.glitch.me/payment-sheet");
  //   final Response response = await post(
  //     url,
  //     headers: <String, String>{
  //       "Content-Type": "application/json",
  //     },
  //     body: json.encode(<String, String>{
  //       "a": "a",
  //     }),
  //   );
  //   final dynamic body = json.decode(response.body);
  //
  //   if (body["error"] != null) {
  //     throw Exception('Error code: ${body['error']}');
  //   }
  //
  //   return body;
  // }
}
