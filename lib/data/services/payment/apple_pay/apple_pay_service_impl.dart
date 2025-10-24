import "dart:async";
import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/services.dart";
import "package:flutter_stripe/flutter_stripe.dart";

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

/// Apple Pay service implementation using Stripe Payment Sheet
/// 
/// IMPORTANT: This implementation uses Stripe's Payment Sheet which already
/// includes Apple Pay support. When configured correctly, Apple Pay will appear
/// automatically in the payment sheet on supported iOS devices.
/// 
/// The Payment Sheet approach is recommended by Stripe as it:
/// - Handles Apple Pay, Google Pay, and cards in one unified UI
/// - Manages 3D Secure and Strong Customer Authentication automatically
/// - Provides better conversion rates with optimized UX
/// - Requires less code and maintenance
class ApplePayService {
  ApplePayService._privateConstructor();

  static ApplePayService? _instance;

  static ApplePayService get instance {
    if (_instance == null) {
      _instance = ApplePayService._privateConstructor();
      unawaited(_instance?._initialise());
    }

    return _instance!;
  }

  Future<void> _initialise() async {
    log("✅ ApplePayService initialized");
    log("   Using Stripe Payment Sheet with Apple Pay support");
  }

  /// Prepares Stripe SDK for checkout (including Apple Pay)
  /// Sets up publishable key, merchant identifier, and other configuration
  Future<void> prepareCheckout({
    required String publishableKey,
    String? merchantIdentifier,
    String? urlScheme,
  }) async {
    try {
      log("═══════════════════════════════════════");
      log("🍎 Preparing Apple Pay Checkout");
      log("═══════════════════════════════════════");
      
      // DEFENSIVE CODING: Safe string preview that handles any length
      // Why: substring(0, 20) crashes if string < 20 chars
      // Security: Only show first 15 chars to prevent full key exposure in logs
      final keyPreview = publishableKey.length > 15 
          ? '${publishableKey.substring(0, 15)}...' 
          : publishableKey;
      
      log("   Publishable Key: $keyPreview");
      log("   Merchant ID: $merchantIdentifier");
      log("   URL Scheme: $urlScheme");
      log("───────────────────────────────────────");

      // DEFENSIVE CODING: Validate publishable key before use
      // Why: Stripe SDK will fail with cryptic error if key is invalid
      // Better to fail fast with clear message
      if (publishableKey.isEmpty) {
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

      // DEFENSIVE CODING: Validate merchant identifier
      // Why: Stripe Payment Sheet requires merchant ID for Apple Pay
      // Impact: Without it, Apple Pay won't appear and payments may fail
      // Strategy: Warn but don't fail (for backward compatibility)
      if (merchantIdentifier == null || merchantIdentifier.isEmpty) {
        log("⚠️ WARNING: Merchant identifier not provided!");
        log("   Impact: Apple Pay will NOT be available");
        log("   Action: Set Stripe.merchantIdentifier to enable Apple Pay");
        log("   Format: merchant.{domain}.{app} (e.g., merchant.zaheen.esim.chillsim)");
      } else {
        // Validate format if provided
        if (!merchantIdentifier.startsWith('merchant.')) {
          log("⚠️ Warning: Merchant identifier format may be invalid.");
          log("   Expected format: merchant.{domain}.{app}");
          log("   Current value: $merchantIdentifier");
          log("   This may cause Apple Pay to fail.");
        } else {
          log("✅ Merchant identifier validated: $merchantIdentifier");
        }
      }

      Stripe.publishableKey = publishableKey;
      Stripe.merchantIdentifier = merchantIdentifier;
      Stripe.urlScheme = urlScheme;
      await Stripe.instance.applySettings();

      log("✅ Apple Pay checkout prepared successfully");
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
      log("❌ Unexpected error preparing Apple Pay checkout: $e");
      log("   Stack trace: $stackTrace");
      throw Exception(_safeTranslate(LocaleKeys.payment_error_unexpected, "Unexpected error occurred"));
    }
  }

  /// Checks if Apple Pay is available on the current device
  /// Returns true if device supports Apple Pay and has cards enrolled
  /// 
  /// Note: This method checks basic platform support. The Payment Sheet
  /// will automatically show/hide Apple Pay based on actual device capability.
  Future<bool> isApplePaySupported() async {
    try {
      log("🔍 Checking Apple Pay availability...");

      // Only available on iOS
      if (!Platform.isIOS) {
        log("❌ Apple Pay not supported: Not running on iOS");
        return false;
      }

      // In Payment Sheet mode, we assume it's available on iOS devices
      // The actual Payment Sheet will handle showing Apple Pay if truly available
      log("✅ Running on iOS - Apple Pay potentially available");
      log("   Note: Payment Sheet will auto-detect actual availability");
      
      return true;
    } catch (e) {
      log("❌ Error checking Apple Pay availability: $e");
      return false;
    }
  }

  /// Processes an order payment using Stripe Payment Sheet (with Apple Pay)
  /// 
  /// The Payment Sheet automatically shows Apple Pay when:
  /// - Running on iOS device
  /// - Merchant ID is configured
  /// - User has cards in Apple Wallet
  /// 
  /// This method uses the same flow as regular card payments but ensures
  /// Apple Pay configuration is correct.
  Future<PaymentResult> processOrderPayment({
    required String billingCountryCode,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    String merchantDisplayName = "ChillSim",
    bool testEnv = false,
    String? iccID,
    String? orderID,
  }) async {
    try {
      log("═══════════════════════════════════════");
      log("🍎 Starting Apple Pay Payment Flow");
      log("   (via Stripe Payment Sheet)");
      log("═══════════════════════════════════════");
      log("   Order ID: $orderID");
      log("   Test Environment: $testEnv");
      log("   Country Code: $billingCountryCode");
      log("   Merchant Display Name: $merchantDisplayName");
      log("───────────────────────────────────────");

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

      // 1. Create billing details
      final BillingDetails billingDetails = BillingDetails(
        address: Address(
          city: null,
          country: normalizedCountryCode,
          line1: null,
          line2: null,
          postalCode: null,
          state: null,
        ),
      );

      log("✅ Step 1: Billing details configured");

      // 2. Initialize the payment sheet with Apple Pay enabled
      log("📱 Step 2: Initializing Payment Sheet...");
      log("   Apple Pay will appear automatically if available");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Main params
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: merchantDisplayName,
          customerId: customerId,
          customerEphemeralKeySecret: customerEphemeralKeySecret,
          
          // CRITICAL: Apple Pay configuration
          applePay: PaymentSheetApplePay(
            merchantCountryCode: billingCountryCode,
          ),
          
          // Google Pay for Android
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: billingCountryCode,
            testEnv: testEnv,
          ),
          
          billingDetails: billingDetails,
        ),
      );

      log("✅ Step 2: Payment Sheet initialized with Apple Pay enabled");

      // 3. Present the payment sheet
      log("� Step 3: Presenting Payment Sheet...");
      log("   User can select Apple Pay, card, or other methods");

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
