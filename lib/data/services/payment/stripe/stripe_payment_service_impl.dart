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
    final translated = key.tr();
    // If translation returns the key itself, localization is not available
    return translated == key ? fallback : translated;
  } catch (e) {
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
      final keyPreview = publishableKey.length > 15 
          ? '${publishableKey.substring(0, 15)}...' 
          : publishableKey;
      
      log("   Publishable Key: $keyPreview");
      log("   Backend Merchant ID: $merchantIdentifier");
      log("   Effective Merchant ID: $effectiveMerchantId");
      log("   URL Scheme: $urlScheme");
      log("───────────────────────────────────────");

      // DEFENSIVE CODING: Validate publishable key before use
      // Why: Stripe SDK will fail with cryptic error if key is invalid
      // Better to fail fast with clear, actionable error message
      if (publishableKey.isEmpty) {
        await showToast(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Payment configuration error. Please contact support."
          ),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
        throw ArgumentError(
          'Publishable key cannot be empty. '
          'Please provide a valid Stripe publishable key (pk_test_... or pk_live_...).'
        );
      }

      if (!publishableKey.startsWith('pk_test_') && 
          !publishableKey.startsWith('pk_live_')) {
        log("⚠️ Warning: Publishable key format may be invalid. "
            "Expected format: pk_test_... or pk_live_...");
      }

      // DEFENSIVE CODING: Validate merchant identifier for iOS
      // Why: Stripe Payment Sheet includes Apple Pay config by default on iOS
      // Impact: Without merchant ID, Payment Sheet initialization fails
      // Critical: This affects ALL payments on iOS (not just Apple Pay)
      if (Platform.isIOS && effectiveMerchantId.isEmpty) {
        await showToast(
          _safeTranslate(
            LocaleKeys.payment_error_failed,
            "Apple Pay configuration error"
          ),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
        );
        throw ArgumentError('Merchant identifier is required for Apple Pay in Payment Sheet');
      }

      // Validate format if iOS
      if (Platform.isIOS && !effectiveMerchantId.startsWith('merchant.')) {
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
          "Preparing payment..."
        ),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
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
      
      await showToast(
        _safeTranslate(
          LocaleKeys.payment_error_stripe_config,
          "Payment system error. Please try again."
        ),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      
      throw Exception(_safeTranslate(LocaleKeys.payment_error_platform, "Platform error occurred"));
    } on PlatformException catch (e) {
      log("❌ Platform error during Stripe initialization: ${e.message}");
      log("   Code: ${e.code}");
      
      await showToast(
        _safeTranslate(
          LocaleKeys.payment_error_platform,
          "Platform error. Please try again."
        ),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      
      throw Exception(_safeTranslate(LocaleKeys.payment_error_platform, "Platform error occurred"));
    } on SocketException catch (e) {
      log("❌ Network error during Stripe initialization: ${e.message}");
      
      await showToast(
        _safeTranslate(
          LocaleKeys.payment_error_network,
          "No internet connection"
        ),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      
      throw Exception(_safeTranslate(LocaleKeys.payment_error_network, "No internet connection"));
    } on TimeoutException catch (_) {
      log("❌ Timeout during Stripe initialization");
      
      await showToast(
        _safeTranslate(
          LocaleKeys.payment_error_timeout,
          "Payment timed out"
        ),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      
      throw Exception(_safeTranslate(LocaleKeys.payment_error_timeout, "Payment timed out"));
    } catch (e, stackTrace) {
      log("❌ Unexpected error preparing Stripe checkout: $e");
      log("   Stack trace: $stackTrace");
      
      await showToast(
        _safeTranslate(
          LocaleKeys.payment_error_unknown,
          "Unexpected error. Please try again."
        ),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      
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
  }) async {
    try {
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
        } catch (e) {
          log("⚠️  Apple Pay capability check failed: $e");
          log("   Payment Sheet will still work with card payments");
        }
        log("───────────────────────────────────────");
      }

      // DEFENSIVE CODING: Validate all required payment parameters
      // Why: Stripe SDK gives cryptic errors if parameters are invalid
      // Better to fail fast with clear, actionable error messages

      // 1. Validate Customer ID
      if (customerId.isEmpty) {
        throw ArgumentError(
          'Customer ID is required for payment processing. '
          'Please ensure your backend creates a Stripe customer and returns the ID.'
        );
      }
      if (!customerId.startsWith('cus_')) {
        log("⚠️ Warning: Customer ID format may be invalid. "
            "Expected format: cus_... (Stripe customer ID)");
      }

      // 2. Validate Payment Intent Client Secret
      if (paymentIntentClientSecret.isEmpty) {
        throw ArgumentError(
          'Payment intent client secret is required. '
          'Please ensure your backend creates a PaymentIntent and returns the client_secret.'
        );
      }
      if (!paymentIntentClientSecret.startsWith('pi_') && 
          !paymentIntentClientSecret.startsWith('seti_')) {
        log("⚠️ Warning: Payment intent secret format may be invalid. "
            "Expected format: pi_... or seti_...");
      }

      // 3. Validate Ephemeral Key Secret
      if (customerEphemeralKeySecret.isEmpty) {
        throw ArgumentError(
          'Customer ephemeral key secret is required. '
          'Please ensure your backend creates an ephemeral key and returns the secret.'
        );
      }

      // 4. Validate Country Code (ISO 3166-1 alpha-2)
      if (billingCountryCode.isEmpty) {
        throw ArgumentError(
          'Billing country code is required. '
          'Please provide a valid ISO 3166-1 alpha-2 country code (e.g., "US", "GB", "AE").'
        );
      }
      if (billingCountryCode.length != 2) {
        throw ArgumentError(
          'Invalid country code format: "$billingCountryCode". '
          'Must be exactly 2 letters (ISO 3166-1 alpha-2 format, e.g., "US", "GB", "AE").'
        );
      }
      // Ensure uppercase for consistency
      final normalizedCountryCode = billingCountryCode.toUpperCase();
      if (billingCountryCode != normalizedCountryCode) {
        log("ℹ️ Info: Country code normalized from '$billingCountryCode' to '$normalizedCountryCode'");
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
          final errorMessage = e.error.localizedMessage?.isNotEmpty == true
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
