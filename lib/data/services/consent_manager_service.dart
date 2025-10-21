import "dart:async";
import "dart:developer";

import "package:firebase_analytics/firebase_analytics.dart";
import "package:shared_preferences/shared_preferences.dart";

enum ConsentType {
  analytics,
  advertising,
  personalization,
  functional,
}

class ConsentManagerService {
  factory ConsentManagerService() {
    return _instance;
  }
  ConsentManagerService._internal();
  static final ConsentManagerService _instance = ConsentManagerService._internal();
  static ConsentManagerService get instance => _instance;

  static const String _keyAnalyticsConsent = "consent_analytics";
  static const String _keyAdvertisingConsent = "consent_advertising";
  static const String _keyPersonalizationConsent = "consent_personalization";
  static const String _keyFunctionalConsent = "consent_functional";
  static const String _keyConsentTimestamp = "consent_timestamp";
  static const String _keyConsentVersion = "consent_version";
  static const String _keyConsentShown = "consent_shown";
  static const String _keyHasUserSetConsent = "has_user_set_consent"; // CRITICAL FIX

  static const String currentConsentVersion = "1.0";

  // Stream for consent changes
  final StreamController<Map<ConsentType, bool>> _consentController = StreamController<Map<ConsentType, bool>>.broadcast();
  Stream<Map<ConsentType, bool>> get consentStream => _consentController.stream;

  Future<void> initializeConsent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasShownConsent = prefs.getBool(_keyConsentShown) ?? false;

    if (!hasShownConsent) {
      // Set default consent state - analytics defaults to TRUE
      await _setFirebaseConsentMode(
        analytics: true,
        advertising: false,
        personalization: false,
        functional: true, // Always required for basic functionality
      );
    } else {
      // Load existing consent
      await _loadAndApplyConsent();
    }
  }

  Future<void> updateConsent({
    required bool analytics,
    required bool advertising,
    required bool personalization,
    required bool functional,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    log("[ConsentManager] Updating consent - Analytics: $analytics, Advertising: $advertising");

    // Save consent preferences
    await prefs.setBool(_keyAnalyticsConsent, analytics);
    await prefs.setBool(_keyAdvertisingConsent, advertising);
    await prefs.setBool(_keyPersonalizationConsent, personalization);
    await prefs.setBool(_keyFunctionalConsent, functional);
    await prefs.setString(_keyConsentTimestamp, DateTime.now().toIso8601String());
    await prefs.setString(_keyConsentVersion, currentConsentVersion);
    await prefs.setBool(_keyConsentShown, true);
    
    // CRITICAL FIX: Set explicit flag that user has set consent
    await prefs.setBool(_keyHasUserSetConsent, true);
    
    log("[ConsentManager] Consent saved. hasUserSetConsent flag set to true");

    // Apply to Firebase
    await _setFirebaseConsentMode(
      analytics: analytics,
      advertising: advertising,
      personalization: personalization,
      functional: functional,
    );

    // Emit consent change to stream
    final Map<ConsentType, bool> consentMap = <ConsentType, bool>{
      ConsentType.analytics: analytics,
      ConsentType.advertising: advertising,
      ConsentType.personalization: personalization,
      ConsentType.functional: functional,
    };
    _consentController.add(consentMap);
  }

  Future<Map<ConsentType, bool>> getConsentStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final Map<ConsentType, bool> consent = <ConsentType, bool>{
      ConsentType.analytics: prefs.getBool(_keyAnalyticsConsent) ?? true,
      ConsentType.advertising: prefs.getBool(_keyAdvertisingConsent) ?? false,
      ConsentType.personalization: prefs.getBool(_keyPersonalizationConsent) ?? false,
      ConsentType.functional: prefs.getBool(_keyFunctionalConsent) ?? true,
    };
    
    return consent;
  }

  Future<bool> hasShownConsentDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyConsentShown) ?? false;
  }

  Future<DateTime?> getConsentTimestamp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? timestamp = prefs.getString(_keyConsentTimestamp);
    return timestamp != null ? DateTime.parse(timestamp) : null;
  }

  Future<void> _loadAndApplyConsent() async {
    final Map<ConsentType, bool> consent = await getConsentStatus();
    await _setFirebaseConsentMode(
      analytics: consent[ConsentType.analytics]!,
      advertising: consent[ConsentType.advertising]!,
      personalization: consent[ConsentType.personalization]!,
      functional: consent[ConsentType.functional]!,
    );
  }

  Future<void> _setFirebaseConsentMode({
    required bool analytics,
    required bool advertising,
    required bool personalization,
    required bool functional,
  }) async {
    try {
      // Set consent mode for Firebase Analytics
      await FirebaseAnalytics.instance.setConsent(
        adStorageConsentGranted: advertising,
        analyticsStorageConsentGranted: analytics,
        adUserDataConsentGranted: personalization,
      );
      
      // Also set analytics collection enabled/disabled
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(analytics);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> resetConsent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAnalyticsConsent);
    await prefs.remove(_keyAdvertisingConsent);
    await prefs.remove(_keyPersonalizationConsent);
    await prefs.remove(_keyFunctionalConsent);
    await prefs.remove(_keyConsentTimestamp);
    await prefs.remove(_keyConsentVersion);
    await prefs.remove(_keyConsentShown);
    await prefs.remove(_keyHasUserSetConsent); // CRITICAL: Also remove the new flag
    
    log("[ConsentManager] Consent reset - all flags cleared");
  }

  // Additional methods for ConsentInitializer
  Future<void> initialize() async {
    await initializeConsent();
  }

  /// CRITICAL METHOD: Check if user has explicitly set consent
  /// This is what determines if the dialog should show
  Future<bool> hasUserSetConsent() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    // Check both new and old flags for backwards compatibility
    final bool hasSetConsent = prefs.getBool(_keyHasUserSetConsent) ?? false;
    final bool hasShownConsent = prefs.getBool(_keyConsentShown) ?? false;
    
    final bool result = hasSetConsent || hasShownConsent;
    
    log("[ConsentManager] hasUserSetConsent: $result (hasSet: $hasSetConsent, hasShown: $hasShownConsent)");
    
    return result;
  }

  Future<bool> hasAnyConsent() async {
    return hasUserSetConsent(); // Use the new method
  }

  Future<void> setDefaultConsent() async {
    await updateConsent(
      analytics: true,
      advertising: false,
      personalization: false,
      functional: true,
    );
  }

  Future<SharedPreferences> getPreferences() async {
    return SharedPreferences.getInstance();
  }

  // Dispose method to clean up resources
  Future<void> dispose() async {
    await _consentController.close();
  }
}
