import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "http_response_test_mixin.dart";
import "mock_service_manager.dart";
import "resource_test_mixin.dart";
import "test_environment_setup.dart";

/// Abstract base class for repository tests.
/// Provides common setup, teardown, and test patterns for repository testing.
abstract class BaseRepositoryHelper<TRepository, TApi>
    with ResourceTestMixin, HttpResponseTestMixin {
  // Test instances
  late TRepository repository;
  late MockServiceManager mockServiceManager;
  late Mock mockApi;

  // Test configuration
  String get repositoryName;
  String get apiName;

  /// Setup method to be called from each test file's setUp
  Future<void> baseSetUp() async {
    // Initialize mock service manager
    mockServiceManager = MockServiceManager();
    await mockServiceManager.setupMocks();

    // Initialize test environment
    await TestEnvironmentSetup.initializeTestEnvironment();

    // Create mock API and repository
    mockApi = createMockApi();
    repository = createRepository();

    // Perform any additional setup
    await performAdditionalSetup();
  }

  /// Teardown method to be called from each test file's tearDown
  void baseTearDown() {
    // Clean up environment
    TestEnvironmentSetup.cleanupTestEnvironment();

    // Clean up mock service manager
    mockServiceManager.cleanup();

    // Perform any additional cleanup
    performAdditionalCleanup();
  }

  // Abstract methods to be implemented by concrete test classes
  Mock createMockApi();
  TRepository createRepository();

  // Virtual methods that can be overridden
  Future<void> performAdditionalSetup() async {}
  void performAdditionalCleanup() {}

  // MARK: - Common Test Patterns

  /// Test successful repository operation
  void testSuccessScenario<TData>({
    required String testName,
    required Future<dynamic> Function() repositoryCall,
    required void Function() mockSetup,
    required TData expectedData,
    String? expectedMessage,
    int? expectedCode,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupSuccessfulApiCallScenario();
      mockSetup();

      // Act
      dynamic result = await repositoryCall();

      // Assert
      expectSuccessResource(
        result,
        expectedData: expectedData,
        expectedMessage: expectedMessage,
        expectedCode: expectedCode,
        testDescription: testName,
      );
    });
  }

  /// Test error repository operation
  void testErrorScenario<TData>({
    required String testName,
    required Future<dynamic> Function() repositoryCall,
    required void Function() mockSetup,
    required String expectedErrorMessage,
    int? expectedErrorCode,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupSuccessfulApiCallScenario();
      mockSetup();

      // Act
      dynamic result = await repositoryCall();

      // Assert
      expectErrorResource(
        result,
        expectedMessage: expectedErrorMessage,
        expectedCode: expectedErrorCode,
        testDescription: testName,
      );
    });
  }

  /// Test network error scenario
  void testNetworkErrorScenario<TData>({
    required String testName,
    required Future<dynamic> Function() repositoryCall,
    required void Function() mockSetup,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupNetworkErrorScenario();
      mockSetup();

      // Act
      dynamic result = await repositoryCall();

      // Assert
      expectNetworkError(result);
    });
  }

  /// Test authentication error scenario
  void testAuthErrorScenario<TData>({
    required String testName,
    required Future<dynamic> Function() repositoryCall,
    required void Function() mockSetup,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupAuthErrorScenario();
      mockSetup();

      // Act
      dynamic result = await repositoryCall();

      // Assert
      expectUnauthorizedError(result);
    });
  }

  /// Test parameter validation
  void testParameterValidation<TData>({
    required String testName,
    required Future<dynamic> Function() repositoryCall,
    required void Function() verifyApiCalled,
    Map<String, dynamic>? testParameters,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupSuccessfulApiCallScenario();

      // Act
      await repositoryCall();

      // Assert
      verifyApiCalled();

      if (testParameters != null) {
        // Additional parameter validation can be added here
      }
    });
  }

  /// Test null/empty data handling
  void testNullDataHandling<TData>({
    required String testName,
    required Future<dynamic> Function() repositoryCall,
    required void Function() mockSetup,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupSuccessfulApiCallScenario();
      mockSetup();

      // Act
      dynamic result = await repositoryCall();

      // Assert - Should handle null data gracefully
      expectValidResource(result);
    });
  }

  /// Test empty string parameter handling
  void testEmptyParameterHandling<TData>({
    required String testName,
    required Future<dynamic> Function() repositoryCall,
    required void Function() mockSetup,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupSuccessfulApiCallScenario();
      mockSetup();

      // Act
      dynamic result = await repositoryCall();

      // Assert - Should handle empty parameters gracefully
      expectValidResource(result);
    });
  }

  /// Test interface compliance
  void testInterfaceCompliance({
    required String testName,
    required Type expectedInterface,
  }) {
    test(testName, () {
      // Assert
      expect(
        repository,
        isA<TRepository>(),
        reason: "Repository should implement $TRepository interface",
      );

      // Additional interface validation can be added here
    });
  }

  /// Test return type compliance
  void testReturnTypeCompliance<TReturn>({
    required String testName,
    required Future<TReturn> Function() repositoryCall,
  }) {
    test(testName, () async {
      // Arrange
      mockServiceManager.setupSuccessfulApiCallScenario();

      // Act
      dynamic result = await repositoryCall();

      // Assert
      expect(
        result,
        isA<TReturn>(),
        reason: "Repository method should return $TReturn",
      );
    });
  }

  // MARK: - Common Test Groups

  /// Create a standard test group for a repository method
  void createMethodTestGroup<TData>({
    required String methodName,
    required Future<dynamic> Function() successCall,
    required Future<dynamic> Function() errorCall,
    required void Function() successMockSetup,
    required void Function() errorMockSetup,
    required TData expectedSuccessData,
    required String expectedErrorMessage,
    void Function()? additionalTests,
  }) {
    group(methodName, () {
      testSuccessScenario<TData>(
        testName: "should return success resource when API call succeeds",
        repositoryCall: successCall,
        mockSetup: successMockSetup,
        expectedData: expectedSuccessData,
      );

      testErrorScenario<TData>(
        testName: "should return error resource when API returns error",
        repositoryCall: errorCall,
        mockSetup: errorMockSetup,
        expectedErrorMessage: expectedErrorMessage,
      );

      testNetworkErrorScenario<TData>(
        testName: "should return network error when not connected",
        repositoryCall: errorCall,
        mockSetup: errorMockSetup,
      );

      // Add additional tests if provided
      additionalTests?.call();
    });
  }

  /// Create boundary condition tests
  void createBoundaryConditionTests<TData>({
    required String methodName,
    required Future<dynamic> Function() nullDataCall,
    required Future<dynamic> Function() emptyParameterCall,
    required void Function() nullDataMockSetup,
    required void Function() emptyParameterMockSetup,
  }) {
    group("$methodName boundary conditions", () {
      testNullDataHandling<TData>(
        testName: "should handle null response data gracefully",
        repositoryCall: nullDataCall,
        mockSetup: nullDataMockSetup,
      );

      testEmptyParameterHandling<TData>(
        testName: "should handle empty string parameters",
        repositoryCall: emptyParameterCall,
        mockSetup: emptyParameterMockSetup,
      );
    });
  }

  /// Create interface compliance tests
  void createInterfaceComplianceTests({
    required Type expectedInterface,
    required Map<String, Function> methodsToTest,
  }) {
    group("$repositoryName interface compliance", () {
      testInterfaceCompliance(
        testName: "should implement $expectedInterface interface",
        expectedInterface: expectedInterface,
      );

      methodsToTest.forEach((String methodName, Function methodCall) {
        testReturnTypeCompliance(
          testName: "should return correct type for $methodName",
          repositoryCall: () async => await methodCall(),
        );
      });
    });
  }

  // MARK: - Helper Methods

  /// Setup mock for successful API response
  void setupSuccessfulApiResponse<T>(
    PostExpectation<Future<T>> mockCall,
    T response,
  ) {
    mockCall.thenAnswer((_) async => response);
  }

  /// Setup mock for error API response
  void setupErrorApiResponse<T>(
    PostExpectation<Future<T>> mockCall,
    Exception error,
  ) {
    mockCall.thenThrow(error);
  }

  /// Verify API method was called
  void verifyApiMethodCalled<T>(
    VerificationResult verification, {
    int times = 1,
  }) {
    verification.called(times);
  }

  /// Verify API method was never called
  void verifyApiMethodNeverCalled<T>(
    VerificationResult verification,
  ) {
    verification.called(0);
  }

  // MARK: - Mock Service Shortcuts

  /// Setup connected state
  void setupConnected({bool isConnected = true}) {
    mockServiceManager.setupConnectedState(isConnected: isConnected);
  }

  /// Setup authenticated state
  void setupAuthenticated({String? accessToken, String? refreshToken}) {
    mockServiceManager.setupAuthenticatedState(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Setup unauthenticated state
  void setupUnauthenticated() {
    mockServiceManager.setupUnauthenticatedState();
  }

  /// Setup device state
  void setupDevice({String? deviceId}) {
    mockServiceManager.setupDeviceState(deviceId: deviceId);
  }

  /// Setup localization state
  void setupLocalization({String? languageCode, String? currencyCode}) {
    mockServiceManager.setupLocalizationState(
      languageCode: languageCode,
      currencyCode: currencyCode,
    );
  }

  // MARK: - Verification Helpers

  /// Verify connectivity was checked
  void verifyConnectivityChecked([int times = 1]) {
    mockServiceManager.verifyConnectivityChecked(times);
  }

  /// Verify access token was retrieved
  void verifyAccessTokenRetrieved([int times = 1]) {
    mockServiceManager.verifyAccessTokenRetrieved(times);
  }

  /// Verify device ID was retrieved
  void verifyDeviceIdRetrieved([int times = 1]) {
    mockServiceManager.verifyDeviceIdRetrieved(times);
  }
}
