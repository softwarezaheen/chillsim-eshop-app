import "dart:async";
import "dart:developer";
import "dart:io";

import "package:app_tracking_transparency/app_tracking_transparency.dart";
import "package:esim_open_source/data/services/consent_manager_service.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:facebook_app_events/facebook_app_events.dart";
import "package:firebase_analytics/firebase_analytics.dart";
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
