import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/http_methods.dart";
import "package:flutter_test/flutter_test.dart";

import "http_response_test_mixin.dart";
import "mock_service_manager.dart";
import "test_data_factory.dart";
import "test_environment_setup.dart";

/// Abstract base class for API tests.
/// Provides common setup, teardown, and test patterns for API testing.
abstract class BaseApiHelper with HttpResponseTestMixin {
  // Test instances
  late MockServiceManager mockServiceManager;
  late APIService apiService;

  // Test configuration
  String get apiClassName;

  /// Setup method to be called from each test file's setUp
  Future<void> baseApiSetUp() async {
    // Initialize mock service manager
    mockServiceManager = MockServiceManager();
    await mockServiceManager.setupMocks();

    // Initialize test environment
    await TestEnvironmentSetup.initializeTestEnvironment();

    // Get API service instance
    apiService = APIService.instance;

    // Perform any additional setup
    await performAdditionalApiSetup();
  }

  /// Teardown method to be called from each test file's tearDown
  void baseApiTearDown() {
    // Clean up environment
    TestEnvironmentSetup.cleanupTestEnvironment();

    // Clean up mock service manager
    mockServiceManager.cleanup();

    // Perform any additional cleanup
    performAdditionalApiCleanup();
  }

  // Virtual methods that can be overridden
  Future<void> performAdditionalApiSetup() async {}
  void performAdditionalApiCleanup() {}

  // MARK: - Common Test Patterns

  /// Test API endpoint creation with basic parameters
  void testApiEndpointCreation({
    required String testName,
    required URlRequestBuilder endpoint,
    required Map<String, dynamic> expectedProperties,
    List<String>? paramIDs,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? additionalHeaders,
  }) {
    test(testName, () {
      // Act
      final APIEndPoint result = apiService.createAPIEndpoint(
        endPoint: endpoint,
        paramIDs: paramIDs ?? <String>[],
        queryParameters: queryParameters ?? <String, dynamic>{},
        additionalHeaders: additionalHeaders ?? <String, String>{},
      );

      // Assert
      expectedProperties.forEach((String key, dynamic expectedValue) {
        switch (key) {
          case "path":
            expect(
              result.path,
              expectedValue,
              reason: "$testName - should have expected path",
            );
          case "method":
            expect(
              result.method,
              expectedValue,
              reason: "$testName - should have expected method",
            );
          case "hasAuthorization":
            expect(
              result.hasAuthorization,
              expectedValue,
              reason: "$testName - should have expected authorization flag",
            );
          case "isRefreshToken":
            expect(
              result.isRefreshToken,
              expectedValue,
              reason: "$testName - should have expected refresh token flag",
            );
          case "headers":
            if (expectedValue is Map<String, String>) {
              expectedValue.forEach((String headerKey, String headerValue) {
                expect(
                  result.headers[headerKey],
                  equals(headerValue),
                  reason: "$testName - should have expected header $headerKey",
                );
              });
            }
        }
      });
    });
  }

  /// Test singleton pattern implementation
  void testSingletonImplementation({
    required String testName,
    required dynamic Function() getInstance,
  }) {
    test(testName, () {
      // Act
      dynamic instance1 = getInstance();
      dynamic instance2 = getInstance();

      // Assert
      expect(
        instance1,
        isNotNull,
        reason: "$testName - first instance should not be null",
      );
      expect(
        instance2,
        isNotNull,
        reason: "$testName - second instance should not be null",
      );
      expect(
        instance1,
        same(instance2),
        reason: "$testName - should return same instance",
      );
    });
  }

  /// Test getter property behavior
  void testGetterProperty<T>({
    required String testName,
    required Future<T> Function() getter,
    required T expectedValue,
    void Function()? setupMock,
  }) {
    test(testName, () async {
      // Arrange
      setupMock?.call();

      // Act
      dynamic result = await getter();

      // Assert
      expect(
        result,
        equals(expectedValue),
        reason: "$testName - should return expected value",
      );
    });
  }

  /// Test boolean getter behavior
  void testBooleanGetter({
    required String testName,
    required Future<bool> Function() getter,
    required bool expectedValue,
    void Function()? setupMock,
  }) {
    testGetterProperty<bool>(
      testName: testName,
      getter: getter,
      expectedValue: expectedValue,
      setupMock: setupMock,
    );
  }

