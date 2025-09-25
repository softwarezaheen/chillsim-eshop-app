import "dart:developer" as dev;

import "package:esim_open_source/data/services/consent_manager_service.dart";
import "package:esim_open_source/presentation/views/shared/consent_dialog.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

/// Handles consent initialization and first-time consent requests
class ConsentInitializer {
  static const String _firstTimeConsentKey = "first_time_consent_shown";
  static final ConsentManagerService _consentService = ConsentManagerService();

  /// Initialize consent system on app startup
  static Future<void> initialize() async {
    await _consentService.initialize();
    
    // Set default consent values for first-time users
    final bool hasConsent = await _consentService.hasAnyConsent();
    if (!hasConsent) {
      await _consentService.setDefaultConsent();
    }
  }

  /// Check if we should show consent dialog to user
  static Future<bool> shouldShowConsentDialog() async {
    final SharedPreferences preferences = await _consentService.getPreferences();
    final bool hasShown = preferences.getBool(_firstTimeConsentKey) ?? false;
    dev.log("ConsentInitializer: hasShown = $hasShown, shouldShow = ${!hasShown}");
    return !hasShown;
  }

  /// Mark consent dialog as shown
  static Future<void> markConsentDialogShown() async {
    final SharedPreferences preferences = await _consentService.getPreferences();
    await preferences.setBool(_firstTimeConsentKey, true);
  }

  /// Show consent dialog if needed (for first-time users or updates)
  static Future<void> showConsentDialogIfNeeded(BuildContext context) async {
    dev.log("ConsentInitializer: Checking if should show consent dialog...");
    if (await shouldShowConsentDialog()) {
      dev.log("ConsentInitializer: Showing consent dialog");
      await showConsentDialog(context);
      await markConsentDialogShown();
      dev.log("ConsentInitializer: Consent dialog completed");
    } else {
      dev.log("ConsentInitializer: Consent dialog already shown, skipping");
    }
  }

  /// Force show consent dialog (for settings/profile)
  static Future<void> showConsentSettings(BuildContext context) async {
    await showConsentDialog(context);
  }

  /// Reset consent dialog state (for testing)
  static Future<void> resetConsentDialogState() async {
    final SharedPreferences preferences = await _consentService.getPreferences();
    await preferences.remove(_firstTimeConsentKey);
    dev.log("ConsentInitializer: Reset consent dialog state");
  }

  /// Reset and immediately show consent dialog (for testing)
  static Future<void> resetAndShowConsentDialog(BuildContext context) async {
    await resetConsentDialogState();
    // Show immediately after reset
    await Future.delayed(const Duration(milliseconds: 100));
    await showConsentDialog(context);
    // Don't mark as shown here - let the dialog handle it when user makes a choice
    dev.log("ConsentInitializer: Reset and showed consent dialog immediately");
  }
}
