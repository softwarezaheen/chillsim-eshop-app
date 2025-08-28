import "dart:async";
import "dart:io";

import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/apis/http_client_wrapper.dart";
import "package:flutter_test/flutter_test.dart";
import "package:http/http.dart" as http;
import "package:mockito/mockito.dart";

import "http_response_test_mixin.dart";
import "test_constants.dart";
import "test_data_factory.dart";
import "test_environment_setup.dart";

// Mock classes for HTTP client testing
class MockTokenRefresher extends Mock {
  FutureOr<void> call();
}

class MockRequestInterceptor extends Mock {
  FutureOr<http.BaseRequest> call(
    http.BaseRequest request,
    APIEndPoint endPoint,
  );
}

class MockResponseInterceptor extends Mock {
  FutureOr<http.BaseResponse> call(
    http.BaseResponse response,
    APIEndPoint endPoint,
  );
}

/// Abstract base class for HTTP client tests.
/// Provides common setup, teardown, and test patterns for HTTP client testing.
abstract class HttpClientHelper with HttpResponseTestMixin {
  // Test instances
  late MockTokenRefresher mockTokenRefresher;
  late MockRequestInterceptor mockRequestInterceptor;
  late MockResponseInterceptor mockResponseInterceptor;
  late APIEndPoint testEndpoint;

  // Test configuration
  String get httpClientName;

  /// Setup method to be called from each test file's setUp
  Future<void> baseHttpSetUp() async {
    // Initialize mocks
    mockTokenRefresher = MockTokenRefresher();
    mockRequestInterceptor = MockRequestInterceptor();
    mockResponseInterceptor = MockResponseInterceptor();

    // Create test endpoint
    testEndpoint = TestDataFactory.createTestEndpoint();

    // Initialize test environment
    await TestEnvironmentSetup.initializeTestEnvironment();

    // Perform any additional setup
    performAdditionalHttpSetup();
  }

  /// Teardown method to be called from each test file's tearDown
  void baseHttpTearDown() {
    // Clean up environment
    TestEnvironmentSetup.cleanupTestEnvironment();

    // Perform any additional cleanup
    performAdditionalHttpCleanup();
  }

  // Virtual methods that can be overridden
  void performAdditionalHttpSetup() {}
  void performAdditionalHttpCleanup() {}

  // MARK: - Factory Methods for HTTP Client Configurations

  /// Create minimal HTTP client wrapper
  HttpClientWrapper createMinimalWrapper({
    SecurityContext? securityContext,
    TokenRefresher? tokenRefresher,
  }) {
    return HttpClientWrapper(
      securityContext: securityContext,
      tokenRefresher: tokenRefresher ?? mockTokenRefresher.call,
    );
  }

  /// Create full-featured HTTP client wrapper
  HttpClientWrapper createFullWrapper({
    SecurityContext? securityContext,
    TokenRefresher? tokenRefresher,
    List<RequestInterceptor>? requestInterceptors,
    List<ResponseInterceptor>? responseInterceptors,
  }) {
    return HttpClientWrapper(
      securityContext: securityContext,
      tokenRefresher: tokenRefresher ?? mockTokenRefresher.call,
      requestInterceptors: requestInterceptors,
      responseInterceptors: responseInterceptors,
    );
  }

  /// Create wrapper with single interceptors
  HttpClientWrapper createWrapperWithInterceptors({
    SecurityContext? securityContext,
    TokenRefresher? tokenRefresher,
    RequestInterceptor? requestInterceptor,
    ResponseInterceptor? responseInterceptor,
  }) {
    return createFullWrapper(
      securityContext: securityContext,
      tokenRefresher: tokenRefresher,
      requestInterceptors: requestInterceptor != null
          ? <RequestInterceptor>[requestInterceptor]
          : null,
      responseInterceptors: responseInterceptor != null
          ? <ResponseInterceptor>[responseInterceptor]
          : null,
    );
  }

  /// Create wrapper with empty interceptor lists
  HttpClientWrapper createWrapperWithEmptyInterceptors({
    SecurityContext? securityContext,
    TokenRefresher? tokenRefresher,
  }) {
    return createFullWrapper(
      securityContext: securityContext,
      tokenRefresher: tokenRefresher,
      requestInterceptors: <RequestInterceptor>[],
      responseInterceptors: <ResponseInterceptor>[],
    );
  }

