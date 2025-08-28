// api_app_repository_impl_test.dart

import "dart:async";

import "package:esim_open_source/data/remote/responses/app/configuration_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/currencies_response_model.dart";
import "package:esim_open_source/data/remote/responses/app/dynamic_page_response.dart";
import "package:esim_open_source/data/remote/responses/app/faq_response.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/core/string_response.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/data/repository/api_app_repository_impl.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../locator_test.mocks.dart";

void main() {
  late ApiAppRepository repository;
  late MockAPIApp mockApiApp;

  setUp(() {
    mockApiApp = MockAPIApp();
    repository = ApiAppRepositoryImpl(mockApiApp);
  });

  group("ApiAppRepositoryImpl", () {
    group("addDevice", () {
      const String testFcmToken = "test-fcm-token-123";
      const String testManufacturer = "Apple";
      const String testDeviceModel = "iPhone 15";
      const String testDeviceOs = "iOS";
      const String testDeviceOsVersion = "17.0";
      const String testAppVersion = "1.0.0";
      const String testRamSize = "6GB";
      const String testScreenResolution = "1179x2556";
      const bool testIsRooted = false;

      test("should return success resource when device is added successfully",
          () async {
        // Arrange
        final EmptyResponse expectedResponse = EmptyResponse();
        final ResponseMain<EmptyResponse> responseMain =
            ResponseMain<EmptyResponse>.createErrorWithData(
          data: expectedResponse,
          message: "Device added successfully",
          statusCode: 200,
        );

        when(
          mockApiApp.addDevice(
            fcmToken: testFcmToken,
            manufacturer: testManufacturer,
            deviceModel: testDeviceModel,
            deviceOs: testDeviceOs,
            deviceOsVersion: testDeviceOsVersion,
            appVersion: testAppVersion,
            ramSize: testRamSize,
            screenResolution: testScreenResolution,
            isRooted: testIsRooted,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.addDevice(
          fcmToken: testFcmToken,
          manufacturer: testManufacturer,
          deviceModel: testDeviceModel,
          deviceOs: testDeviceOs,
          deviceOsVersion: testDeviceOsVersion,
          appVersion: testAppVersion,
          ramSize: testRamSize,
          screenResolution: testScreenResolution,
          isRooted: testIsRooted,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);
        expect(result.message, "Device added successfully");
        expect(result.error, isNull);

        verify(
          mockApiApp.addDevice(
            fcmToken: testFcmToken,
            manufacturer: testManufacturer,
            deviceModel: testDeviceModel,
            deviceOs: testDeviceOs,
            deviceOsVersion: testDeviceOsVersion,
            appVersion: testAppVersion,
            ramSize: testRamSize,
            screenResolution: testScreenResolution,
            isRooted: testIsRooted,
          ),
        ).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMain<EmptyResponse> responseMain =
            ResponseMain<EmptyResponse>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid device information",
        );

        when(
          mockApiApp.addDevice(
            fcmToken: testFcmToken,
            manufacturer: testManufacturer,
            deviceModel: testDeviceModel,
            deviceOs: testDeviceOs,
            deviceOsVersion: testDeviceOsVersion,
            appVersion: testAppVersion,
            ramSize: testRamSize,
            screenResolution: testScreenResolution,
            isRooted: testIsRooted,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.addDevice(
          fcmToken: testFcmToken,
          manufacturer: testManufacturer,
          deviceModel: testDeviceModel,
          deviceOs: testDeviceOs,
          deviceOsVersion: testDeviceOsVersion,
          appVersion: testAppVersion,
          ramSize: testRamSize,
          screenResolution: testScreenResolution,
          isRooted: testIsRooted,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid device information");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiApp.addDevice(
            fcmToken: testFcmToken,
            manufacturer: testManufacturer,
            deviceModel: testDeviceModel,
            deviceOs: testDeviceOs,
            deviceOsVersion: testDeviceOsVersion,
            appVersion: testAppVersion,
            ramSize: testRamSize,
            screenResolution: testScreenResolution,
            isRooted: testIsRooted,
          ),
        ).called(1);
      });

      test("should pass all parameters correctly to API app", () async {
        // Arrange
        const String customFcmToken = "custom-token";
        const String customManufacturer = "Samsung";
        const String customDeviceModel = "Galaxy S24";
        const String customDeviceOs = "Android";
        const String customDeviceOsVersion = "14.0";
        const String customAppVersion = "2.0.0";
        const String customRamSize = "8GB";
        const String customScreenResolution = "1440x3200";
        const bool customIsRooted = true;

        final EmptyResponse expectedResponse = EmptyResponse();
        final ResponseMain<EmptyResponse> responseMain =
            ResponseMain<EmptyResponse>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiApp.addDevice(
            fcmToken: customFcmToken,
            manufacturer: customManufacturer,
            deviceModel: customDeviceModel,
            deviceOs: customDeviceOs,
            deviceOsVersion: customDeviceOsVersion,
            appVersion: customAppVersion,
            ramSize: customRamSize,
            screenResolution: customScreenResolution,
            isRooted: customIsRooted,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        await repository.addDevice(
          fcmToken: customFcmToken,
          manufacturer: customManufacturer,
          deviceModel: customDeviceModel,
          deviceOs: customDeviceOs,
          deviceOsVersion: customDeviceOsVersion,
          appVersion: customAppVersion,
          ramSize: customRamSize,
          screenResolution: customScreenResolution,
          isRooted: customIsRooted,
        );

        // Assert
        verify(
          mockApiApp.addDevice(
            fcmToken: customFcmToken,
            manufacturer: customManufacturer,
            deviceModel: customDeviceModel,
            deviceOs: customDeviceOs,
            deviceOsVersion: customDeviceOsVersion,
            appVersion: customAppVersion,
            ramSize: customRamSize,
            screenResolution: customScreenResolution,
            isRooted: customIsRooted,
          ),
        ).called(1);
      });
    });

    group("getFaq", () {
      test(
          "should return success resource with FAQ list when API call succeeds",
          () async {
        // Arrange
        final List<FaqResponse> expectedFaqs = <FaqResponse>[
          FaqResponse(
            question: "How to activate eSIM?",
            answer: "Follow the steps...",
          ),
          FaqResponse(
            question: "What devices are supported?",
            answer: "iPhone XS and above...",
          ),
        ];
        final ResponseMain<List<FaqResponse>> responseMain =
            ResponseMain<List<FaqResponse>>.createErrorWithData(
          data: expectedFaqs,
          message: "FAQs retrieved successfully",
          statusCode: 200,
        );

        when(mockApiApp.getFaq()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<FaqResponse>?> result =
            await repository.getFaq() as Resource<List<FaqResponse>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedFaqs);
        expect(result.data?.length, 2);
        expect(result.data?[0].question, "How to activate eSIM?");
        expect(result.message, "FAQs retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiApp.getFaq()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMain<List<FaqResponse>> responseMain =
            ResponseMain<List<FaqResponse>>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Failed to retrieve FAQs",
        );

        when(mockApiApp.getFaq()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<FaqResponse>?> result =
            await repository.getFaq() as Resource<List<FaqResponse>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Failed to retrieve FAQs");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getFaq()).called(1);
      });

      test("should handle empty FAQ list gracefully", () async {
        // Arrange
        final List<FaqResponse> expectedFaqs = <FaqResponse>[];
        final ResponseMain<List<FaqResponse>> responseMain =
            ResponseMain<List<FaqResponse>>.createErrorWithData(
          data: expectedFaqs,
          message: "No FAQs available",
          statusCode: 200,
        );

        when(mockApiApp.getFaq()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<FaqResponse>?> result =
            await repository.getFaq() as Resource<List<FaqResponse>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isEmpty);
        expect(result.message, "No FAQs available");

        verify(mockApiApp.getFaq()).called(1);
      });
    });

    group("contactUs", () {
      const String testEmail = "john.doe@example.com";
      const String testMessage = "I need help with my eSIM activation";

      test("should return success resource when contact message is sent",
          () async {
        // Arrange
        final StringResponse expectedResponse =
            StringResponse.fromJson(json: true);
        final ResponseMain<StringResponse> responseMain =
            ResponseMain<StringResponse>.createErrorWithData(
          data: expectedResponse,
          message: "Contact message sent",
          statusCode: 200,
        );

        when(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<StringResponse?> result = await repository.contactUs(
          email: testEmail,
          message: testMessage,
        ) as Resource<StringResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);
        expect(result.message, "Contact message sent");
        expect(result.error, isNull);

        verify(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMain<StringResponse> responseMain =
            ResponseMain<StringResponse>.createErrorWithData(
          statusCode: 422,
          developerMessage: "Invalid email format",
        );

        when(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<StringResponse?> result = await repository.contactUs(
          email: testEmail,
          message: testMessage,
        ) as Resource<StringResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid email format");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiApp.contactUs(
            email: testEmail,
            message: testMessage,
          ),
        ).called(1);
      });

      test("should pass all contact parameters correctly to API app", () async {
        // Arrange
        const String customEmail = "jane@test.com";
        const String customMessage = "Custom inquiry message";

        final StringResponse expectedResponse =
            StringResponse.fromJson(json: true);
        final ResponseMain<StringResponse> responseMain =
            ResponseMain<StringResponse>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiApp.contactUs(
            email: customEmail,
            message: customMessage,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        await repository.contactUs(
          email: customEmail,
          message: customMessage,
        );

        // Assert
        verify(
          mockApiApp.contactUs(
            email: customEmail,
            message: customMessage,
          ),
        ).called(1);
      });
    });

    group("getAboutUs", () {
      test("should return success resource with about us content", () async {
        // Arrange
        final DynamicPageResponse expectedResponse = DynamicPageResponse(
          pageTitle: "About Us",
          pageContent: "We are a leading eSIM provider...",
          pageIntro: "Learn more about our company",
        );
        final ResponseMain<DynamicPageResponse> responseMain =
            ResponseMain<DynamicPageResponse>.createErrorWithData(
          data: expectedResponse,
          message: "About Us content retrieved",
          statusCode: 200,
        );

        when(mockApiApp.getAboutUs()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result =
            await repository.getAboutUs() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);
        expect(result.data?.pageTitle, "About Us");
        expect(result.data?.pageContent, "We are a leading eSIM provider...");
        expect(result.message, "About Us content retrieved");
        expect(result.error, isNull);

        verify(mockApiApp.getAboutUs()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMain<DynamicPageResponse> responseMain =
            ResponseMain<DynamicPageResponse>.createErrorWithData(
          statusCode: 404,
          developerMessage: "About Us content not found",
        );

        when(mockApiApp.getAboutUs()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result =
            await repository.getAboutUs() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "About Us content not found");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getAboutUs()).called(1);
      });
    });

    group("getTermsConditions", () {
      test("should return success resource with terms and conditions content",
          () async {
        // Arrange
        final DynamicPageResponse expectedResponse = DynamicPageResponse(
          pageTitle: "Terms & Conditions",
          pageContent: "These terms and conditions govern...",
          pageIntro: "Please read carefully",
        );
        final ResponseMain<DynamicPageResponse> responseMain =
            ResponseMain<DynamicPageResponse>.createErrorWithData(
          data: expectedResponse,
          message: "Terms & Conditions retrieved",
          statusCode: 200,
        );

        when(mockApiApp.getTermsConditions())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result = await repository
            .getTermsConditions() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);
        expect(result.data?.pageTitle, "Terms & Conditions");
        expect(
          result.data?.pageContent,
          "These terms and conditions govern...",
        );
        expect(result.message, "Terms & Conditions retrieved");
        expect(result.error, isNull);

        verify(mockApiApp.getTermsConditions()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMain<DynamicPageResponse> responseMain =
            ResponseMain<DynamicPageResponse>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Failed to load terms and conditions",
        );

        when(mockApiApp.getTermsConditions())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<DynamicPageResponse?> result = await repository
            .getTermsConditions() as Resource<DynamicPageResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Failed to load terms and conditions");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getTermsConditions()).called(1);
      });
    });

    group("getConfigurations", () {
      test("should return success resource with configurations list", () async {
        // Arrange
        final List<ConfigurationResponseModel> expectedConfigs =
            <ConfigurationResponseModel>[
          ConfigurationResponseModel(key: "api_timeout", value: "30"),
          ConfigurationResponseModel(key: "max_retries", value: "3"),
          ConfigurationResponseModel(key: "enable_logging", value: "true"),
        ];
        final ResponseMain<List<ConfigurationResponseModel>> responseMain =
            ResponseMain<List<ConfigurationResponseModel>>.createErrorWithData(
          data: expectedConfigs,
          message: "Configurations retrieved successfully",
          statusCode: 200,
        );

        when(mockApiApp.getConfigurations())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<ConfigurationResponseModel>?> result =
            await repository.getConfigurations()
                as Resource<List<ConfigurationResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedConfigs);
        expect(result.data?.length, 3);
        expect(result.data?[0].key, "api_timeout");
        expect(result.data?[0].value, "30");
        expect(result.message, "Configurations retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiApp.getConfigurations()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMain<List<ConfigurationResponseModel>> responseMain =
            ResponseMain<List<ConfigurationResponseModel>>.createErrorWithData(
          statusCode: 403,
          developerMessage: "Access denied to configurations",
        );

        when(mockApiApp.getConfigurations())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<ConfigurationResponseModel>?> result =
            await repository.getConfigurations()
                as Resource<List<ConfigurationResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Access denied to configurations");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getConfigurations()).called(1);
      });

      test("should handle empty configurations list gracefully", () async {
        // Arrange
        final List<ConfigurationResponseModel> expectedConfigs =
            <ConfigurationResponseModel>[];
        final ResponseMain<List<ConfigurationResponseModel>> responseMain =
            ResponseMain<List<ConfigurationResponseModel>>.createErrorWithData(
          data: expectedConfigs,
          message: "No configurations available",
          statusCode: 200,
        );

        when(mockApiApp.getConfigurations())
            .thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<ConfigurationResponseModel>?> result =
            await repository.getConfigurations()
                as Resource<List<ConfigurationResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, isEmpty);
        expect(result.message, "No configurations available");

        verify(mockApiApp.getConfigurations()).called(1);
      });
    });

    group("getCurrencies", () {
      test("should return success resource with currencies list", () async {
        // Arrange
        final List<CurrenciesResponseModel> expectedCurrencies =
            <CurrenciesResponseModel>[
          CurrenciesResponseModel(currency: "USD"),
          CurrenciesResponseModel(currency: "EUR"),
          CurrenciesResponseModel(currency: "GBP"),
        ];
        final ResponseMain<List<CurrenciesResponseModel>> responseMain =
            ResponseMain<List<CurrenciesResponseModel>>.createErrorWithData(
          data: expectedCurrencies,
          message: "Currencies retrieved successfully",
          statusCode: 200,
        );

        when(mockApiApp.getCurrencies()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<CurrenciesResponseModel>?> result = await repository
            .getCurrencies() as Resource<List<CurrenciesResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedCurrencies);
        expect(result.data?.length, 3);
        expect(result.data?[0].currency, "USD");
        expect(result.message, "Currencies retrieved successfully");
        expect(result.error, isNull);

        verify(mockApiApp.getCurrencies()).called(1);
      });

      test("should return error resource when API returns error", () async {
        // Arrange
        final ResponseMain<List<CurrenciesResponseModel>> responseMain =
            ResponseMain<List<CurrenciesResponseModel>>.createErrorWithData(
          statusCode: 502,
          developerMessage: "Currency service unavailable",
        );

        when(mockApiApp.getCurrencies()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<CurrenciesResponseModel>?> result = await repository
            .getCurrencies() as Resource<List<CurrenciesResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Currency service unavailable");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(mockApiApp.getCurrencies()).called(1);
      });

      test("should handle single currency in list", () async {
        // Arrange
        final List<CurrenciesResponseModel> expectedCurrencies =
            <CurrenciesResponseModel>[
          CurrenciesResponseModel(currency: "USD"),
        ];
        final ResponseMain<List<CurrenciesResponseModel>> responseMain =
            ResponseMain<List<CurrenciesResponseModel>>.createErrorWithData(
          data: expectedCurrencies,
          message: "Single currency available",
          statusCode: 200,
        );

        when(mockApiApp.getCurrencies()).thenAnswer((_) async => responseMain);

        // Act
        final Resource<List<CurrenciesResponseModel>?> result = await repository
            .getCurrencies() as Resource<List<CurrenciesResponseModel>?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data?.length, 1);
        expect(result.data?[0].currency, "USD");
        expect(result.message, "Single currency available");

        verify(mockApiApp.getCurrencies()).called(1);
      });
    });

    group("Edge cases and boundary conditions", () {
      test("should handle null response data gracefully", () async {
        // Arrange
        final ResponseMain<EmptyResponse> responseMain =
            ResponseMain<EmptyResponse>.createErrorWithData(
          message: "Success but no data",
          statusCode: 200,
        );

        when(
          mockApiApp.addDevice(
            fcmToken: "test-token",
            manufacturer: "Apple",
            deviceModel: "iPhone",
            deviceOs: "iOS",
            deviceOsVersion: "17.0",
            appVersion: "1.0.0",
            ramSize: "6GB",
            screenResolution: "1179x2556",
            isRooted: false,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.addDevice(
          fcmToken: "test-token",
          manufacturer: "Apple",
          deviceModel: "iPhone",
          deviceOs: "iOS",
          deviceOsVersion: "17.0",
          appVersion: "1.0.0",
          ramSize: "6GB",
          screenResolution: "1179x2556",
          isRooted: false,
        ) as Resource<EmptyResponse?>;

        // Assert - responseToResource will call response.dataOfType which might cause issues with null
        expect(result.resourceType, ResourceType.error);
        expect(result.data, isNull);
      });

      test("should handle empty string parameters for addDevice", () async {
        // Arrange
        const String emptyString = "";
        final EmptyResponse expectedResponse = EmptyResponse();
        final ResponseMain<EmptyResponse> responseMain =
            ResponseMain<EmptyResponse>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiApp.addDevice(
            fcmToken: emptyString,
            manufacturer: emptyString,
            deviceModel: emptyString,
            deviceOs: emptyString,
            deviceOsVersion: emptyString,
            appVersion: emptyString,
            ramSize: emptyString,
            screenResolution: emptyString,
            isRooted: false,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<EmptyResponse?> result = await repository.addDevice(
          fcmToken: emptyString,
          manufacturer: emptyString,
          deviceModel: emptyString,
          deviceOs: emptyString,
          deviceOsVersion: emptyString,
          appVersion: emptyString,
          ramSize: emptyString,
          screenResolution: emptyString,
          isRooted: false,
        ) as Resource<EmptyResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);

        verify(
          mockApiApp.addDevice(
            fcmToken: emptyString,
            manufacturer: emptyString,
            deviceModel: emptyString,
            deviceOs: emptyString,
            deviceOsVersion: emptyString,
            appVersion: emptyString,
            ramSize: emptyString,
            screenResolution: emptyString,
            isRooted: false,
          ),
        ).called(1);
      });

      test("should handle empty string parameters for contactUs", () async {
        // Arrange
        const String emptyString = "";
        final StringResponse expectedResponse =
            StringResponse.fromJson(json: true);
        final ResponseMain<StringResponse> responseMain =
            ResponseMain<StringResponse>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiApp.contactUs(
            email: emptyString,
            message: emptyString,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<StringResponse?> result = await repository.contactUs(
          email: emptyString,
          message: emptyString,
        ) as Resource<StringResponse?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);

        verify(
          mockApiApp.contactUs(
            email: emptyString,
            message: emptyString,
          ),
        ).called(1);
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiAppRepository interface", () {
        expect(repository, isA<ApiAppRepository>());
      });

      test("should return correct types as specified in interface", () async {
        // Arrange
        final ResponseMain<EmptyResponse> responseMain =
            ResponseMain<EmptyResponse>.createErrorWithData(
          data: EmptyResponse(),
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiApp.addDevice(
            fcmToken: "test-token",
            manufacturer: "Apple",
            deviceModel: "iPhone",
            deviceOs: "iOS",
            deviceOsVersion: "17.0",
            appVersion: "1.0.0",
            ramSize: "6GB",
            screenResolution: "1179x2556",
            isRooted: false,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final FutureOr<dynamic> result = repository.addDevice(
          fcmToken: "test-token",
          manufacturer: "Apple",
          deviceModel: "iPhone",
          deviceOs: "iOS",
          deviceOsVersion: "17.0",
          appVersion: "1.0.0",
          ramSize: "6GB",
          screenResolution: "1179x2556",
          isRooted: false,
        );

        // Assert
        expect(result, isA<FutureOr<dynamic>>());
        expect(result, isA<Future<Resource<EmptyResponse?>>>());
      });
    });
  });
}
