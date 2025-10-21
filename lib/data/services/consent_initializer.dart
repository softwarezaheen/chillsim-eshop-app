import "dart:developer" as dev;

import "package:esim_open_source/data/services/consent_manager_service.dart";
import "package:esim_open_source/presentation/views/shared/consent_dialog.dart";
import "package:flutter/material.dart";

/// Handles consent initialization and first-time consent requests
class ConsentInitializer {
  static final ConsentManagerService _consentService = ConsentManagerService();

  /// Initialize consent system on app startup
  static Future<void> initialize() async {
    await _consentService.initialize();
    dev.log("[ConsentInitializer] ConsentManagerService initialized");
    
    // DO NOT set default consent here - that would mark user as having set consent!
    // Default consent will be applied by ConsentManagerService.initializeConsent()
    // when it detects no user consent has been set.
  }

  /// Check if we should show consent dialog to user
  /// CRITICAL FIX: Now uses ConsentManagerService.hasUserSetConsent()
  static Future<bool> shouldShowConsentDialog() async {
    // Check if user has EVER set consent (from ConsentManagerService)
    final bool hasUserSetConsent = await _consentService.hasUserSetConsent();
    
    dev.log("[ConsentInitializer] shouldShowConsentDialog - hasUserSetConsent: $hasUserSetConsent, shouldShow: ${!hasUserSetConsent}");
    
    return !hasUserSetConsent;
  }

  /// Mark consent dialog as shown (DEPRECATED - now handled by updateConsent)
  /// Kept for backwards compatibility but does nothing
  static Future<void> markConsentDialogShown() async {
    dev.log("[ConsentInitializer] markConsentDialogShown called (deprecated - handled by updateConsent)");
    // No-op: The flag is now set automatically in ConsentManagerService.updateConsent()
  }

  /// Show consent dialog if needed (for first-time users or updates)
  static Future<void> showConsentDialogIfNeeded(BuildContext context) async {
    dev.log("[ConsentInitializer] Checking if should show consent dialog...");
    if (await shouldShowConsentDialog()) {
      dev.log("[ConsentInitializer] Showing consent dialog");
      await showConsentDialog(context);
      // No need to call markConsentDialogShown() - updateConsent() handles it
      dev.log("[ConsentInitializer] Consent dialog completed");
    } else {
      dev.log("[ConsentInitializer] Consent already set, skipping dialog");
    }
  }

  /// Force show consent dialog (for settings/profile)
  static Future<void> showConsentSettings(BuildContext context) async {
    await showConsentDialog(context);
  }

  /// Reset consent dialog state (for testing)
  static Future<void> resetConsentDialogState() async {
    await _consentService.resetConsent();
    dev.log("[ConsentInitializer] Reset consent dialog state");
  }

  /// Reset and immediately show consent dialog (for testing)
  static Future<void> resetAndShowConsentDialog(BuildContext context) async {
    await resetConsentDialogState();
    // Show immediately after reset
    await Future.delayed(const Duration(milliseconds: 100));
    await showConsentDialog(context);
    dev.log("[ConsentInitializer] Reset and showed consent dialog immediately");
  }
}