  // MARK: - Common Test Patterns

  /// Test HTTP client constructor variations
  void testConstructorVariation({
    required String testName,
    required HttpClientWrapper Function() wrapperFactory,
    Type? expectedClientType,
  }) {
    test(testName, () {
      // Act
      final HttpClientWrapper wrapper = wrapperFactory();

      // Assert
      expect(
        wrapper,
        isNotNull,
        reason: "$testName - wrapper should not be null",
      );
      expect(
        wrapper,
        isA<http.BaseClient>(),
        reason: "$testName - should extend BaseClient",
      );

      if (expectedClientType != null) {
        expect(
          wrapper,
          isA<HttpClientWrapper>(),
          reason: "$testName - should be HttpClientWrapper",
        );
      }
    });
  }

  /// Test method execution behavior
  void testMethodExecution({
    required String testName,
    required Function() method,
    dynamic expectedResult,
    Type? expectedException,
  }) {
    test(testName, () {
      if (expectedException != null) {
        // Test exception throwing
        expect(
          () => method(),
          throwsA(
            isA<dynamic>().having(
              (dynamic e) => e.runtimeType,
              "exception type",
              expectedException,
            ),
          ),
          reason: "$testName - should throw expected exception",
        );
      } else if (expectedResult != null) {
        // Test return value
        dynamic result = method();
        expect(
          result,
          equals(expectedResult),
          reason: "$testName - should return expected result",
        );
      } else {
        // Test normal execution
        expect(
          () => method(),
          returnsNormally,
          reason: "$testName - should execute without errors",
        );
      }
    });
  }

  /// Test async method execution behavior
  void testAsyncMethodExecution({
    required String testName,
    required Future<dynamic> Function() method,
    dynamic expectedResult,
    Type? expectedException,
  }) {
    test(testName, () async {
      if (expectedException != null) {
        // Test exception throwing
        await expectLater(
          () => method(),
          throwsA(
            isA<dynamic>().having(
              (dynamic e) => e.runtimeType,
              "exception type",
              expectedException,
            ),
          ),
          reason: "$testName - should throw expected exception",
        );
      } else if (expectedResult != null) {
        // Test return value
        dynamic result = await method();
        expect(
          result,
          equals(expectedResult),
          reason: "$testName - should return expected result",
        );
      } else {
        // Test normal execution
        await expectLater(
          () => method(),
          returnsNormally,
          reason: "$testName - should execute without errors",
        );
      }
    });
  }

  /// Test interceptor behavior
  void testInterceptorBehavior<T>({
    required String testName,
    required T Function(T input, APIEndPoint endpoint) interceptor,
    required T testInput,
    required T expectedOutput,
    APIEndPoint? endpoint,
  }) {
    test(testName, () {
      // Act
      dynamic result = interceptor(testInput, endpoint ?? testEndpoint);

      // Assert
      expect(
        result,
        equals(expectedOutput),
        reason: "$testName - should return expected output",
      );
    });
  }

  /// Test async interceptor behavior
  void testAsyncInterceptorBehavior<T>({
    required String testName,
    required Future<T> Function(T input, APIEndPoint endpoint) interceptor,
    required T testInput,
    required T expectedOutput,
    APIEndPoint? endpoint,
  }) {
    test(testName, () async {
      // Act
      dynamic result = await interceptor(testInput, endpoint ?? testEndpoint);

      // Assert
      expect(
        result,
        equals(expectedOutput),
        reason: "$testName - should return expected output",
      );
    });
  }

  /// Test FutureOr type handling
  void testFutureOrHandling<T>({
    required String testName,
    required FutureOr<T> Function() syncFunction,
    required FutureOr<T> Function() asyncFunction,
    required T expectedSyncResult,
    required T expectedAsyncResult,
  }) {
    test(testName, () async {
      // Test sync function
      final FutureOr<T> syncResult = syncFunction();
      if (syncResult is Future<T>) {
        fail("$testName - sync function should not return Future");
      } else {
        expect(
          syncResult,
          equals(expectedSyncResult),
          reason: "$testName - sync function should return expected result",
        );
      }

      // Test async function
      final FutureOr<T> asyncResult = asyncFunction();
      if (asyncResult is Future<T>) {
        dynamic awaitedResult = await asyncResult;
        expect(
          awaitedResult,
          equals(expectedAsyncResult),
          reason: "$testName - async function should return expected result",
        );
      } else {
        fail("$testName - async function should return Future");
      }
    });
  }