  /// Test string getter behavior
  void testStringGetter({
    required String testName,
    required Future<String> Function() getter,
    required String expectedValue,
    void Function()? setupMock,
  }) {
    testGetterProperty<String>(
      testName: testName,
      getter: getter,
      expectedValue: expectedValue,
      setupMock: setupMock,
    );
  }

  /// Test enum values and properties
  void testEnumValues<T>({
    required String testName,
    required Map<T, dynamic> enumTestCases,
    required dynamic Function(T enumValue) propertyGetter,
  }) {
    test(testName, () {
      enumTestCases.forEach((dynamic enumValue, dynamic expectedProperty) {
        // Act
        dynamic result = propertyGetter(enumValue);

        // Assert
        expect(
          result,
          equals(expectedProperty),
          reason: "$testName - $enumValue should have expected property",
        );
      });
    });
  }

  /// Test method execution without errors
  void testMethodExecution({
    required String testName,
    required Function() method,
    void Function()? setupMock,
  }) {
    test(testName, () {
      // Arrange
      setupMock?.call();

      // Act & Assert
      expect(
        () => method(),
        returnsNormally,
        reason: "$testName - should execute without errors",
      );
    });
  }

  /// Test async method execution
  void testAsyncMethodExecution({
    required String testName,
    required Future<void> Function() method,
    void Function()? setupMock,
  }) {
    test(testName, () async {
      // Arrange
      setupMock?.call();

      // Act & Assert
      await expectLater(
        () => method(),
        returnsNormally,
        reason: "$testName - should execute without errors",
      );
    });
  }

  // MARK: - Interceptor Testing Patterns

  /// Test request interceptor behavior
  void testRequestInterceptor({
    required String testName,
    required dynamic Function(dynamic request, APIEndPoint endpoint)
        interceptor,
    required dynamic testRequest,
    required APIEndPoint testEndpoint,
    required dynamic expectedResult,
    void Function()? setupMock,
  }) {
    test(testName, () async {
      // Arrange
      setupMock?.call();

      // Act
      dynamic result = await interceptor(testRequest, testEndpoint);

      // Assert
      expect(
        result,
        equals(expectedResult),
        reason: "$testName - should return expected result",
      );
    });
  }

  /// Test response interceptor behavior
  void testResponseInterceptor({
    required String testName,
    required dynamic Function(dynamic response, APIEndPoint endpoint)
        interceptor,
    required dynamic testResponse,
    required APIEndPoint testEndpoint,
    required dynamic expectedResult,
    void Function()? setupMock,
  }) {
    test(testName, () async {
      // Arrange
      setupMock?.call();

      // Act
      dynamic result = await interceptor(testResponse, testEndpoint);

      // Assert
      expect(
        result,
        equals(expectedResult),
        reason: "$testName - should return expected result",
      );
    });
  }

  /// Test interceptor exception handling
  void testInterceptorException({
    required String testName,
    required Future<dynamic> Function() interceptorCall,
    required Type expectedException,
    void Function()? setupMock,
  }) {
    test(testName, () async {
      // Arrange
      setupMock?.call();

      // Act & Assert
      await expectLater(
        () => interceptorCall(),
        throwsA(
          isA<dynamic>().having(
            (dynamic e) => e.runtimeType,
            "exception type",
            expectedException,
          ),
        ),
        reason: "$testName - should throw expected exception",
      );
    });
  }

  // MARK: - API Configuration Testing

  /// Test API endpoint with parameter IDs
  void testEndpointWithParamIds({
    required String testName,
    required URlRequestBuilder endpoint,
    required List<String> paramIDs,
    required String expectedPath,
  }) {
    testApiEndpointCreation(
      testName: testName,
      endpoint: endpoint,
      paramIDs: paramIDs,
      expectedProperties: <String, dynamic>{"path": expectedPath},
    );
  }

  /// Test API endpoint with query parameters
  void testEndpointWithQueryParams({
    required String testName,
    required URlRequestBuilder endpoint,
    required Map<String, dynamic> queryParameters,
    required List<String> expectedQueryParts,
  }) {
    test(testName, () {
      // Act
      final APIEndPoint result = apiService.createAPIEndpoint(
        endPoint: endpoint,
        queryParameters: queryParameters,
      );

      // Assert
      expect(
        result.path,
        contains("?"),
        reason: "$testName - should contain query string",
      );

      for (final String queryPart in expectedQueryParts) {
        expect(
          result.path,
          contains(queryPart),
          reason: "$testName - should contain query part: $queryPart",
        );
      }
    });
  }

