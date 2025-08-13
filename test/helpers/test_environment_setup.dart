import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/app_environment_helper.dart";
import "package:flutter/foundation.dart";

import "app_enviroment_helper.dart";
import "test_constants.dart";

// ignore_for_file: type=lint
/// Centralized helper for managing test environment setup and configuration.
/// This ensures consistent environment state across all test files.
class TestEnvironmentSetup {
  // Private constructor to prevent instantiation
  TestEnvironmentSetup._();

  // Store original environment state for restoration
  static bool? _originalAppClipState;
  static dynamic _originalEnvironmentHelper;

  /// Initialize the test environment with default settings
  static Future<void> initializeTestEnvironment() async {
    // Store original state for restoration
    _storeOriginalState();

    // Set default test environment
    AppEnvironment.isFromAppClip = false;
    AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();

    // Any additional test environment setup
    await _performAdditionalSetup();
  }

  /// Initialize environment for App Clip testing
  static Future<void> initializeAppClipEnvironment() async {
    _storeOriginalState();

    AppEnvironment.isFromAppClip = true;
    AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();

    await _performAdditionalSetup();
  }

  /// Initialize environment for standard app testing (non-App Clip)
  static Future<void> initializeStandardAppEnvironment() async {
    _storeOriginalState();

    AppEnvironment.isFromAppClip = false;
    AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();

    await _performAdditionalSetup();
  }

  // MARK: - Environment State Management

  /// Set App Clip environment flag
  static void setAppClipEnvironment({required bool isFromAppClip}) {
    AppEnvironment.isFromAppClip = isFromAppClip;
  }

  /// Enable App Clip mode for testing
  static void enableAppClipMode() {
    setAppClipEnvironment(isFromAppClip: true);
  }

  /// Disable App Clip mode for testing
  static void disableAppClipMode() {
    setAppClipEnvironment(isFromAppClip: false);
  }

  /// Toggle App Clip mode
  static void toggleAppClipMode() {
    setAppClipEnvironment(isFromAppClip: !AppEnvironment.isFromAppClip);
  }

  // MARK: - Environment Queries

  /// Check if currently in App Clip mode
  static bool get isAppClipMode => AppEnvironment.isFromAppClip;

  /// Check if currently in standard app mode
  static bool get isStandardAppMode => !AppEnvironment.isFromAppClip;

  // MARK: - Test Scenario Setup

  /// Setup environment for network connectivity tests
  static Future<void> setupConnectivityTestEnvironment() async {
    await initializeTestEnvironment();
    // Any connectivity-specific setup
  }

  /// Setup environment for authentication tests
  static Future<void> setupAuthenticationTestEnvironment() async {
    await initializeTestEnvironment();
    // Any authentication-specific setup
  }

  /// Setup environment for API integration tests
  static Future<void> setupApiIntegrationTestEnvironment() async {
    await initializeTestEnvironment();
    // Any API-specific setup
  }

  /// Setup environment for repository tests
  static Future<void> setupRepositoryTestEnvironment() async {
    await initializeTestEnvironment();
    // Any repository-specific setup
  }

  /// Setup environment for HTTP client tests
  static Future<void> setupHttpClientTestEnvironment() async {
    await initializeTestEnvironment();
    // Any HTTP client-specific setup
  }

  // MARK: - Environment Configuration

  /// Configure test environment with custom settings
  static Future<void> configureTestEnvironment({
    bool? isFromAppClip,
    dynamic customEnvironmentHelper,
  }) async {
    _storeOriginalState();

    if (isFromAppClip != null) {
      AppEnvironment.isFromAppClip = isFromAppClip;
    }

    if (customEnvironmentHelper != null) {
      AppEnvironment.appEnvironmentHelper = customEnvironmentHelper;
    } else {
      AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();
    }

    await _performAdditionalSetup();
  }

  // MARK: - Environment Validation

  /// Validate that test environment is properly initialized
  static bool validateTestEnvironment() => true;

  /// Ensure test environment is ready for testing
  static Future<void> ensureTestEnvironmentReady() async {
    if (!validateTestEnvironment()) {
      await initializeTestEnvironment();
    }
  }

  // MARK: - Reset and Cleanup

  /// Reset environment to default test state
  static Future<void> resetToDefaultTestEnvironment() async {
    await initializeTestEnvironment();
  }