  // MARK: - HTTP Request/Response Testing Patterns

  /// Test HTTP request properties
  void testHttpRequestProperties({
    required String testName,
    required http.BaseRequest request,
    required Map<String, dynamic> expectedProperties,
  }) {
    test(testName, () {
      expectedProperties.forEach((String property, dynamic expectedValue) {
        switch (property) {
          case "method":
            expect(
              request.method,
              equals(expectedValue),
              reason: "$testName - should have expected method",
            );
          case "url":
            expect(
              request.url.toString(),
              equals(expectedValue),
              reason: "$testName - should have expected URL",
            );
          case "headers":
            if (expectedValue is Map<String, String>) {
              expectedValue.forEach((String key, String value) {
                expect(
                  request.headers[key],
                  contains(value),
                  reason: "$testName - should have expected header $key",
                );
              });
            }
          case "persistentConnection":
            expect(
              request.persistentConnection,
              equals(expectedValue),
              reason: "$testName - should have expected persistent connection",
            );
          case "followRedirects":
            expect(
              request.followRedirects,
              equals(expectedValue),
              reason: "$testName - should have expected follow redirects",
            );
          case "maxRedirects":
            expect(
              request.maxRedirects,
              equals(expectedValue),
              reason: "$testName - should have expected max redirects",
            );
        }
      });
    });
  }

  /// Test HTTP response properties
  void testHttpResponseProperties({
    required String testName,
    required http.BaseResponse response,
    required Map<String, dynamic> expectedProperties,
  }) {
    test(testName, () {
      expectedProperties.forEach((String property, dynamic expectedValue) {
        switch (property) {
          case "statusCode":
            expect(
              response.statusCode,
              equals(expectedValue),
              reason: "$testName - should have expected status code",
            );
          case "headers":
            if (expectedValue is Map<String, String>) {
              expectedValue.forEach((String key, String value) {
                expect(
                  response.headers[key],
                  contains(value),
                  reason: "$testName - should have expected header $key",
                );
              });
            }
        }
      });
    });
  }

  // MARK: - Mock Helper Methods

  /// Setup token refresher mock
  void setupTokenRefresherMock({
    bool shouldThrow = false,
    Exception? exception,
  }) {
    if (shouldThrow) {
      when(mockTokenRefresher.call())
          .thenThrow(exception ?? Exception("Token refresh failed"));
    } else {
      when(mockTokenRefresher.call()).thenAnswer((_) async {});
    }
  }

  /// Setup request interceptor mock
  void setupRequestInterceptorMock({
    http.BaseRequest? returnRequest,
    bool shouldThrow = false,
    Exception? exception,
  }) {
    if (shouldThrow) {
      when(
        mockRequestInterceptor.call(
          anything as http.BaseRequest,
          anything as APIEndPoint,
        ),
      ).thenThrow(exception ?? Exception("Request interceptor failed"));
    } else {
      when(
        mockRequestInterceptor.call(
          anything as http.BaseRequest,
          anything as APIEndPoint,
        ),
      ).thenAnswer(
        (Invocation invocation) async =>
            returnRequest ?? invocation.positionalArguments[0],
      );
    }
  }

  /// Setup response interceptor mock
  void setupResponseInterceptorMock({
    http.BaseResponse? returnResponse,
    bool shouldThrow = false,
    Exception? exception,
  }) {
    if (shouldThrow) {
      when(
        mockResponseInterceptor.call(
          dynamic as http.BaseResponse,
          dynamic as APIEndPoint,
        ),
      ).thenThrow(exception ?? Exception("Response interceptor failed"));
    } else {
      when(
        mockResponseInterceptor.call(
          dynamic as http.BaseResponse,
          dynamic as APIEndPoint,
        ),
      ).thenAnswer(
        (Invocation invocation) async =>
            returnResponse ?? invocation.positionalArguments[0],
      );
    }
  }

