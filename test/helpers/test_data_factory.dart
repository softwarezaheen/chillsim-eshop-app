import "package:esim_open_source/data/remote/api_end_point.dart";
import "package:esim_open_source/data/remote/http_methods.dart";
import "package:esim_open_source/data/remote/responses/app/configuration_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model.dart";
import "package:esim_open_source/domain/util/resource.dart";

/// Factory class for creating consistent test data across all test files.
/// This eliminates duplication and provides a single source of truth for test objects.
class TestDataFactory {
  // Private constructor to prevent instantiation
  TestDataFactory._();

  // MARK: - Device Response Data
  static DeviceInfoResponseModel createDeviceResponse({
    String? deviceId,
    String? status,
    String? name,
  }) {
    return DeviceInfoResponseModel();
  }

  static List<DeviceInfoResponseModel> createDeviceResponseList({
    int count = 2,
  }) {
    return List<DeviceInfoResponseModel>.generate(
      count,
      (int index) => createDeviceResponse(),
    );
  }

  // MARK: - FAQ Response Data
  static FaqResponse createFaqResponse({
    String? question,
    String? answer,
    int? id,
  }) {
    return FaqResponse(
      question: question ?? "Test Question?",
      answer: answer ?? "Test Answer",
    );
  }

  static List<FaqResponse> createFaqResponseList({
    int count = 3,
  }) {
    return List<FaqResponse>.generate(
      count,
      (int index) => createFaqResponse(
        id: index + 1,
        question: "Test Question ${index + 1}?",
        answer: "Test Answer ${index + 1}",
      ),
    );
  }

  // MARK: - Configuration Response Data
  static ConfigurationResponseModel createConfigurationResponse({
    String? key,
    String? value,
    String? type,
  }) {
    return ConfigurationResponseModel(
      key: key ?? "test_config_key",
      value: value ?? "test_config_value",
    );
  }

  static List<ConfigurationResponseModel> createConfigurationResponseList({
    int count = 2,
  }) {
    return List<ConfigurationResponseModel>.generate(
      count,
      (int index) => createConfigurationResponse(
        key: "config_key_${index + 1}",
        value: "config_value_${index + 1}",
      ),
    );
  }

  // MARK: - Currency Response Data
  static CurrenciesResponseModel createCurrencyResponse({
    String? code,
    String? name,
    String? symbol,
    double? rate,
  }) {
    return CurrenciesResponseModel(
      currency: code ?? "USD",
    );
  }

  static List<CurrenciesResponseModel> createCurrencyResponseList({
    int count = 3,
  }) {
    return List<CurrenciesResponseModel>.generate(count, (int index) {
      final List<Map<String, Object>> currencies = <Map<String, Object>>[
        <String, Object>{
          "code": "USD",
          "name": "US Dollar",
          "symbol": r"$",
          "rate": 1.0,
        },
        <String, Object>{
          "code": "EUR",
          "name": "Euro",
          "symbol": "€",
          "rate": 0.85,
        },
        <String, Object>{
          "code": "GBP",
          "name": "British Pound",
          "symbol": "£",
          "rate": 0.73,
        },
      ];
      final Map<String, Object> currency =
          currencies[index % currencies.length];
      return createCurrencyResponse(
        code: currency["code"]! as String,
        name: currency["name"]! as String,
        symbol: currency["symbol"]! as String,
        rate: currency["rate"]! as double,
      );
    });
  }

  // MARK: - API Endpoint Data
  static APIEndPoint createTestEndpoint({
    String? enumBaseURL,
    String? path,
    HttpMethod? method,
    bool? hasAuthorization,
    bool? isRefreshToken,
    Map<String, String>? headers,
    Map<String, dynamic>? parameters,
  }) {
    return APIEndPoint(
      enumBaseURL: enumBaseURL ?? "",
      path: path ?? "/test",
      method: method ?? HttpMethod.GET,
      hasAuthorization: hasAuthorization ?? false,
      isRefreshToken: isRefreshToken ?? false,
      headers: headers ?? <String, String>{},
      parameters: parameters ?? <String, dynamic>{},
    );
  }

