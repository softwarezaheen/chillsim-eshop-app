import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:mockito/mockito.dart";

import "../locator_test.dart";
import "../locator_test.mocks.dart";
import "test_constants.dart";

/// Centralized manager for all mock services used across test files.
/// This eliminates duplicate mock setup code and provides consistent behavior.
class MockServiceManager {
  /// Factory constructor for creating new instances when needed
  factory MockServiceManager() => MockServiceManager._internal();

  MockServiceManager._internal();
  // Mock service instances
  late MockConnectivityService mockConnectivityService;
  late MockLocalStorageService mockLocalStorageService;
  late MockDeviceInfoService mockDeviceInfoService;
  late MockSecureStorageService mockSecureStorageService;
  late MockAPIApp mockApiApp;
  late MockAPIDevice mockApiDevice;

  // Singleton pattern for consistent mock state across tests
  static MockServiceManager? _instance;
  static MockServiceManager get instance {
    _instance ??= MockServiceManager._internal();
    return _instance!;
  }

  /// Initialize all mock services with default behaviors
  Future<void> setupMocks() async {
    await setupTestLocator();

    // Get mock instances from locator
    mockConnectivityService =
        locator<ConnectivityService>() as MockConnectivityService;
    mockLocalStorageService =
        locator<LocalStorageService>() as MockLocalStorageService;
    mockDeviceInfoService =
        locator<DeviceInfoService>() as MockDeviceInfoService;
    mockSecureStorageService =
        locator<SecureStorageService>() as MockSecureStorageService;

    // Additional mocks if registered in locator
    try {
      mockApiApp = locator<MockAPIApp>();
    } on Object catch (_) {
      // MockAPIApp not registered in locator, will be handled separately
    }

    try {
      mockApiDevice = locator<MockAPIDevice>();
    } on Object catch (_) {
      // MockAPIDevice not registered in locator, will be handled separately
    }

    _setupDefaultBehaviors();
  }

  /// Setup default mock behaviors that work for most test cases
  void _setupDefaultBehaviors() {
    // Connectivity Service defaults
    when(mockConnectivityService.isConnected()).thenAnswer((_) async => true);

    // Local Storage Service defaults
    when(mockLocalStorageService.accessToken)
        .thenReturn(TestConstants.testAccessToken);
    when(mockLocalStorageService.refreshToken)
        .thenReturn(TestConstants.testRefreshToken);
    when(mockLocalStorageService.languageCode)
        .thenReturn(TestConstants.defaultLanguageCode);
    when(mockLocalStorageService.currencyCode)
        .thenReturn(TestConstants.defaultCurrencyCode);

    // Secure Storage Service defaults
    when(mockSecureStorageService.getString(any))
        .thenAnswer((_) async => TestConstants.testDeviceId);

    // Device Info Service defaults
    when(mockDeviceInfoService.deviceID)
        .thenAnswer((_) async => TestConstants.testDeviceId);
  }

  // MARK: - Connectivity Service Configuration

  /// Configure connectivity service to return connected state
  void setupConnectedState({bool isConnected = true}) {
    when(mockConnectivityService.isConnected())
        .thenAnswer((_) async => isConnected);
  }

  /// Configure connectivity service to return disconnected state
  void setupDisconnectedState() {
    setupConnectedState(isConnected: false);
  }

  // MARK: - Authentication State Configuration

  /// Configure authentication with valid tokens
  void setupAuthenticatedState({
    String? accessToken,
    String? refreshToken,
  }) {
    when(mockLocalStorageService.accessToken)
        .thenReturn(accessToken ?? TestConstants.testAccessToken);
    when(mockLocalStorageService.refreshToken)
        .thenReturn(refreshToken ?? TestConstants.testRefreshToken);
  }

  /// Configure authentication with empty/invalid tokens
  void setupUnauthenticatedState() {
    when(mockLocalStorageService.accessToken).thenReturn("");
    when(mockLocalStorageService.refreshToken).thenReturn("");
  }

  /// Configure authentication with only access token (no refresh token)
  void setupPartialAuthState({String? accessToken}) {
    when(mockLocalStorageService.accessToken)
        .thenReturn(accessToken ?? TestConstants.testAccessToken);
    when(mockLocalStorageService.refreshToken).thenReturn("");
  }

