import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";


import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/services/analytics_service_att_extension.dart";
import "package:esim_open_source/data/services/consent_manager_service.dart";
import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:facebook_app_events/facebook_app_events.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:flutter/services.dart";
import "package:meta/meta.dart";

class AnalyticsServiceImpl extends AnalyticsService with AnalyticsServiceATTMixin {
  // When true, skips platform/channel calls so internal state logic can be unit tested.
  @visibleForTesting
  static bool testMode = false;

  bool _useFirebaseAnalytics = true;
  bool _useFacebookAnalytics = true;

  FacebookAppEvents? _facebookAppEvents; // lazily created (skipped in test mode)
  FirebaseAnalytics? _firebaseAppEvents; // lazily created (skipped in test mode)

  // Consent observer
  StreamSubscription<Map<ConsentType, bool>>? _consentSubscription;

  static AnalyticsServiceImpl? _instance;

  static AnalyticsServiceImpl get instance {
    _instance ??= AnalyticsServiceImpl().._logInit();
    return _instance!;
  }

  void _logInit()=> log("Analytics Logging Service Initialized");

  bool get _isIOS => Platform.isIOS;
  bool get _effectiveFacebookTracking =>
      _useFacebookAnalytics && (!_isIOS || attAuthorizedForTesting);

  // Lazy getters (avoid touching plugins in test mode)
  FacebookAppEvents get _fbEvents =>
    _facebookAppEvents ??= FacebookAppEvents();
  FirebaseAnalytics get _fbAnalytics =>
    _firebaseAppEvents ??= FirebaseAnalytics.instance;

  @override
  Future<void> configure({
    bool firebaseAnalytics = true,
    bool facebookAnalytics = true,
  }) async {
    _useFirebaseAnalytics = firebaseAnalytics;
    _useFacebookAnalytics = facebookAnalytics;
    log("🔥 Analytics service initializing - Firebase: $firebaseAnalytics, Facebook: $facebookAnalytics");

    // Enable GA4 DebugView for dev flavor (without using deprecated setAnalyticsCollectionEnabled false/true toggles).
    // GA4 DebugView picks up events if the instance is put into debug mode. We attempt both recommended approaches:
    // 1) Set a debug user property for filtering (custom) 2) Call setAnalyticsCollectionEnabled(true) redundantly.
    // If running on dev flavor we also add a verbose log.
    if (firebaseAnalytics && Environment.currentEnvironment == Environment.openSourceDev) {
      try {
        if (!testMode) {
          await _fbAnalytics.setAnalyticsCollectionEnabled(true);
          await _fbAnalytics.setUserProperty(name: "debug_view", value: "true");
          log("[Analytics] GA4 debug mode enabled (dev flavor).");
        } else {
          log("[Analytics][TestMode] Would enable GA4 debug view (dev flavor).");
        }
      } on Exception catch (e, st) {
        log("Failed to enable GA4 debug mode: $e\n$st");
      }
    }

    // Initialize ATT system (iOS only)
    await initializeATT();

    // Set up consent observer
    await _setupConsentObserver();

    // Check for iOS Settings changes on startup
    await checkForIOSSettingsChange();

    await _applyFacebookTrackingState();
    
    log("🔥 Analytics service configuration complete");
  }

  @override
  Future<void> logEvent({
    required AnalyticEvent event,
  }) async {
    log("Logging event of type ${event.eventName}");
    // Adaptive dual provider support with GA4 native ecommerce
    if (event is DualProviderEvent) {
      if (_useFirebaseAnalytics) {
        await _logFirebaseEcommerce(event);
      }
      if (_effectiveFacebookTracking) {
        _logFacebookRaw(
          name: event.facebookEventName,
          parameters: event.facebookParameters,
        );
      }
      return;
    }
    
    // Legacy event logging
    if (_useFirebaseAnalytics) {
      logFireBaseEvent(event: event);
    }
    if (_effectiveFacebookTracking) {
      logFaceBookEvent(event: event);
    }
  }

