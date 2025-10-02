import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:app_tracking_transparency/app_tracking_transparency.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/services/consent_manager_service.dart";
import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:facebook_app_events/facebook_app_events.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:flutter/services.dart";
import "package:meta/meta.dart";

class AnalyticsServiceImpl extends AnalyticsService {
  // When true, skips platform/channel calls so internal state logic can be unit tested.
  @visibleForTesting
  static bool testMode = false;

  bool _useFirebaseAnalytics = true;
  bool _useFacebookAnalytics = true;

    // ATT related
  TrackingStatus? _attStatus;
  bool _attAuthorized = false;
  bool _attRequestAttempted = false; // prevent repeated silent requests
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
      _useFacebookAnalytics && (!_isIOS || _attAuthorized);

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
    log("Analytics service initialized with Facebook Events: $facebookAnalytics and Firebase Events: $firebaseAnalytics");

    // Enable GA4 DebugView for dev flavor (without using deprecated setAnalyticsCollectionEnabled false/true toggles).
    // GA4 DebugView picks up events if the instance is put into debug mode. We attempt both recommended approaches:
    // 1) Set a debug user property for filtering (custom) 2) Call setAnalyticsCollectionEnabled(true) redundantly.
    // If running on dev flavor we also add a verbose log.
    if (firebaseAnalytics && Environment.currentEnvironment == Environment.openSourceDev) {
      try {
        if (!testMode) {
          await _fbAnalytics.setAnalyticsCollectionEnabled(true);
          await _fbAnalytics.setUserProperty(name: 'debug_view', value: 'true');
          log('[Analytics] GA4 debug mode enabled (dev flavor).');
        } else {
          log('[Analytics][TestMode] Would enable GA4 debug view (dev flavor).');
        }
      } catch (e, st) {
        log('Failed to enable GA4 debug mode: $e\n$st');
      }
    }

    // Set up consent observer
    await _setupConsentObserver();

    // Evaluate ATT only if user already consented to advertising
    if (_isIOS && _useFacebookAnalytics) {
      await _evaluateAtt(requestIfNeeded: true);
    }