  // MARK: - Localization Configuration

  /// Configure language and currency settings
  void setupLocalizationState({
    String? languageCode,
    String? currencyCode,
  }) {
    when(mockLocalStorageService.languageCode)
        .thenReturn(languageCode ?? TestConstants.defaultLanguageCode);
    when(mockLocalStorageService.currencyCode)
        .thenReturn(currencyCode ?? TestConstants.defaultCurrencyCode);
  }

  /// Setup multiple language test scenarios
  void setupMultiLanguageTest() {
    when(mockLocalStorageService.languageCode)
        .thenReturn("ar"); // Arabic for testing RTL
  }

  // MARK: - Device Configuration

  /// Configure device info service responses
  void setupDeviceState({
    String? deviceId,
    String? secureStorageDeviceId,
  }) {
    when(mockDeviceInfoService.deviceID)
        .thenAnswer((_) async => deviceId ?? TestConstants.testDeviceId);

    when(mockSecureStorageService.getString(any)).thenAnswer(
      (_) async => secureStorageDeviceId ?? TestConstants.testDeviceId,
    );
  }

  /// Configure device to simulate device ID generation failure
  void setupDeviceIdFailure() {
    when(mockDeviceInfoService.deviceID)
        .thenThrow(Exception("Failed to get device ID"));
  }

  // MARK: - Error State Configuration

  /// Configure connectivity service to throw exceptions
  void setupConnectivityError() {
    when(mockConnectivityService.isConnected())
        .thenThrow(Exception("Connectivity check failed"));
  }

  /// Configure secure storage to throw exceptions
  void setupSecureStorageError() {
    when(mockSecureStorageService.getString(any))
        .thenThrow(Exception("Secure storage access failed"));
  }

  // MARK: - Test Scenario Presets

  /// Setup for typical successful API call scenario
  void setupSuccessfulApiCallScenario() {
    setupConnectedState();
    setupAuthenticatedState();
    setupDeviceState();
    setupLocalizationState();
  }

  /// Setup for network error scenario
  void setupNetworkErrorScenario() {
    setupDisconnectedState();
    setupAuthenticatedState();
    setupDeviceState();
  }

  /// Setup for authentication error scenario
  void setupAuthErrorScenario() {
    setupConnectedState();
    setupUnauthenticatedState();
    setupDeviceState();
  }

  /// Setup for device error scenario
  void setupDeviceErrorScenario() {
    setupConnectedState();
    setupAuthenticatedState();
    setupDeviceIdFailure();
  }

  // MARK: - Mock Verification Helpers

  /// Verify that connectivity was checked
  void verifyConnectivityChecked([int times = 1]) {
    verify(mockConnectivityService.isConnected()).called(times);
  }

  /// Verify that access token was retrieved
  void verifyAccessTokenRetrieved([int times = 1]) {
    verify(mockLocalStorageService.accessToken).called(times);
  }

  /// Verify that device ID was retrieved
  void verifyDeviceIdRetrieved([int times = 1]) {
    verify(mockDeviceInfoService.deviceID).called(times);
  }

  // MARK: - Reset and Cleanup

  /// Reset all mocks to their default state
  void resetAllMocks() {
    reset(mockConnectivityService);
    reset(mockLocalStorageService);
    reset(mockDeviceInfoService);
    reset(mockSecureStorageService);

    _setupDefaultBehaviors();
  }

  /// Reset specific mock service
  void resetMock(dynamic mockService) {
    reset(mockService);
  }

  /// Cleanup resources (called in tearDown)
  void cleanup() {
    // Any cleanup logic if needed
  }

  // MARK: - Custom Mock Behaviors

  /// Setup custom behavior for any mock service
  void setupCustomBehavior<T>(
    Function() mockGetter,
    Function(dynamic mock) whenSetup,
    T response,
  ) {
    // Implementation would depend on specific mock setup patterns
    // This is a placeholder for extensibility
  }

  /// Setup custom async behavior for any mock service
  void setupCustomAsyncBehavior<T>(
    Function() mockGetter,
    Function(dynamic mock) whenSetup,
    T response,
  ) {
    // Implementation would depend on specific mock setup patterns
    // This is a placeholder for extensibility
  }
}