  Future<void> logFireBaseEvent({
    required AnalyticEvent event,
  }) async {
    try {
      if (testMode) {
        return; // skip channel interaction in tests
      }
      // Reinforce debug view for dev flavor just before sending (in case app restarted mid-session)
      if (Environment.currentEnvironment == Environment.openSourceDev) {
        try {
          await _fbAnalytics.setUserProperty(name: "debug_view", value: "true");
        } on Exception catch (_) {
          // Ignore exceptions when setting debug view
        }
      }
      await _fbAnalytics.logEvent(
        name: event.eventName,
        parameters: event.parameters,
      );
    } on Exception catch (e, st) {
      log("Firebase logEvent error: $e\n$st");
    }
  }

  Future<void> logFaceBookEvent({
    required AnalyticEvent event,
  }) async {
    try {
      if (testMode) {
        return; // skip channel interaction in tests
      }
      await _fbEvents.logEvent(
        name: event.eventName,
        parameters: event.parameters,
      );
    } on Exception catch (e, st) {
      log("Facebook logEvent error: $e\n$st");
    }
  }

  /// Uses Firebase native ecommerce methods for proper GA4 reporting
  Future<void> _logFirebaseEcommerce(DualProviderEvent event) async {
    try {
      if (testMode) {
        return;
      }
      
      // Enable debug mode if dev environment
      if (Environment.currentEnvironment == Environment.openSourceDev) {
        try {
          await _fbAnalytics.setUserProperty(name: "debug_view", value: "true");
        } on Exception catch (_) {
          // Ignore exceptions when setting debug view
        }
      }

      // Route to appropriate native Firebase ecommerce method
      switch (event.firebaseEventName) {
        case "view_item_list":
          await _logViewItemList(event);
        case "view_item":
          await _logViewItem(event);
        case "add_to_cart":
          await _logAddToCart(event);
        case "begin_checkout":
          await _logBeginCheckout(event);
        case "purchase":
          await _logPurchase(event);
        default:
          // Fallback to generic logging for unknown ecommerce events
          await _logFirebaseRaw(
            name: event.firebaseEventName,
            parameters: event.firebaseParameters,
          );
      }
    } on Exception catch (e, st) {
      log("Firebase ecommerce event error: $e\n$st");
    }
  }

  Future<void> _logFirebaseRaw({required String name, required Map<String, Object?> parameters}) async {
    try {
      if (testMode) {
        return;
      }
      
      // Remove empty lists/arrays to prevent Firebase assertion errors
      final Map<String, Object> cleanParams = <String, Object>{};
      parameters.forEach((String key, Object? value) {
        if (value != null && !(value is List && value.isEmpty)) {
          cleanParams[key] = value;
        }
      });
      
      await _fbAnalytics.logEvent(name: name, parameters: cleanParams);
    } on Exception catch (e, st) {
      log("Firebase raw logEvent error: $e\n$st");
    }
  }

  Future<void> _logFacebookRaw({required String name, required Map<String, Object?> parameters}) async {
    try {
      if (testMode) {
        return;
      }
      
      // Facebook plugin has issues with nested ArrayList structures
      // Convert complex structures to JSON strings or flatten them
      final Map<String, Object> fbParams = _sanitizeParametersForFacebook(parameters);
      
      // Debug logging to help identify problematic parameters
      log("Facebook event '$name' with sanitized params: ${fbParams.keys.toList()}");
      
      // Additional debugging - check each parameter type
      fbParams.forEach((String key, Object value) {
        log("FB param '$key': ${value.runtimeType} = $value");
      });
      
      await _fbEvents.logEvent(name: name, parameters: fbParams);
    } on PlatformException catch (e) {
      if (e.message?.contains("ArrayList") ?? false) {
        log("Facebook ArrayList error for '$name' - attempting simplified logging");
        // Fallback: Try with only primitive values
        try {
          final Map<String, Object> simpleParams = <String, Object>{};
          parameters.forEach((String key, Object? value) {
            if (value is String || value is double || value is int || value is bool) {
              simpleParams[key] = value!;
            }
          });
          await _fbEvents.logEvent(name: name, parameters: simpleParams);
          log("Facebook fallback logging succeeded for '$name'");
        } on Exception catch (fallbackError) {
          log("Facebook fallback logging also failed for '$name': $fallbackError");
        }
      } else {
        log("Facebook raw logEvent error for '$name': $e");
      }
    } on Exception catch (e, st) {
      log("Facebook raw logEvent error for '$name': $e");
      log("Original parameters: ${parameters.keys.toList()}");
      log("Sanitized parameters: ${_sanitizeParametersForFacebook(parameters).keys.toList()}");
      log("Stack trace: $st");
    }
  }