    await _applyFacebookTrackingState();
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
      if (testMode) return; // skip channel interaction in tests
      // Reinforce debug view for dev flavor just before sending (in case app restarted mid-session)
      if (Environment.currentEnvironment == Environment.openSourceDev) {
        try { await _fbAnalytics.setUserProperty(name: 'debug_view', value: 'true'); } catch (_) {}
      }
      await _fbAnalytics.logEvent(
        name: event.eventName,
        parameters: event.parameters,
      );
    } on Object catch (e, st) {
      log("Firebase logEvent error: $e\n$st");
    }
  }

  Future<void> logFaceBookEvent({
    required AnalyticEvent event,
  }) async {
    try {
      if (testMode) return; // skip channel interaction in tests
      await _fbEvents.logEvent(
        name: event.eventName,
        parameters: event.parameters,
      );
    } on Object catch (e, st) {
      log("Facebook logEvent error: $e\n$st");
    }
  }

  /// Uses Firebase native ecommerce methods for proper GA4 reporting
  Future<void> _logFirebaseEcommerce(DualProviderEvent event) async {
    try {
      if (testMode) return;
      
      // Enable debug mode if dev environment
      if (Environment.currentEnvironment == Environment.openSourceDev) {
        try { 
          await _fbAnalytics.setUserProperty(name: 'debug_view', value: 'true'); 
        } catch (_) {}
      }

      // Route to appropriate native Firebase ecommerce method
      switch (event.firebaseEventName) {
        case 'view_item_list':
          await _logViewItemList(event);
          break;
        case 'view_item':
          await _logViewItem(event);
          break;
        case 'add_to_cart':
          await _logAddToCart(event);
          break;
        case 'begin_checkout':
          await _logBeginCheckout(event);
          break;
        case 'purchase':
          await _logPurchase(event);
          break;
        default:
          // Fallback to generic logging for unknown ecommerce events
          await _logFirebaseRaw(
            name: event.firebaseEventName,
            parameters: event.firebaseParameters,
          );
      }
    } on Object catch (e, st) {
      log("Firebase ecommerce event error: $e\n$st");
    }
  }

  Future<void> _logFirebaseRaw({required String name, required Map<String, Object?> parameters}) async {
    try {
      if (testMode) return;
      
      // Remove empty lists/arrays to prevent Firebase assertion errors
      final cleanParams = <String, Object>{};
      parameters.forEach((key, value) {
        if (value != null && !(value is List && value.isEmpty)) {
          cleanParams[key] = value;
        }
      });
      
      await _fbAnalytics.logEvent(name: name, parameters: cleanParams);
    } on Object catch (e, st) {
      log("Firebase raw logEvent error: $e\n$st");
    }
  }

  Future<void> _logFacebookRaw({required String name, required Map<String, Object?> parameters}) async {
    try {
      if (testMode) return;
      
      // Facebook plugin has issues with nested ArrayList structures
      // Convert complex structures to JSON strings or flatten them
      final Map<String, Object> fbParams = _sanitizeParametersForFacebook(parameters);
      
      // Debug logging to help identify problematic parameters
      log("Facebook event '$name' with sanitized params: ${fbParams.keys.toList()}");
      
      // Additional debugging - check each parameter type
      fbParams.forEach((key, value) {
        log("FB param '$key': ${value.runtimeType} = $value");
      });
      
      await _fbEvents.logEvent(name: name, parameters: fbParams);
    } on PlatformException catch (e) {
      if (e.message?.contains('ArrayList') == true) {
        log("Facebook ArrayList error for '$name' - attempting simplified logging");
        // Fallback: Try with only primitive values
        try {
          final Map<String, Object> simpleParams = <String, Object>{};
          parameters.forEach((key, value) {
            if (value is String || value is double || value is int || value is bool) {
              simpleParams[key] = value as Object;
            }
          });
          await _fbEvents.logEvent(name: name, parameters: simpleParams);
          log("Facebook fallback logging succeeded for '$name'");
        } catch (fallbackError) {
          log("Facebook fallback logging also failed for '$name': $fallbackError");
        }
      } else {
        log("Facebook raw logEvent error for '$name': $e");
      }
    } on Object catch (e, st) {
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
      if (value == null) return;
      
      // ULTRA-AGGRESSIVE: Convert ALL complex types to strings to avoid ArrayList issues
      if (value is List) {
        // Convert ALL lists to JSON strings - no exceptions
        try {
          final String jsonString = jsonEncode(value);
          sanitized[key] = jsonString;
        } catch (e) {
          // Fallback: convert to comma-separated string
          final String fallbackString = value.map((e) => e.toString()).join(', ');
          sanitized[key] = fallbackString;
        }
      } else if (value is Map) {
        // Convert maps to JSON strings
        try {
          final String jsonString = jsonEncode(value);
          sanitized[key] = jsonString;
        } catch (e) {
          final String fallbackString = value.toString();
          sanitized[key] = fallbackString;
        }
      } else if (value is String) {
        // Ensure strings are completely new objects
        sanitized[key] = value.toString();
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
    final params = event.firebaseParameters;
    final items = params['items'] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) return;

    // Convert to AnalyticsEventItem format
    final List<AnalyticsEventItem> analyticsItems = items.map((item) {
      return AnalyticsEventItem(
        itemId: item['item_id']?.toString(),
        itemName: item['item_name']?.toString(),
        itemCategory: item['item_category']?.toString(),
        itemBrand: item['item_brand']?.toString(),
        price: _parseDouble(item['price']),
        quantity: _parseInt(item['quantity']) ?? 1,
        index: _parseInt(item['index']),
      );
    }).toList();

    await _fbAnalytics.logViewItemList(
      itemListId: params['item_list_id']?.toString(),
      itemListName: params['item_list_name']?.toString(),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logViewItem(DualProviderEvent event) async {
    final params = event.firebaseParameters;
    final items = params['items'] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) return;

    final item = items.first;
    final analyticsItem = AnalyticsEventItem(
      itemId: item['item_id']?.toString(),
      itemName: item['item_name']?.toString(),
      itemCategory: item['item_category']?.toString(),
      itemBrand: item['item_brand']?.toString(),
      price: _parseDouble(item['price']),
      quantity: _parseInt(item['quantity']) ?? 1,
    );

    await _fbAnalytics.logViewItem(
      currency: params['currency']?.toString(),
      value: _parseDouble(params['value']),
      items: [analyticsItem],
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logAddToCart(DualProviderEvent event) async {
    final params = event.firebaseParameters;
    final items = params['items'] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) return;

    final List<AnalyticsEventItem> analyticsItems = items.map((item) {
      return AnalyticsEventItem(
        itemId: item['item_id']?.toString(),
        itemName: item['item_name']?.toString(),
        itemCategory: item['item_category']?.toString(),
        itemBrand: item['item_brand']?.toString(),
        price: _parseDouble(item['price']),
        quantity: _parseInt(item['quantity']) ?? 1,
      );
    }).toList();

    await _fbAnalytics.logAddToCart(
      currency: params['currency']?.toString(),
      value: _parseDouble(params['value']),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logBeginCheckout(DualProviderEvent event) async {
    final params = event.firebaseParameters;
    final items = params['items'] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) return;

    final List<AnalyticsEventItem> analyticsItems = items.map((item) {
      return AnalyticsEventItem(
        itemId: item['item_id']?.toString(),
        itemName: item['item_name']?.toString(),
        itemCategory: item['item_category']?.toString(),
        itemBrand: item['item_brand']?.toString(),
        price: _parseDouble(item['price']),
        quantity: _parseInt(item['quantity']) ?? 1,
      );
    }).toList();

    await _fbAnalytics.logBeginCheckout(
      currency: params['currency']?.toString(),
      value: _parseDouble(params['value']),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  Future<void> _logPurchase(DualProviderEvent event) async {
    final params = event.firebaseParameters;
    final items = params['items'] as List<Map<String, Object?>>?;
    
    if (items == null || items.isEmpty) return;

    final List<AnalyticsEventItem> analyticsItems = items.map((item) {
      return AnalyticsEventItem(
        itemId: item['item_id']?.toString(),
        itemName: item['item_name']?.toString(),
        itemCategory: item['item_category']?.toString(),
        itemBrand: item['item_brand']?.toString(),
        price: _parseDouble(item['price']),
        quantity: _parseInt(item['quantity']) ?? 1,
      );
    }).toList();

    await _fbAnalytics.logPurchase(
      currency: params['currency']?.toString(),
      value: _parseDouble(params['value']),
      transactionId: params['transaction_id']?.toString(),
      tax: _parseDouble(params['tax']),
      shipping: _parseDouble(params['shipping']),
      coupon: params['coupon']?.toString(),
      items: analyticsItems,
      parameters: _extractCustomParameters(params),
    );
  }

  // Helper methods for type conversion
  double? _parseDouble(Object? value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  int? _parseInt(Object? value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  // Extract custom parameters (non-ecommerce standard ones)
  Map<String, Object>? _extractCustomParameters(Map<String, Object?> allParams) {
    final customParams = <String, Object>{};
    final standardKeys = {
      'items', 'currency', 'value', 'transaction_id', 'tax', 'shipping', 
      'coupon', 'item_list_id', 'item_list_name'
    };

    allParams.forEach((key, value) {
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

    _useFirebaseAnalytics = newFirebase;
    _useFacebookAnalytics = newFacebook;

    log("Consent ${initialLoad ? "initial" : "updated"} -> Firebase=$_useFirebaseAnalytics Facebook=$_useFacebookAnalytics ATT=$_attStatus auth=$_attAuthorized");

    // If user now enabled advertising on iOS and we have not yet requested ATT, do it once.
    if (_isIOS &&
        facebookChanged &&
        _useFacebookAnalytics &&
        !_attRequestAttempted &&
        (_attStatus == null || _attStatus == TrackingStatus.notDetermined)) {
      await _evaluateAtt(requestIfNeeded: true)
          .then((_) => _applyFacebookTrackingState());
    } else {
      // Re-evaluate Facebook tracking state
      _applyFacebookTrackingState();
    }
  }

  Future<void> _evaluateAtt({required bool requestIfNeeded}) async {
    if (!_isIOS) {
      return;
    }
    try {
      _attStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
      _attAuthorized = _attStatus == TrackingStatus.authorized;
      log("ATT status pre-request: $_attStatus");

      if (requestIfNeeded &&
          !_attAuthorized &&
          !_attRequestAttempted &&
          _attStatus == TrackingStatus.notDetermined) {
        _attRequestAttempted = true;
        final TrackingStatus result =
            await AppTrackingTransparency.requestTrackingAuthorization();
        _attStatus = result;
        _attAuthorized = result == TrackingStatus.authorized;
        log("ATT request result: $result");
      }
    } on Object catch (e) {
      log("ATT evaluation error: $e");
    }
  }

  Future<void> _applyFacebookTrackingState() async {
    final bool enable = _effectiveFacebookTracking;
    try {
      if (testMode) {
        log("[TestMode] Facebook advertiser tracking skipped (would set to $enable)");
        return;
      }
      await _fbEvents.setAdvertiserTracking(enabled: enable);
      log("Facebook advertiser tracking set to $enable (consent=$_useFacebookAnalytics attAuth=$_attAuthorized)");
    } on Object catch (e) {
      log("Failed to set Facebook advertiser tracking: $e");
    }
  }

  // Optional public helper if you want to manually trigger an ATT re-check from UI
  Future<void> refreshAttIfNeeded() async {
    if (_isIOS && _useFacebookAnalytics && !_attAuthorized) {
      await _evaluateAtt(requestIfNeeded: true);
      await _applyFacebookTrackingState();
    }
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
  bool get attAuthorizedFlag => _attAuthorized;
  @visibleForTesting
  Future<void> applyConsentForTest(Map<ConsentType, bool> consent,
          {bool initialLoad = false}) async =>
      _applyConsent(consent, initialLoad: initialLoad);
  @visibleForTesting
  void resetTestState() {
    _useFirebaseAnalytics = true;
    _useFacebookAnalytics = true;
    _attStatus = null;
    _attAuthorized = false;
    _attRequestAttempted = false;
  }
}
