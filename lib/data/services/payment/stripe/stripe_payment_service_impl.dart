import "dart:async";
import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/services.dart";
import "package:flutter_stripe/flutter_stripe.dart";
import "package:fluttertoast/fluttertoast.dart";

/// Helper function to safely get translated string with fallback
/// Handles cases where easy_localization context is not available (e.g., tests)
String _safeTranslate(String key, String fallback) {
  try {
    final String translated = key.tr();
    // If translation returns the key itself, localization is not available
    return translated == key ? fallback : translated;
  } on Object catch (_) {
    // Localization not available (e.g., in tests), use fallback
    return fallback;
  }
}

class StripePayment {
  StripePayment._privateConstructor();

  static StripePayment? _instance;

  static StripePayment get instance {
    if (_instance == null) {
      _instance = StripePayment._privateConstructor();
      unawaited(_instance?._initialise());
    }

    return _instance!;
  }

  Future<void> _initialise() async {}

  Future<void> prepareCheckout({
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  }) async {
    try {
      log("═══════════════════════════════════════");
      log("💳 Preparing Stripe Checkout");
      log("═══════════════════════════════════════");
      
      // CRITICAL FIX: iOS requires specific merchant ID from entitlements
      // Backend returns "chillsim-eshop" but iOS needs "merchant.zaheen.esim.chillsim"
      // Use platform-specific merchant ID from AppEnvironmentHelper
      final String effectiveMerchantId = Platform.isIOS
          ? AppEnvironment.appEnvironmentHelper.iosMerchantIdentifier
          : (merchantIdentifier ?? ""); // Android/Google Pay uses backend value
      
      log("   Platform: ${Platform.isIOS ? 'iOS' : 'Android'}");
      
      // DEFENSIVE CODING: Safe string preview that handles any length
      // Why: Prevent crashes from short keys and avoid exposing full key in logs
      // Security: Only show first 15 chars
      final String keyPreview = publishableKey.length > 15
          ? "${publishableKey.substring(0, 15)}..."
          : publishableKey;
      
      log("   Publishable Key: $keyPreview");
      log("   Backend Merchant ID: $merchantIdentifier");
      log("   Effective Merchant ID: $effectiveMerchantId");
      log("   URL Scheme: $urlScheme");
      log("───────────────────────────────────────");

      // DEFENSIVE CODING: Validate publishable key before use
      // Why: Stripe SDK will fail with cryptic error if key is invalid
      // Throws Exception (not ArgumentError) so it propagates correctly through
      // the bare catch→rethrow path and surfaces to the VM with the right message.
      if (publishableKey.isEmpty) {
        throw Exception(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Payment configuration error. Please contact support.",
          ),
        );
      }

      if (!publishableKey.startsWith("pk_test_") &&
          !publishableKey.startsWith("pk_live_")) {
        log("⚠️ Warning: Publishable key format may be invalid. "
            "Expected format: pk_test_... or pk_live_...");
      }

      // DEFENSIVE CODING: Validate merchant identifier for iOS
      // Why: Stripe Payment Sheet includes Apple Pay config by default on iOS
      // Impact: Without merchant ID, Payment Sheet initialization fails
      // Critical: This affects ALL payments on iOS (not just Apple Pay)
      if (Platform.isIOS && effectiveMerchantId.isEmpty) {
        throw Exception(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Apple Pay configuration error. Please contact support.",
          ),
        );
      }

      // Validate format if iOS
      if (Platform.isIOS && !effectiveMerchantId.startsWith("merchant.")) {
        log("⚠️ Warning: Merchant identifier format may be invalid.");
        log("   Expected format: merchant.{domain}.{app}");
        log("   Current value: $effectiveMerchantId");
      } else if (Platform.isIOS) {
        log("✅ Merchant identifier validated: $effectiveMerchantId");
      }

      // USER-FACING FEEDBACK: Show preparing message
      await showToast(
        _safeTranslate(
          LocaleKeys.payment_preparing,
          "Preparing payment...",
        ),
        toastLength: Toast.LENGTH_SHORT,
      );

      // DEFENSIVE CODING: Configure Stripe with validated values
      Stripe.publishableKey = publishableKey;
      if (Platform.isIOS) {
        Stripe.merchantIdentifier = effectiveMerchantId; // iOS: Use configured ID
      } else if (merchantIdentifier != null && merchantIdentifier.isNotEmpty) {
        Stripe.merchantIdentifier = merchantIdentifier; // Android: Use backend ID
      }
      Stripe.urlScheme = urlScheme;
      await Stripe.instance.applySettings();
      