  // Sanitize Facebook parameters to avoid ArrayList serialization issues
  Map<String, Object> _sanitizeParametersForFacebook(Map<String, Object?> params) {
    // Create completely new map to avoid any reference issues
    final Map<String, Object> sanitized = <String, Object>{};
    
    params.forEach((String key, Object? value) {
      if (value == null) {
        return;
      }
      
      // ULTRA-AGGRESSIVE: Convert ALL complex types to strings to avoid ArrayList issues
      if (value is List) {
        // Convert ALL lists to JSON strings - no exceptions
        try {
          final String jsonString = jsonEncode(value);
          sanitized[key] = jsonString;
        } on Exception {
          // Fallback: convert to comma-separated string
          final String fallbackString = value.map((dynamic e) => e.toString()).join(", ");
          sanitized[key] = fallbackString;
        }
      } else if (value is Map) {
        // Convert maps to JSON strings
        try {
          final String jsonString = jsonEncode(value);
          sanitized[key] = jsonString;
        } on Exception {
          final String fallbackString = value.toString();
          sanitized[key] = fallbackString;
        }
      } else if (value is String) {
        // Ensure strings are completely new objects
        sanitized[key] = value;
      } else if (value is double || value is int || value is bool) {
        // Keep primitive numeric/boolean types as-is
        sanitized[key] = value;
      } else {
        // Convert any other complex type to string
        sanitized[key] = value.toString();
      }
    });
    
    return sanitized;
  }

  Future<void> _logViewItemList(DualProviderEvent event) async {
    final Map<String, Object?> params = event.firebaseParameters;
    final List<Map<String, Object?>>? items = params["items"] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) {
      return;
    }

    // Convert to AnalyticsEventItem format
    final List<AnalyticsEventItem> analyticsItems = items.map((Map<String, Object?> item) {
      return AnalyticsEventItem(
        itemId: item["item_id"]?.toString(),
        itemName: item["item_name"]?.toString(),
        itemCategory: item["item_category"]?.toString(),
        itemBrand: item["item_brand"]?.toString(),
        price: _parseDouble(item["price"]),
        quantity: _parseInt(item["quantity"]) ?? 1,
        index: _parseInt(item["index"]),
      );
    }).toList();