  static APIEndPoint createAuthenticatedEndpoint({
    String? path,
    HttpMethod? method,
  }) {
    return createTestEndpoint(
      path: path ?? "/auth/test",
      method: method ?? HttpMethod.POST,
      hasAuthorization: true,
      isRefreshToken: false,
    );
  }

  static APIEndPoint createRefreshTokenEndpoint({
    String? path,
  }) {
    return createTestEndpoint(
      path: path ?? "/auth/refresh",
      method: HttpMethod.POST,
      hasAuthorization: false,
      isRefreshToken: true,
    );
  }

  // MARK: - ResponseMain Data
  static ResponseMain<T> createSuccessResponse<T>({
    T? data,
    int? responseCode,
    String? message,
  }) {
    return ResponseMain<T>.createErrorWithData(
      data: data,
      responseCode: responseCode ?? 200,
      message: message, // Don't set default message for success
      statusCode: 200,
    );
  }

  static ResponseMain<T> createErrorResponse<T>({
    int? responseCode,
    String? errorMessage,
    T? data,
  }) {
    return ResponseMain<T>.createError(
      responseCode: responseCode ?? 400,
      errorMessage: errorMessage ?? "Test Error",
    );
  }

  static ResponseMain<T> createErrorWithDataResponse<T>({
    required T data,
    int? responseCode,
    String? errorMessage,
  }) {
    return ResponseMain<T>.createErrorWithData(
      responseCode: responseCode ?? 400,
      message: errorMessage ?? "Test Error with Data",
      data: data,
    );
  }

  // MARK: - Resource Data
  static Resource<T> createSuccessResource<T>({
    required T data,
    String? message,
    int? code,
  }) {
    return Resource<T>.success(
      data,
      message: message ?? "Success",
    );
  }

  static Resource<T> createErrorResource<T>({
    String? message,
    int? code,
    T? data,
  }) {
    return Resource<T>.error(
      message ?? "Test Error",
      data: data,
    );
  }

  static Resource<T> createLoadingResource<T>({
    String? message,
    T? data,
  }) {
    return Resource<T>.loading(
      data: data,
    );
  }

  // MARK: - Batch Test Data Creation
  static Map<String, dynamic> createCompleteTestDataSet() {
    return <String, dynamic>{
      "device": createDeviceResponse(),
      "devices": createDeviceResponseList(),
      "faq": createFaqResponse(),
      "faqs": createFaqResponseList(),
      "configuration": createConfigurationResponse(),
      "configurations": createConfigurationResponseList(),
      "currency": createCurrencyResponse(),
      "currencies": createCurrencyResponseList(),
      "endpoint": createTestEndpoint(),
      "authEndpoint": createAuthenticatedEndpoint(),
      "refreshEndpoint": createRefreshTokenEndpoint(),
    };
  }

  // MARK: - Parameter Test Data
  static Map<String, String> createTestParameters({
    String? userId,
    String? deviceId,
    String? name,
    String? email,
    String? message,
  }) {
    return <String, String>{
      "userId": userId ?? "test_user_123",
      "deviceId": deviceId ?? "test_device_123",
      "name": name ?? "Test User",
      "email": email ?? "test@example.com",
      "message": message ?? "Test message content",
    };
  }

  // MARK: - Error Test Data
  static Map<String, dynamic> createErrorTestCases() {
    return <String, dynamic>{
      "badRequest": createErrorResponse<String>(
        responseCode: 400,
        errorMessage: "Bad Request",
      ),
      "unauthorized": createErrorResponse<String>(
        responseCode: 401,
        errorMessage: "Unauthorized",
      ),
      "forbidden": createErrorResponse<String>(
        responseCode: 403,
        errorMessage: "Forbidden",
      ),
      "notFound": createErrorResponse<String>(
        responseCode: 404,
        errorMessage: "Not Found",
      ),
      "serverError": createErrorResponse<String>(
        responseCode: 500,
        errorMessage: "Internal Server Error",
      ),
    };
  }
}