      log("✅ Stripe checkout prepared successfully");
      log("═══════════════════════════════════════");
    } on StripeException catch (e) {
      log("❌ Stripe configuration error: ${e.error.localizedMessage ?? e.error.message}");
      log("   Code: ${e.error.code}");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_platform, "Platform error occurred"));
    } on PlatformException catch (e) {
      log("❌ Platform error during Stripe initialization: ${e.message}");
      log("   Code: ${e.code}");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_platform, "Platform error occurred"));
    } on SocketException catch (e) {
      log("❌ Network error during Stripe initialization: ${e.message}");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_network, "No internet connection"));
    } on TimeoutException catch (_) {
      log("❌ Timeout during Stripe initialization");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_timeout, "Payment timed out"));
    } catch (e, stackTrace) {
      // Rethrow any Exception we already built with a user-friendly message
      // (e.g. validation errors thrown above). Only wrap truly unexpected
      // non-Exception objects (Errors, assertion failures, etc.).
      if (e is Exception) 
        {rethrow;}
      log("❌ Unexpected error preparing Stripe checkout: $e");
      log("   Stack trace: $stackTrace");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_unknown, "Unknown error occurred"));
    }
  }

  Future<PaymentResult> processOrderPayment({
    required String billingCountryCode,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String merchantDisplayName = "ChillSIM",
    bool testEnv = false,
    String? iccID,
    String? orderID,
    String? stripePaymentMethodId,
  }) async {
    try {
      // Use saved payment method directly (skip Payment Sheet)
      if (stripePaymentMethodId != null && stripePaymentMethodId.isNotEmpty) {
        log("═══════════════════════════════════════");
        log("💳 Confirming with Saved Payment Method");
        log("   PM ID: $stripePaymentMethodId");
        log("   Order ID: $orderID");
        log("═══════════════════════════════════════");
        final PaymentIntent result = await Stripe.instance.confirmPayment(
          paymentIntentClientSecret: paymentIntentClientSecret,
          data: PaymentMethodParams.cardFromMethodId(
            paymentMethodData: PaymentMethodDataCardFromMethod(
              paymentMethodId: stripePaymentMethodId,
            ),
          ),
        );
        log("✅ Saved PM confirm status: ${result.status}");
        switch (result.status) {
          case PaymentIntentsStatus.Succeeded:
          case PaymentIntentsStatus.Processing:
            // Processing = async method (SEPA, Sofort, etc). Webhook will confirm.
            log("✅ Saved PM payment ${result.status == PaymentIntentsStatus.Processing ? 'processing — webhook will confirm' : 'succeeded'}");
            return PaymentResult.completed;

          case PaymentIntentsStatus.Canceled:
            log("ℹ️ Saved PM payment intent was canceled");
            return PaymentResult.canceled;

          case PaymentIntentsStatus.RequiresCapture:
            // Manual-capture flow: PI is authorised but not yet captured server-side.
            // Treat as success — the backend webhook will capture and fulfil the order.
            log("✅ Saved PM requires capture (manual-capture flow) — treating as success");
            return PaymentResult.completed;

          case PaymentIntentsStatus.RequiresAction:
            // 3DS or other redirect-based authentication required.
            // Call handleNextAction to launch the WebView/redirect flow,
            // then re-evaluate the final status.
            log("🔐 Saved PM requires action (3DS) — launching handleNextAction");
            final PaymentIntent actionResult =
                await Stripe.instance.handleNextAction(paymentIntentClientSecret);
            log("🔐 handleNextAction completed — status: ${actionResult.status}");
            switch (actionResult.status) {
              case PaymentIntentsStatus.Succeeded:
              case PaymentIntentsStatus.Processing:
                log("✅ 3DS authentication succeeded");
                return PaymentResult.completed;
              case PaymentIntentsStatus.RequiresCapture:
                log("✅ 3DS succeeded, requires capture (manual-capture flow)");
                return PaymentResult.completed;
              case PaymentIntentsStatus.Canceled:
                log("ℹ️ Payment canceled during 3DS");
                return PaymentResult.canceled;
              default:
                log("❌ Payment failed after 3DS — status: ${actionResult.status}");
                throw Exception(_safeTranslate(
                    LocaleKeys.payment_error_failed,
                    "Payment authentication failed. Please try a different card."));
            }

          case PaymentIntentsStatus.RequiresConfirmation:
            log("❌ Saved PM still requires confirmation after confirmPayment");
            throw Exception(_safeTranslate(LocaleKeys.payment_error_failed, "Payment requires additional verification. Please try a different card."));

          case PaymentIntentsStatus.RequiresPaymentMethod:
            log("❌ Saved PM authentication failed — requires new payment method");
            throw Exception(_safeTranslate(LocaleKeys.payment_error_failed, "Payment authentication failed. Please try a different card."));

          case PaymentIntentsStatus.Unknown:
            log("❌ Saved PM unexpected status: ${result.status}");
            throw Exception(_safeTranslate(LocaleKeys.payment_error_failed, "Payment failed"));
        }
      }

      log("═══════════════════════════════════════");
      log("💳 Starting Stripe Card Payment Flow");
      log("   (Payment Sheet includes Apple Pay/Google Pay)");
      log("═══════════════════════════════════════");
      log("   Order ID: $orderID");
      log("   Test Environment: $testEnv");
      log("   Country Code: $billingCountryCode");
      log("   Merchant Display Name: $merchantDisplayName");
      log("───────────────────────────────────────");

      // Check Apple Pay availability on iOS devices
      // Payment Sheet automatically shows Apple Pay if available
      if (Platform.isIOS) {
        log("🍎 iOS Device Detected - Checking Apple Pay Capability...");
        try {
          log("   Platform: iOS ${Platform.operatingSystemVersion}");
          log("   Locale: ${Platform.localeName}");
          
          // ACTUAL Apple Pay capability check using Stripe SDK
          final bool isSupported = await Stripe.instance.isPlatformPaySupported();
          
          log("───────────────────────────────────────");
          log("📱 Apple Pay Capability Result:");
          log("   Device Supports Apple Pay: ${isSupported ? '✅ YES' : '❌ NO'}");
          
          if (isSupported) {
            log("───────────────────────────────────────");
            log("✅ APPLE PAY AVAILABLE");
            log("   • Device has Apple Pay capability");
            log("   • Payment Sheet will show Apple Pay button");
            log("   • User must have cards in Wallet to use it");
          } else {
            log("───────────────────────────────────────");
            log("❌ APPLE PAY NOT AVAILABLE");
            log("   Possible Reasons:");
            log("   • Device doesn't support Apple Pay hardware");
            log("   • iOS version too old (need iOS 9.0+)");
            log("   • Device model doesn't have NFC chip");
            log("   • Region restrictions");
          }
          
          log("───────────────────────────────────────");
          log("ℹ️  Note: Even if supported, Apple Pay button");
          log("   only appears if user has cards in Wallet app");
        } on Object catch (e) {
          log("⚠️  Apple Pay capability check failed: $e");
          log("   Payment Sheet will still work with card payments");
        }
        log("───────────────────────────────────────");
      }

      // DEFENSIVE CODING: Validate all required payment parameters
      // Why: Stripe SDK gives cryptic errors if parameters are invalid
      // Better to fail fast with clear, actionable error messages

      // 1. Validate Customer ID
      // Uses Exception (not ArgumentError) so it propagates through the bare
      // catch→rethrow path and reaches the VM with the correct message.
      if (customerId.isEmpty) {
        throw Exception(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Payment configuration error: missing customer ID. Please contact support.",
          ),
        );
      }
      if (!customerId.startsWith("cus_")) {
        log("⚠️ Warning: Customer ID format may be invalid. "
            "Expected format: cus_... (Stripe customer ID)");
      }

      // 2. Validate Payment Intent Client Secret
      if (paymentIntentClientSecret.isEmpty) {
        throw Exception(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Payment configuration error: missing payment intent. Please contact support.",
          ),
        );
      }
      if (!paymentIntentClientSecret.startsWith("pi_") &&
          !paymentIntentClientSecret.startsWith("seti_")) {
        log("⚠️ Warning: Payment intent secret format may be invalid. "
            "Expected format: pi_... or seti_...");
      }

      // 3. Validate Ephemeral Key Secret
      if (customerEphemeralKeySecret.isEmpty) {
        throw Exception(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Payment configuration error: missing ephemeral key. Please contact support.",
          ),
        );
      }

      // 4. Validate Country Code (ISO 3166-1 alpha-2)
      if (billingCountryCode.isEmpty) {
        throw Exception(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Payment configuration error: missing billing country. Please contact support.",
          ),
        );
      }
      if (billingCountryCode.length != 2) {
        throw Exception(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            'Payment configuration error: invalid country code "$billingCountryCode". Please contact support.',
          ),
        );
      }
      // Ensure uppercase for consistency
      final String normalizedCountryCode = billingCountryCode.toUpperCase();
      if (billingCountryCode != normalizedCountryCode) {
        log('ℹ️ Info: Country code normalized from "$billingCountryCode" to "$normalizedCountryCode"');
      }

      log("✅ All payment parameters validated successfully");
      log("───────────────────────────────────────");

      // 1. create payment
      // Note: billingDetails parameter is only used to save info AFTER payment
      // Pre-filling in Payment Sheet comes from the backend PaymentIntent's shipping address
      final BillingDetails billingDetails = BillingDetails(
        address: Address(
          country: normalizedCountryCode,
          city: null,
          line1: null,
          line2: null,
          postalCode: null,
          state: null,
        ),
      );

      log("✅ Step 1: Payment configuration prepared");
      log("   📍 Merchant Country: $normalizedCountryCode");
      log("   ⚠️  Note: Payment Sheet pre-fill comes from backend PaymentIntent shipping address");

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: merchantDisplayName,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          applePay: PaymentSheetApplePay(
            merchantCountryCode: normalizedCountryCode,
          ),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: normalizedCountryCode,
            testEnv: testEnv,
          ),
          billingDetails: billingDetails,
        ),
      );

      log("✅ Step 2: Payment Sheet initialized");
      log("   ⚠️  Note: Stripe pre-fills country from PaymentIntent (backend)");

      // 3. display the payment sheet.
      log("📱 Step 3: Presenting Payment Sheet...");
      log("═══════════════════════════════════════");
      log("🔒 SECURE PAYMENT INFORMATION");
      log("═══════════════════════════════════════");
      log("   ✓ Payments are securely processed via Stripe.com");
      log("   ✓ ChillSim does not store your card details");
      log("   ✓ View Stripe's privacy policy: https://stripe.com/privacy");
      log("═══════════════════════════════════════");
      await Stripe.instance.presentPaymentSheet();
      
      log("═══════════════════════════════════════");
      log("🎉 Payment Completed Successfully!");
      log("═══════════════════════════════════════");
      
      return PaymentResult.completed;
    } on StripeException catch (e) {
      log("═══════════════════════════════════════");
      log("❌ Stripe Error in Payment");
      log("═══════════════════════════════════════");
      log("   Error Type: ${e.error.type}");
      log("   Error Code: ${e.error.code}");
      log("   Error Message: ${e.error.message}");
      log("   Localized Message: ${e.error.localizedMessage}");
      log("═══════════════════════════════════════");

      // Handle specific Stripe error codes with localized messages
      switch (e.error.code) {
        case FailureCode.Canceled:
          log("ℹ️ User canceled the payment");
          return PaymentResult.canceled;
        
        case FailureCode.Failed:
          log("❌ Payment failed: ${e.error.message}");
          throw Exception(_safeTranslate(LocaleKeys.payment_error_failed, "Payment failed"));
        
        case FailureCode.Timeout:
          log("⏱️ Payment timed out");
          throw Exception(_safeTranslate(LocaleKeys.payment_error_timeout, "Payment timed out"));
        
        default:
          // Use Stripe's localized message if available, otherwise use generic error
          final String? errorMessage = e.error.localizedMessage?.isNotEmpty ?? false
              ? e.error.localizedMessage
              : _safeTranslate(LocaleKeys.payment_error_failed, "Payment failed");
          log("❌ Stripe error: $errorMessage");
          throw Exception(errorMessage);
      }
    } on PlatformException catch (e) {
      log("═══════════════════════════════════════");
      log("❌ Platform Error in Payment");
      log("═══════════════════════════════════════");
      log("   Code: ${e.code}");
      log("   Message: ${e.message}");
      log("   Details: ${e.details}");
      log("═══════════════════════════════════════");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_platform, "Platform error occurred"));
    } on SocketException catch (e) {
      log("═══════════════════════════════════════");
      log("❌ Network Error in Payment");
      log("═══════════════════════════════════════");
      log("   Message: ${e.message}");
      log("═══════════════════════════════════════");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_network, "No internet connection"));
    } on TimeoutException catch (_) {
      log("═══════════════════════════════════════");
      log("❌ Payment Timeout");
      log("═══════════════════════════════════════");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_timeout, "Payment timed out"));
    } catch (e, stackTrace) {
      // Rethrow any Exception we already built with a user-friendly message
      // (validation errors, status-switch errors). Only wrap truly unexpected
      // non-Exception objects (Errors, assertion failures, etc.).
      if (e is Exception) {
        rethrow;
      }
      log("═══════════════════════════════════════");
      log("❌ Unexpected Error in Payment");
      log("═══════════════════════════════════════");
      log("Error: $e");
      log("Stack Trace:\n$stackTrace");
      log("═══════════════════════════════════════");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_unexpected, "Unexpected error occurred"));
    }
  }
}