    await _fbAnalytics.logViewItemList(
      itemListId: params["item_list_id"]?.toString(),
      itemListName: params["item_list_name"]?.toString(),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logViewItem(DualProviderEvent event) async {
    final Map<String, Object?> params = event.firebaseParameters;
    final List<Map<String, Object?>>? items = params["items"] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) {
      return;
    }

    final Map<String, Object?> item = items.first;
    final AnalyticsEventItem analyticsItem = AnalyticsEventItem(
      itemId: item["item_id"]?.toString(),
      itemName: item["item_name"]?.toString(),
      itemCategory: item["item_category"]?.toString(),
      itemBrand: item["item_brand"]?.toString(),
      price: _parseDouble(item["price"]),
      quantity: _parseInt(item["quantity"]) ?? 1,
    );

    await _fbAnalytics.logViewItem(
      currency: params["currency"]?.toString(),
      value: _parseDouble(params["value"]),
      items: <AnalyticsEventItem>[analyticsItem],
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logAddToCart(DualProviderEvent event) async {
    final Map<String, Object?> params = event.firebaseParameters;
    final List<Map<String, Object?>>? items = params["items"] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) {
      return;
    }

    final List<AnalyticsEventItem> analyticsItems = items.map((Map<String, Object?> item) {
      return AnalyticsEventItem(
        itemId: item["item_id"]?.toString(),
        itemName: item["item_name"]?.toString(),
        itemCategory: item["item_category"]?.toString(),
        itemBrand: item["item_brand"]?.toString(),
        price: _parseDouble(item["price"]),
        quantity: _parseInt(item["quantity"]) ?? 1,
      );
    }).toList();

    await _fbAnalytics.logAddToCart(
      currency: params["currency"]?.toString(),
      value: _parseDouble(params["value"]),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logBeginCheckout(DualProviderEvent event) async {
    final Map<String, Object?> params = event.firebaseParameters;
    final List<Map<String, Object?>>? items = params["items"] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) {
      return;
    }

    final List<AnalyticsEventItem> analyticsItems = items.map((Map<String, Object?> item) {
      return AnalyticsEventItem(
        itemId: item["item_id"]?.toString(),
        itemName: item["item_name"]?.toString(),
        itemCategory: item["item_category"]?.toString(),
        itemBrand: item["item_brand"]?.toString(),
        price: _parseDouble(item["price"]),
        quantity: _parseInt(item["quantity"]) ?? 1,
      );
    }).toList();

    await _fbAnalytics.logBeginCheckout(
      currency: params["currency"]?.toString(),
      value: _parseDouble(params["value"]),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logPurchase(DualProviderEvent event) async {
    final Map<String, Object?> params = event.firebaseParameters;
    final List<Map<String, Object?>>? items = params["items"] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) {
      return;
    }

    final List<AnalyticsEventItem> analyticsItems = items.map((Map<String, Object?> item) {
      return AnalyticsEventItem(
        itemId: item["item_id"]?.toString(),
        itemName: item["item_name"]?.toString(),
        itemCategory: item["item_category"]?.toString(),
        itemBrand: item["item_brand"]?.toString(),
        price: _parseDouble(item["price"]),
        quantity: _parseInt(item["quantity"]) ?? 1,
      );
    }).toList();

    await _fbAnalytics.logPurchase(
      currency: params["currency"]?.toString(),
      value: _parseDouble(params["value"]),
      transactionId: params["transaction_id"]?.toString(),
      tax: _parseDouble(params["tax"]),
      shipping: _parseDouble(params["shipping"]),
      coupon: params["coupon"]?.toString(),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  // Helper methods for type conversion
  double? _parseDouble(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  int? _parseInt(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  // Extract custom parameters (non-ecommerce standard ones)
  Map<String, Object>? _extractCustomParameters(Map<String, Object?> allParams) {
    final Map<String, Object> customParams = <String, Object>{};
    final Set<String> standardKeys = <String>{
      "items", "currency", "value", "transaction_id", "tax", "shipping", 
      "coupon", "item_list_id", "item_list_name",
    };

    allParams.forEach((String key, Object? value) {
      if (!standardKeys.contains(key) && value != null) {
        customParams[key] = value;
      }
    });

    return customParams.isEmpty ? null : customParams;
  }

  Future<void> _setupConsentObserver() async {
    // Cancel existing subscription if any
    await _consentSubscription?.cancel();

    // Get initial consent status
    final ConsentManagerService consentManager = ConsentManagerService.instance;
    final Map<ConsentType, bool> initial =
        await consentManager.getConsentStatus();

    await _applyConsent(initial, initialLoad: true);

    _consentSubscription = consentManager.consentStream.listen(_applyConsent);
  }

  Future<void> _applyConsent(
    Map<ConsentType, bool> consent, {
    bool initialLoad = false,
  }) async {
    final bool newFirebase = consent[ConsentType.analytics] ?? true;
    final bool newFacebook = consent[ConsentType.advertising] ?? false;

    final bool facebookChanged = newFacebook != _useFacebookAnalytics;
    final bool firebaseChanged = newFirebase != _useFirebaseAnalytics;

    _useFirebaseAnalytics = newFirebase;
    _useFacebookAnalytics = newFacebook;

    log("🔥 Consent ${initialLoad ? "INITIAL" : "UPDATE"} -> Analytics: $newFirebase (changed: $firebaseChanged) | Advertising: $newFacebook (changed: $facebookChanged)");

    // ⚠️ APPLE ATT COMPLIANCE: Request ATT when user enables tracking
    if (Platform.isIOS) {
      final bool userWantsTracking = newFirebase || newFacebook;
      final bool justEnabledTracking = 
          (firebaseChanged && newFirebase) || (facebookChanged && newFacebook);
      
      if (userWantsTracking && justEnabledTracking) {
        log("🍎 User enabled tracking - checking ATT requirements");
        
        final AttRequestResult result = await requestAttIfNeeded(
          userWantsTracking: userWantsTracking,
          justEnabledTracking: justEnabledTracking,
        );
        
        // Handle ATT request results
        switch (result) {
          case AttRequestResult.authorized:
            log("🍎 ✅ ATT authorized - enabling tracking");
          case AttRequestResult.denied:
            log("🍎 ❌ ATT denied - disabling tracking");
            await handleAttDenial();
            return; // Exit early - consent was updated
          case AttRequestResult.previouslyDenied:
            log("🍎 ⚠️ ATT previously denied - UI should show guidance");
            // This will be handled by the UI layer
          case AttRequestResult.notNeeded:
            log("🍎 ATT request not needed");
          default:
            log("🍎 ATT result: $result");
        }
      }
      
      // Check for iOS Settings changes if user re-enabled tracking
      if (userWantsTracking && justEnabledTracking && !initialLoad) {
        await checkForIOSSettingsChange();
      }
    }
    
    // Apply tracking state
    await _applyFacebookTrackingState();
  }

  // ATT handling is now managed by AnalyticsServiceATTMixin

  Future<void> _applyFacebookTrackingState() async {
    final bool enable = _effectiveFacebookTracking;
    try {
      if (testMode) {
        log("[TestMode] Facebook advertiser tracking skipped (would set to $enable)");
        return;
      }
      await _fbEvents.setAdvertiserTracking(enabled: enable);
      log("Facebook advertiser tracking set to $enable (consent=$_useFacebookAnalytics attAuth=$attAuthorizedForTesting)");
    } on Object catch (e) {
      log("Failed to set Facebook advertiser tracking: $e");
    }
  }

  // Optional public helper to check for iOS Settings changes
  Future<void> refreshAttIfNeeded() async {
    await checkForIOSSettingsChange();
  }

  // Dispose method to clean up resources
  @override
  Future<void> dispose() async {
    await _consentSubscription?.cancel();
  }

  // ---------- Testing helpers (no production usage) ----------
  @visibleForTesting
  bool get firebaseEnabledFlag => _useFirebaseAnalytics;
  @visibleForTesting
  bool get facebookEnabledFlag => _useFacebookAnalytics;
  @visibleForTesting
  bool get attAuthorizedFlag => attAuthorizedForTesting;
  @visibleForTesting
  Future<void> applyConsentForTest(Map<ConsentType, bool> consent,
          {bool initialLoad = false,}) async =>
      _applyConsent(consent, initialLoad: initialLoad);
  @visibleForTesting
  void resetTestState() {
    _useFirebaseAnalytics = true;
    _useFacebookAnalytics = true;
    unawaited(resetAttStateForTesting());
  }
}
