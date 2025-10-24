import "dart:developer";
import "dart:io";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/services/payment/apple_pay/apple_pay_service_impl.dart";

/// Utility class for checking Apple Pay availability
/// 
/// This class provides static methods to check if Apple Pay is available
/// on the current device before showing it as a payment option.
class ApplePayHelper {
  /// Checks if Apple Pay is available and should be shown as a payment option
  /// 
  /// Returns true if:
  /// - Running on iOS
  /// - Apple Pay is configured in the app
  /// - Device supports Apple Pay
  /// 
  /// This method caches the result for performance
  static bool? _cachedAvailability;
  
  static Future<bool> isApplePayAvailable() async {
    // Return cached result if available
    if (_cachedAvailability != null) {
      return _cachedAvailability!;
    }

    try {
      // Only available on iOS
      if (!Platform.isIOS) {
        log("ℹ️ Apple Pay not available: Not running on iOS");
        _cachedAvailability = false;
        return false;
      }

      // Check with Apple Pay service
      final ApplePayService applePayService = locator<ApplePayService>();
      final bool isAvailable = await applePayService.isApplePaySupported();
      
      _cachedAvailability = isAvailable;
      
      if (isAvailable) {
        log("✅ Apple Pay is available on this device");
      } else {
        log("ℹ️ Apple Pay not available on this device");
      }
      
      return isAvailable;
    } catch (e) {
      log("❌ Error checking Apple Pay availability: $e");
      _cachedAvailability = false;
      return false;
    }
  }

  /// Clears the cached availability result
  /// Call this when you want to re-check Apple Pay availability
  static void clearCache() {
    _cachedAvailability = null;
    log("🔄 Apple Pay availability cache cleared");
  }

  /// Returns a user-friendly message explaining why Apple Pay might not be available
  static String getUnavailabilityReason() {
    if (!Platform.isIOS) {
      return "Apple Pay is only available on iOS devices";
    }
    return "Apple Pay is not set up on this device. Please add a card to your Apple Wallet.";
  }
}
