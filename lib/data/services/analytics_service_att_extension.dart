import "dart:async";
import "dart:developer";
import "dart:io";

import "package:app_tracking_transparency/app_tracking_transparency.dart";
import "package:esim_open_source/data/services/consent_manager_service.dart";
import "package:shared_preferences/shared_preferences.dart";

/// ATT (App Tracking Transparency) Extension for AnalyticsServiceImpl
/// 
/// REASONING:
/// - Apple requires ATT permission before enabling tracking
/// - Once denied, Apple prevents programmatic re-requests for privacy protection
/// - Must detect iOS Settings changes and provide user guidance
/// - Maintain compliance state persistently
mixin AnalyticsServiceATTMixin {
  // ATT State Management
  TrackingStatus? _attStatus;
  bool _attAuthorized = false;
  bool _attRequestAttempted = false;
  bool _attEverAccepted = false;
  
  // SharedPreferences key for persistent ATT acceptance tracking
  static const String _keyAttEverAccepted = 'att_ever_accepted';
  
  /// Initialize ATT state on service startup
  Future<void> initializeATT() async {
    if (!Platform.isIOS) return;
    
    await _loadAttAcceptanceState();
    await _evaluateCurrentAttStatus();
    
    log("🍎 ATT initialized - Status: $_attStatus, Authorized: $_attAuthorized, EverAccepted: $_attEverAccepted");
  }
  
  /// Load persistent ATT acceptance state
  Future<void> _loadAttAcceptanceState() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      _attEverAccepted = prefs.getBool(_keyAttEverAccepted) ?? false;
      log("🍎 Loaded ATT acceptance state: $_attEverAccepted");
    } catch (e) {
      log("Error loading ATT acceptance state: $e");
      _attEverAccepted = false;
    }
  }
  
  /// Save ATT acceptance state permanently
  Future<void> _saveAttAcceptanceState(bool accepted) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyAttEverAccepted, accepted);
      _attEverAccepted = accepted;
      log("🍎 Saved ATT acceptance state: $accepted");
    } catch (e) {
      log("Error saving ATT acceptance state: $e");
    }
  }
  
  /// Get current ATT status without requesting
  Future<void> _evaluateCurrentAttStatus() async {
    if (!Platform.isIOS) return;
    
    try {
      _attStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
      _attAuthorized = _attStatus == TrackingStatus.authorized;
      log("🍎 Current ATT status: $_attStatus, authorized: $_attAuthorized");
    } catch (e) {
      log("🍎 Error evaluating ATT status: $e");
    }
  }
  
  /// Request ATT permission when user enables tracking
  /// CRITICAL: Only requests if not previously attempted and status allows it
  Future<AttRequestResult> requestAttIfNeeded({
    required bool userWantsTracking,
    required bool justEnabledTracking,
  }) async {
    if (!Platform.isIOS) {
      return AttRequestResult.notApplicable;
    }
    
    // Check if we should request ATT
    final bool shouldRequest = userWantsTracking && 
        justEnabledTracking && 
        !_attEverAccepted && 
        !_attRequestAttempted &&
        (_attStatus == null || _attStatus == TrackingStatus.notDetermined);
    
    log("🍎 ATT REQUEST CHECK: shouldRequest=$shouldRequest (tracking=$userWantsTracking, enabled=$justEnabledTracking, everAccepted=$_attEverAccepted, attempted=$_attRequestAttempted, status=$_attStatus)");
    
    if (!shouldRequest) {
      // Check if user previously denied and is trying to enable tracking
      if (userWantsTracking && justEnabledTracking && _attRequestAttempted) {
        return AttRequestResult.previouslyDenied;
      }
      return AttRequestResult.notNeeded;
    }
    
    // Request ATT permission
    try {
      _attRequestAttempted = true;
      log("🍎 🚀 REQUESTING ATT AUTHORIZATION");
      
      final TrackingStatus result = await AppTrackingTransparency.requestTrackingAuthorization();
      _attStatus = result;
      _attAuthorized = result == TrackingStatus.authorized;
      
      log("🍎 ATT REQUEST RESULT: $result");
      
      if (result == TrackingStatus.authorized) {
        await _saveAttAcceptanceState(true);
        return AttRequestResult.authorized;
      } else if (result == TrackingStatus.denied) {
        // User chose "Ask app not to track"
        return AttRequestResult.denied;
      }
      
      return AttRequestResult.restricted;
    } catch (e) {
      log("🍎 ATT request error: $e");
      return AttRequestResult.error;
    }
  }
  
  /// Handle ATT denial by disabling tracking consent
  /// CRITICAL: Enforces Apple's ATT decision
  Future<void> handleAttDenial() async {
    try {
      log("🍎 HANDLING ATT DENIAL: Disabling tracking consent");
      
      final ConsentManagerService consentManager = ConsentManagerService.instance;
      await consentManager.updateConsent(
        analytics: false,
        advertising: false,
        necessary: true, // Always true
        functional: true, // Keep functional enabled
      );
      
      log("🍎 Consent disabled after ATT denial");
    } catch (e) {
      log("Error handling ATT denial: $e");
    }
  }
  
  /// Check for iOS Settings tracking permission changes
  /// Call when app becomes active or user opens privacy settings
  Future<bool> checkForIOSSettingsChange() async {
    if (!Platform.isIOS || _attEverAccepted) {
      return false; // Skip if not iOS or already accepted
    }
    
    try {
      final TrackingStatus currentStatus = await AppTrackingTransparency.trackingAuthorizationStatus;
      
      // If status changed from denied to authorized, user enabled in iOS Settings
      if (currentStatus == TrackingStatus.authorized && _attStatus == TrackingStatus.denied) {
        log("🍎 🎉 USER ENABLED TRACKING IN iOS SETTINGS!");
        
        _attAuthorized = true;
        _attStatus = currentStatus;
        await _saveAttAcceptanceState(true);
        
        return true; // Tracking was enabled
      }
      
      _attStatus = currentStatus;
      _attAuthorized = currentStatus == TrackingStatus.authorized;
      
      return false; // No change
    } catch (e) {
      log("Error checking iOS Settings change: $e");
      return false;
    }
  }
  
  /// Check if tracking is blocked by ATT
  bool isTrackingBlockedByATT() {
    return Platform.isIOS && !_attAuthorized && _attRequestAttempted;
  }
  
  /// Get ATT guidance message key for UI
  String getAttGuidanceMessageKey() {
    if (!Platform.isIOS) return '';
    
    if (_attStatus == TrackingStatus.denied) {
      return 'attGuidance_denied_message';
    } else if (_attStatus == TrackingStatus.restricted) {
      return 'attGuidance_restricted_message';
    } else if (_attRequestAttempted && !_attAuthorized) {
      return 'attGuidance_general_message';
    }
    
    return '';
  }
  
  /// Reset ATT state (testing only)
  Future<void> resetAttStateForTesting() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyAttEverAccepted);
      
      _attEverAccepted = false;
      _attRequestAttempted = false;
      _attStatus = null;
      _attAuthorized = false;
      
      log("🍎 ATT state reset for testing");
    } catch (e) {
      log("Error resetting ATT state: $e");
    }
  }
  
  // Getters for testing
  bool get attAuthorizedForTesting => _attAuthorized;
  bool get attEverAcceptedForTesting => _attEverAccepted;
  bool get attRequestAttemptedForTesting => _attRequestAttempted;
  TrackingStatus? get attStatusForTesting => _attStatus;
}

/// Result of ATT request operation
enum AttRequestResult {
  authorized,       // User granted permission
  denied,          // User chose "Ask app not to track"
  restricted,      // Restricted by device policy
  previouslyDenied, // Previously denied, need iOS Settings
  notNeeded,       // Request not needed
  notApplicable,   // Not iOS platform
  error,           // Error during request
}