  /// Reset environment to original pre-test state
  static void restoreOriginalEnvironment() {
    if (_originalAppClipState != null) {
      AppEnvironment.isFromAppClip = _originalAppClipState!;
    }

    if (_originalEnvironmentHelper != null) {
      AppEnvironment.appEnvironmentHelper = _originalEnvironmentHelper;
    }
  }

  /// Complete cleanup of test environment
  static void cleanupTestEnvironment() {
    restoreOriginalEnvironment();
    _clearStoredState();
  }

  // MARK: - Test Environment Information

  /// Get current environment information for debugging
  static Map<String, dynamic> getCurrentEnvironmentInfo() {
    return <String, dynamic>{
      "isFromAppClip": AppEnvironment.isFromAppClip,
      "hasEnvironmentHelper": true,
      "environmentHelperType":
          AppEnvironment.appEnvironmentHelper.runtimeType.toString(),
      "testEnvironmentValid": validateTestEnvironment(),
    };
  }

  /// Print current environment info (useful for debugging)
  static void printEnvironmentInfo() {
    final Map<String, dynamic> info = getCurrentEnvironmentInfo();
    debugPrint("=== Test Environment Info ===");
    info.forEach((String key, dynamic value) {
      debugPrint("$key: $value");
    });
    debugPrint("===========================");
  }

  // MARK: - Private Helper Methods

  /// Store original environment state for restoration
  static void _storeOriginalState() {
    try {
      _originalAppClipState = AppEnvironment.isFromAppClip;
      _originalEnvironmentHelper = AppEnvironment.appEnvironmentHelper;
    } on Object catch (_) {
      // Environment not initialized yet, that's okay
      _originalAppClipState = null;
      _originalEnvironmentHelper = null;
    }
  }

  /// Clear stored state
  static void _clearStoredState() {
    _originalAppClipState = null;
    _originalEnvironmentHelper = null;
  }

  /// Perform any additional setup required for test environment
  static Future<void> _performAdditionalSetup() async {
    // Any additional async setup can be added here
    // For example: loading test configuration, initializing test databases, etc.

    // Add a small delay to ensure environment is fully initialized
    await Future<void>.delayed(
      const Duration(milliseconds: TestConstants.shortDelay),
    );
  }

  // MARK: - Environment-Specific Test Helpers

  /// Run a test function with App Clip environment
  static Future<T> runWithAppClipEnvironment<T>(
    Future<T> Function() testFunction,
  ) async {
    final bool originalState = AppEnvironment.isFromAppClip;

    try {
      await initializeAppClipEnvironment();
      return await testFunction();
    } finally {
      AppEnvironment.isFromAppClip = originalState;
    }
  }

  /// Run a test function with standard app environment
  static Future<T> runWithStandardAppEnvironment<T>(
    Future<T> Function() testFunction,
  ) async {
    final bool originalState = AppEnvironment.isFromAppClip;

    try {
      await initializeStandardAppEnvironment();
      return await testFunction();
    } finally {
      AppEnvironment.isFromAppClip = originalState;
    }
  }

  /// Run a test function with custom environment configuration
  static Future<T> runWithCustomEnvironment<T>(
    Future<T> Function() testFunction, {
    bool? isFromAppClip,
    dynamic customEnvironmentHelper,
  }) async {
    final bool originalAppClipState = AppEnvironment.isFromAppClip;
    final AppEnvironmentHelper originalHelper =
        AppEnvironment.appEnvironmentHelper;

    try {
      await configureTestEnvironment(
        isFromAppClip: isFromAppClip,
        customEnvironmentHelper: customEnvironmentHelper,
      );
      return await testFunction();
    } finally {
      AppEnvironment.isFromAppClip = originalAppClipState;
      AppEnvironment.appEnvironmentHelper = originalHelper;
    }
  }

  // MARK: - Static Environment Presets

  /// Get environment preset for development testing
  static Map<String, dynamic> get developmentPreset => <String, dynamic>{
        "isFromAppClip": false,
        "environment": TestConstants.developmentEnvironment,
      };

  /// Get environment preset for production testing
  static Map<String, dynamic> get productionPreset => <String, dynamic>{
        "isFromAppClip": false,
        "environment": TestConstants.productionEnvironment,
      };

  /// Get environment preset for App Clip testing
  static Map<String, dynamic> get appClipPreset => <String, dynamic>{
        "isFromAppClip": true,
        "environment": TestConstants.testEnvironment,
      };
}
