/// Centralized constants used across all test files.
/// This prevents magic numbers/strings and provides consistency.
class TestConstants {
  // Private constructor to prevent instantiation
  TestConstants._();

  // MARK: - Test Identifiers
  static const String testDeviceId = "test_device_123";
  static const String testUserId = "test_user_456";
  static const String testDeviceName = "Test Device";
  static const String testUserName = "Test User";
  static const String testEmail = "test@example.com";

  // MARK: - Authentication Tokens
  static const String testAccessToken = "test_access_token_12345";
  static const String testRefreshToken = "test_refresh_token_67890";
  static const String expiredAccessToken = "expired_access_token";
  static const String invalidToken = "invalid_token";

  // MARK: - HTTP Status Codes
  static const int httpOk = 200;
  static const int httpCreated = 201;
  static const int httpAccepted = 202;
  static const int httpBadRequest = 400;
  static const int httpUnauthorized = 401;
  static const int httpForbidden = 403;
  static const int httpNotFound = 404;
  static const int httpMethodNotAllowed = 405;
  static const int httpConflict = 409;
  static const int httpInternalServerError = 500;
  static const int httpBadGateway = 502;
  static const int httpServiceUnavailable = 503;

  // MARK: - API Paths
  static const String testApiPath = "/test";
  static const String testApiPathWithParams = "/test/{id}";
  static const String authApiPath = "/auth/test";
  static const String refreshTokenPath = "/auth/refresh";
  static const String deviceApiPath = "/api/v1/device";
  static const String faqApiPath = "/api/v1/faq";
  static const String contactApiPath = "/api/v1/contact";

  // MARK: - Test URLs
  static const String testBaseUrl = "https://api.test.example.com";
  static const String testFullUrl = "$testBaseUrl$testApiPath";
  static const String localhostUrl = "http://localhost:3000";

  // MARK: - Localization
  static const String defaultLanguageCode = "en";
  static const String arabicLanguageCode = "ar";
  static const String spanishLanguageCode = "es";
  static const String defaultCurrencyCode = "USD";
  static const String euroCurrencyCode = "EUR";
  static const String gbpCurrencyCode = "GBP";

  // MARK: - Test Messages
  static const String testSuccessMessage = "Operation completed successfully";
  static const String testErrorMessage = "Test error occurred";
  static const String testNetworkErrorMessage = "No internet connection";
  static const String testAuthErrorMessage = "Authentication failed";
  static const String testValidationErrorMessage = "Validation failed";
  static const String testServerErrorMessage = "Internal server error";

  // MARK: - FAQ Test Data
  static const String testFaqQuestion = "What is this test about?";
  static const String testFaqAnswer = "This is a test FAQ answer";
  static const int testFaqId = 1;

  // MARK: - Device Test Data
  static const String testDeviceStatus = "active";
  static const String inactiveDeviceStatus = "inactive";
  static const String pendingDeviceStatus = "pending";

  // MARK: - Configuration Test Data
  static const String testConfigKey = "test_config_key";
  static const String testConfigValue = "test_config_value";
  static const String testConfigType = "string";

  // MARK: - Currency Test Data
  static const String usdCurrencyCode = "USD";
  static const String usdCurrencyName = "US Dollar";
  static const String usdCurrencySymbol = r"$";
  static const double usdCurrencyRate = 1;

  static const String eurCurrencyCode = "EUR";
  static const String eurCurrencyName = "Euro";
  static const String eurCurrencySymbol = "€";
  static const double eurCurrencyRate = 0.85;

  // MARK: - Contact Form Test Data
  static const String testContactName = "John Doe";
  static const String testContactEmail = "john.doe@example.com";
  static const String testContactMessage = "This is a test contact message";
  static const String testContactSubject = "Test Subject";

  // MARK: - HTTP Headers
  static const String authorizationHeader = "Authorization";
  static const String contentTypeHeader = "Content-Type";
  static const String acceptLanguageHeader = "accept-language";
  static const String deviceIdHeader = "x-device-id";
  static const String currencyHeader = "x-currency";
  static const String refreshTokenHeader = "x-refresh-token";

  // MARK: - Content Types
  static const String jsonContentType = "application/json";
  static const String formUrlEncodedContentType =
      "application/x-www-form-urlencoded";
  static const String multipartFormDataContentType = "multipart/form-data";

  // MARK: - Test Timeouts (in milliseconds)
  static const int defaultTestTimeout = 5000;
  static const int shortTestTimeout = 1000;
  static const int longTestTimeout = 10000;

  // MARK: - Test Environment Values
  static const String testEnvironment = "test";
  static const String developmentEnvironment = "development";
  static const String productionEnvironment = "production";

  // MARK: - Mock Delays (in milliseconds)
  static const int shortDelay = 10;
  static const int mediumDelay = 100;
  static const int longDelay = 500;

  // MARK: - Test Counts and Limits
  static const int defaultListCount = 3;
  static const int maxRetryCount = 3;
  static const int defaultPageSize = 20;

  // MARK: - Test Boolean Values
  static const bool defaultBoolTrue = true;
  static const bool defaultBoolFalse = false;

  // MARK: - Test Numeric Values
  static const int defaultTestInt = 123;
  static const double defaultTestDouble = 123.45;
  static const int zeroValue = 0;
  static const int negativeValue = -1;

  // MARK: - Test File Paths
  static const String testImagePath = "test/assets/test_image.png";
  static const String testDocumentPath = "test/assets/test_document.pdf";

  // MARK: - Error Code Mappings
  static const Map<String, int> errorCodes = <String, int>{
    "badRequest": httpBadRequest,
    "unauthorized": httpUnauthorized,
    "forbidden": httpForbidden,
    "notFound": httpNotFound,
    "serverError": httpInternalServerError,
  };

  // MARK: - Common Test Parameters
  static const Map<String, String> defaultTestParameters = <String, String>{
    "userId": testUserId,
    "deviceId": testDeviceId,
    "name": testUserName,
    "email": testEmail,
  };

  // MARK: - HTTP Method Names (for string comparisons)
  static const String httpGetMethod = "GET";
  static const String httpPostMethod = "POST";
  static const String httpPutMethod = "PUT";
  static const String httpDeleteMethod = "DELETE";
  static const String httpPatchMethod = "PATCH";

  // MARK: - Bearer Token Prefix
  static const String bearerTokenPrefix = "Bearer ";

  // MARK: - Query Parameter Keys
  static const String pageQueryParam = "page";
  static const String sizeQueryParam = "size";
  static const String searchQueryParam = "search";
  static const String filterQueryParam = "filter";

  // MARK: - Helper Methods for Dynamic Values

  /// Generate a test device ID with optional suffix
  static String generateTestDeviceId([String suffix = ""]) {
    return suffix.isEmpty ? testDeviceId : "${testDeviceId}_$suffix";
  }

  /// Generate a test user ID with optional suffix
  static String generateTestUserId([String suffix = ""]) {
    return suffix.isEmpty ? testUserId : "${testUserId}_$suffix";
  }

  /// Generate a bearer token string
  static String generateBearerToken(String token) {
    return "$bearerTokenPrefix$token";
  }

  /// Get default bearer token
  static String get defaultBearerToken => generateBearerToken(testAccessToken);

  /// Generate test email with optional prefix
  static String generateTestEmail([String prefix = "test"]) {
    return "$prefix@example.com";
  }

  /// Get current timestamp for unique test data
  static String get currentTimestamp =>
      DateTime.now().millisecondsSinceEpoch.toString();

  /// Generate unique test ID with timestamp
  static String generateUniqueTestId(String prefix) {
    return "${prefix}_$currentTimestamp";
  }
}
