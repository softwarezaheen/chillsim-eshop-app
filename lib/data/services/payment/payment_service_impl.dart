import "dart:async";

import "package:esim_open_source/data/services/payment/apple_pay/apple_pay_service_impl.dart";
import "package:esim_open_source/data/services/payment/dcb/dcb_payment_service_impl.dart";
import "package:esim_open_source/data/services/payment/stripe/stripe_payment_service_impl.dart";
import "package:esim_open_source/data/services/payment/wallet/wallet_payment.dart";
import "package:esim_open_source/domain/repository/services/payment_service.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";

class PaymentServiceImpl extends PaymentService {
  PaymentServiceImpl._privateConstructor();

  //#region Variables
  static PaymentServiceImpl? _instance;
  static PaymentServiceImpl get instance {
    if (_instance == null) {
      _instance = PaymentServiceImpl._privateConstructor();
      unawaited(_instance?._initialise());
    }
    return _instance!;
  }

  late StripePayment stripePayment;
  late DcbPayment dcbPayment;
  late WalletPayment walletPayment;
  late ApplePayService applePayService;

  //#endregion

  //#region Functions
  Future<void> _initialise() async {
    stripePayment = StripePayment.instance;
    dcbPayment = DcbPayment.instance;
    walletPayment = WalletPayment.instance;
    applePayService = ApplePayService.instance;
  }

  @override
  Future<void> prepareCheckout({
    required PaymentType paymentType,
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  }) {
    switch (paymentType) {
      case PaymentType.wallet:
        return walletPayment.prepareCheckout(
          publishableKey: publishableKey,
          merchantIdentifier: merchantIdentifier,
          urlScheme: urlScheme,
        );
      case PaymentType.dcb:
        return dcbPayment.prepareCheckout(
          publishableKey: publishableKey,
          merchantIdentifier: merchantIdentifier,
          urlScheme: urlScheme,
        );
      case PaymentType.card:
        return stripePayment.prepareCheckout(
          publishableKey: publishableKey,
          merchantIdentifier: merchantIdentifier,
          urlScheme: urlScheme,
        );
      case PaymentType.applePay:
        return applePayService.prepareCheckout(
          publishableKey: publishableKey,
          merchantIdentifier: merchantIdentifier,
          urlScheme: urlScheme,
        );
    }
  }

  @override
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
  }) async {
    switch (paymentType) {
      case PaymentType.wallet:
        return walletPayment.processOrderPayment(
          billingCountryCode: billingCountryCode,
          paymentIntentClientSecret: paymentIntentClientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          merchantDisplayName: merchantDisplayName,
          testEnv: testEnv,
          iccID: iccID,
          orderID: orderID,
        );
      case PaymentType.dcb:
        return dcbPayment.processOrderPayment(
          billingCountryCode: billingCountryCode,
          paymentIntentClientSecret: paymentIntentClientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          merchantDisplayName: merchantDisplayName,
          testEnv: testEnv,
          iccID: iccID,
          orderID: orderID,
        );
      case PaymentType.card:
        return stripePayment.processOrderPayment(
          billingCountryCode: billingCountryCode,
          paymentIntentClientSecret: paymentIntentClientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          merchantDisplayName: merchantDisplayName,
          testEnv: testEnv,
          iccID: iccID,
          orderID: orderID,
        );
      case PaymentType.applePay:
        return applePayService.processOrderPayment(
          billingCountryCode: billingCountryCode,
          paymentIntentClientSecret: paymentIntentClientSecret,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          merchantDisplayName: merchantDisplayName,
          testEnv: testEnv,
          iccID: iccID,
          orderID: orderID,
        );
    }
  }

  //#endregion
}
