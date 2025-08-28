import "dart:developer";

import "package:app_tracking_transparency/app_tracking_transparency.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:facebook_app_events/facebook_app_events.dart";
import "package:firebase_analytics/firebase_analytics.dart";

class AnalyticsServiceImpl extends AnalyticsService {
  bool _useFirebaseAnalytics = true;
  bool _useFacebookAnalytics = true;

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();
  final FirebaseAnalytics _firebaseAppEvents = FirebaseAnalytics.instance;

  static AnalyticsServiceImpl? _instance;

  static AnalyticsServiceImpl get instance {
    if (_instance == null) {
      _instance = AnalyticsServiceImpl();
      log("Initialize Analytics Logging Service");
    }
    return _instance!;
  }

  @override
  Future<void> configure({
    bool firebaseAnalytics = true,
    bool facebookAnalytics = true,
  }) async {
    _useFirebaseAnalytics = firebaseAnalytics;
    _useFacebookAnalytics = facebookAnalytics;
    log("Analytics service initialized with Facebook Events: $facebookAnalytics and Firebase Events: $firebaseAnalytics");

    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;

    log("ATT permission result: $status");

    if (status == TrackingStatus.notDetermined || status == TrackingStatus.denied || status == TrackingStatus.restricted) {
      final TrackingStatus result =
          await AppTrackingTransparency.requestTrackingAuthorization();
      log("ATT permission result: $result");
      if (result == TrackingStatus.authorized) {
        _facebookAppEvents.setAdvertiserTracking(enabled: true);
      }
    } else if (status == TrackingStatus.authorized) {
      _facebookAppEvents.setAdvertiserTracking(enabled: true);
    }
  }

  @override
  Future<void> logEvent({
    required AnalyticEvent event,
  }) async {
    log("Logging event of type ${event.eventName}");
    if (_useFirebaseAnalytics) {
      logFireBaseEvent(event: event);
    }

    if (_useFacebookAnalytics) {
      logFaceBookEvent(event: event);
    }
  }

  Future<void> logFireBaseEvent({
    required AnalyticEvent event,
  }) async {
    await _firebaseAppEvents.logEvent(
      name: event.eventName,
      parameters: event.parameters,
    );
  }

  Future<void> logFaceBookEvent({
    required AnalyticEvent event,
  }) async {
    try {
      await _facebookAppEvents.logEvent(
        name: event.eventName,
        parameters: event.parameters,
      );
    } on Object catch (ex) {
      log("Error exception: $ex");
    }
  }
}