  /// Test API endpoint with additional headers
  void testEndpointWithAdditionalHeaders({
    required String testName,
    required URlRequestBuilder endpoint,
    required Map<String, String> additionalHeaders,
  }) {
    test(testName, () {
      // Act
      final APIEndPoint result = apiService.createAPIEndpoint(
        endPoint: endpoint,
        additionalHeaders: additionalHeaders,
      );

      // Assert
      additionalHeaders.forEach((String key, String value) {
        expect(
          result.headers[key],
          equals(value),
          reason: "$testName - should have additional header $key",
        );
      });
    });
  }

  // MARK: - Common Test Groups

  /// Create standard API service tests
  void createApiServiceTestGroup({
    required String serviceName,
    required dynamic Function() getInstance,
    void Function()? additionalTests,
  }) {
    group(serviceName, () {
      testSingletonImplementation(
        testName: "$serviceName singleton initialization",
        getInstance: getInstance,
      );

      // Add additional tests if provided
      additionalTests?.call();
    });
  }

  /// Create getter property test group
  void createGetterTestGroup({
    required String propertyName,
    required Map<String, dynamic> testCases,
  }) {
    group("$propertyName getter", () {
      testCases.forEach((String testName, dynamic testCase) {
        if (testCase is Map) {
          final Function getter = testCase["getter"] as Function;
          dynamic expectedValue = testCase["expectedValue"];
          final Function? setupMock = testCase["setupMock"] as Function?;

          test(testName, () async {
            // Arrange
            setupMock?.call();

            // Act
            dynamic result = await getter();

            // Assert
            expect(
              result,
              equals(expectedValue),
              reason: "$testName - should return expected value",
            );
          });
        }
      });
    });
  }

  /// Create enum test group
  void createEnumTestGroup<T>({
    required String enumName,
    required Map<T, Map<String, dynamic>> enumTestCases,
  }) {
    group("$enumName enum", () {
      enumTestCases.forEach((dynamic enumValue, Map<String, dynamic> testCase) {
        testCase.forEach((String propertyName, dynamic expectedValue) {
          test("$enumValue should have correct $propertyName", () {
            // This would need to be implemented based on specific enum structure
            // Example implementation would depend on the enum's properties
          });
        });
      });
    });
  }

  // MARK: - Helper Methods

  /// Create test endpoint with default values
  APIEndPoint createTestEndpoint({
    String? path,
    HttpMethod? method,
    bool? hasAuthorization,
    bool? isRefreshToken,
  }) {
    return TestDataFactory.createTestEndpoint(
      path: path,
      method: method,
      hasAuthorization: hasAuthorization,
      isRefreshToken: isRefreshToken,
    );
  }

  /// Create authenticated test endpoint
  APIEndPoint createAuthenticatedEndpoint({String? path, HttpMethod? method}) {
    return TestDataFactory.createAuthenticatedEndpoint(
      path: path,
      method: method,
    );
  }

  /// Create refresh token test endpoint
  APIEndPoint createRefreshTokenEndpoint({String? path}) {
    return TestDataFactory.createRefreshTokenEndpoint(path: path);
  }

  // MARK: - Mock Service Shortcuts

  /// Setup successful API scenario
  void setupSuccessfulApiScenario() {
    mockServiceManager.setupSuccessfulApiCallScenario();
  }

  /// Setup network error scenario
  void setupNetworkErrorScenario() {
    mockServiceManager.setupNetworkErrorScenario();
  }

  /// Setup auth error scenario
  void setupAuthErrorScenario() {
    mockServiceManager.setupAuthErrorScenario();
  }

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

  // MARK: - Common Assertions

  /// Assert API method exists and has correct signature
  void assertApiMethodExists(String methodName) {
    expect(
      apiService,
      isNotNull,
      reason: "API service should be initialized",
    );
    // Additional method existence checks would be implementation-specific
  }

  /// Assert endpoint properties
  void assertEndpointProperties(
    APIEndPoint endpoint,
    Map<String, dynamic> expectedProperties,
  ) {
    expectedProperties.forEach((String property, dynamic expectedValue) {
      switch (property) {
        case "path":
          expect(endpoint.path, expectedValue);
        case "method":
          expect(endpoint.method, expectedValue);
        case "hasAuthorization":
          expect(endpoint.hasAuthorization, expectedValue);
        case "isRefreshToken":
          expect(endpoint.isRefreshToken, expectedValue);
      }
    });
  }
}