  // MARK: - Test Request/Response Factories

  /// Create test HTTP request
  http.Request createTestRequest({
    String? method,
    String? url,
    Map<String, String>? headers,
    String? body,
  }) {
    final http.Request request = http.Request(
      method ?? TestConstants.httpGetMethod,
      Uri.parse(url ?? TestConstants.testFullUrl),
    );

    if (headers != null) {
      request.headers.addAll(headers);
    }

    if (body != null) {
      request.body = body;
    }

    return request;
  }

  /// Create test HTTP multipart request
  http.MultipartRequest createTestMultipartRequest({
    String? method,
    String? url,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) {
    final http.MultipartRequest request = http.MultipartRequest(
      method ?? TestConstants.httpPostMethod,
      Uri.parse(url ?? TestConstants.testFullUrl),
    );

    if (fields != null) {
      request.fields.addAll(fields);
    }

    if (headers != null) {
      request.headers.addAll(headers);
    }

    return request;
  }

  /// Create test HTTP response
  http.Response createTestResponse({
    String? body,
    int? statusCode,
    Map<String, String>? headers,
  }) {
    return http.Response(
      body ?? "Test response body",
      statusCode ?? TestConstants.httpOk,
      headers: headers ?? <String, String>{},
    );
  }

  /// Create test streamed response
  http.StreamedResponse createTestStreamedResponse({
    int? statusCode,
    Map<String, String>? headers,
    List<List<int>>? streamData,
  }) {
    return http.StreamedResponse(
      Stream<List<int>>.fromIterable(
        streamData ??
            <List<int>>[
              <int>[1, 2, 3],
            ],
      ),
      statusCode ?? TestConstants.httpOk,
      headers: headers ?? <String, String>{},
    );
  }

  // MARK: - Environment Testing Helpers

  /// Test with App Clip environment
  void testWithAppClipEnvironment({
    required String testName,
    required void Function() testFunction,
  }) {
    test(testName, () async {
      await TestEnvironmentSetup.runWithAppClipEnvironment(() async {
        testFunction();
      });
    });
  }

  /// Test with standard app environment
  void testWithStandardAppEnvironment({
    required String testName,
    required void Function() testFunction,
  }) {
    test(testName, () async {
      await TestEnvironmentSetup.runWithStandardAppEnvironment(() async {
        testFunction();
      });
    });
  }

  // MARK: - Common Test Groups

  /// Create constructor test group
  void createConstructorTestGroup({
    required String className,
    required Map<String, HttpClientWrapper Function()> constructorVariations,
  }) {
    group("$className constructor", () {
      constructorVariations.forEach((String testName, dynamic wrapperFactory) {
        testConstructorVariation(
          testName: testName,
          wrapperFactory: wrapperFactory,
        );
      });
    });
  }

  /// Create interceptor test group
  void createInterceptorTestGroup({
    required String interceptorType,
    required Map<String, Function> interceptorTests,
  }) {
    group("$interceptorType interceptor", () {
      interceptorTests.forEach((String testName, Function testFunction) {
        testFunction();
      });
    });
  }

  /// Create method test group
  void createMethodTestGroup({
    required String methodName,
    required Map<String, Function> methodTests,
  }) {
    group("$methodName method", () {
      methodTests.forEach((String testName, Function testFunction) {
        testFunction();
      });
    });
  }

  // MARK: - Verification Helpers

  /// Verify token refresher was called
  void verifyTokenRefresherCalled([int times = 1]) {
    verify(mockTokenRefresher.call()).called(times);
  }

  /// Verify request interceptor was called
  void verifyRequestInterceptorCalled([int times = 1]) {
    verify(
      mockRequestInterceptor.call(
        dynamic as http.BaseRequest,
        dynamic as APIEndPoint,
      ),
    ).called(times);
  }

  /// Verify response interceptor was called
  void verifyResponseInterceptorCalled([int times = 1]) {
    verify(
      mockResponseInterceptor.call(
        dynamic as http.BaseResponse,
        dynamic as APIEndPoint,
      ),
    ).called(times);
  }

  /// Verify mock was never called
  void verifyMockNeverCalled(dynamic mock) {
    verifyNever(mock);
  }
}
