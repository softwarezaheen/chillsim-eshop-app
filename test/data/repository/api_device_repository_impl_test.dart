// api_device_repository_impl_test.dart

import "dart:async";

import "package:esim_open_source/data/remote/request/device/device_info_request_model.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/device/device_info_response_model.dart";
import "package:esim_open_source/data/repository/api_device_repository_impl.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../locator_test.mocks.dart";

void main() {
  late ApiDeviceRepository repository;
  late MockAPIDevice mockApiDevice;

  setUp(() {
    mockApiDevice = MockAPIDevice();
    repository = ApiDeviceRepositoryImpl(mockApiDevice);
  });

  group("ApiDeviceRepositoryImpl", () {
    const String testFcmToken = "test-fcm-token-123";
    const String testDeviceId = "test-device-id-456";
    const String testPlatformTag = "MOBILE_ANDROID";
    const String testOsTag = "ANDROID";
    const String testAppGuid = "test-app-guid-789";
    const String testVersion = "1.0.0";
    const String testUserGuid = "test-user-guid-101";

    late DeviceInfoRequestModel testDeviceInfo;

    setUp(() {
      testDeviceInfo = DeviceInfoRequestModel(
        deviceName: "Test Device",
        latitude: 12.34,
        longitude: 56.78,
        mcc: "404",
        mnc: "10",
      );
    });

    group("registerDevice", () {
      test("should return success resource when API call succeeds", () async {
        // Arrange
        final DeviceInfoResponseModel expectedResponse =
            DeviceInfoResponseModel();
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          data: expectedResponse,
          message: "Device registered successfully",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          fcmToken: testFcmToken,
          deviceId: testDeviceId,
          platformTag: testPlatformTag,
          osTag: testOsTag,
          appGuid: testAppGuid,
          version: testVersion,
          userGuid: testUserGuid,
          deviceInfo: testDeviceInfo,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);
        expect(result.message, "Device registered successfully");
        expect(result.error, isNull);

        verify(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).called(1);
      });

      test("should return error resource when API call returns non-200 status",
          () async {
        // Arrange
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          statusCode: 400,
          developerMessage: "Invalid device information provided",
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          fcmToken: testFcmToken,
          deviceId: testDeviceId,
          platformTag: testPlatformTag,
          osTag: testOsTag,
          appGuid: testAppGuid,
          version: testVersion,
          userGuid: testUserGuid,
          deviceInfo: testDeviceInfo,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Invalid device information provided");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).called(1);
      });

      test("should return error resource when API returns 500 status",
          () async {
        // Arrange
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          statusCode: 500,
          developerMessage: "Internal server error",
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          fcmToken: testFcmToken,
          deviceId: testDeviceId,
          platformTag: testPlatformTag,
          osTag: testOsTag,
          appGuid: testAppGuid,
          version: testVersion,
          userGuid: testUserGuid,
          deviceInfo: testDeviceInfo,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Internal server error");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).called(1);
      });

      test("should return error resource when API returns 401 status",
          () async {
        // Arrange
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          statusCode: 401,
          developerMessage: "Unauthorized access",
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          fcmToken: testFcmToken,
          deviceId: testDeviceId,
          platformTag: testPlatformTag,
          osTag: testOsTag,
          appGuid: testAppGuid,
          version: testVersion,
          userGuid: testUserGuid,
          deviceInfo: testDeviceInfo,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.error);
        expect(result.message, "Unauthorized access");
        expect(result.data, isNull);
        expect(result.error, isNotNull);

        verify(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).called(1);
      });

      test("should pass all parameters correctly to API device", () async {
        // Arrange
        const String customFcmToken = "custom-token";
        const String customDeviceId = "custom-device-id";
        const String customPlatformTag = "MOBILE_IOS";
        const String customOsTag = "IOS";
        const String customAppGuid = "custom-app-guid";
        const String customVersion = "2.1.0";
        const String customUserGuid = "custom-user-guid";

        final DeviceInfoRequestModel customDeviceInfo = DeviceInfoRequestModel(
          deviceName: "iPhone 15",
          latitude: 25.20,
          longitude: 55.27,
          mcc: "424",
          mnc: "02",
        );

        final DeviceInfoResponseModel expectedResponse =
            DeviceInfoResponseModel();
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: customFcmToken,
            deviceId: customDeviceId,
            platformTag: customPlatformTag,
            osTag: customOsTag,
            appGuid: customAppGuid,
            version: customVersion,
            userGuid: customUserGuid,
            deviceInfo: customDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        await repository.registerDevice(
          fcmToken: customFcmToken,
          deviceId: customDeviceId,
          platformTag: customPlatformTag,
          osTag: customOsTag,
          appGuid: customAppGuid,
          version: customVersion,
          userGuid: customUserGuid,
          deviceInfo: customDeviceInfo,
        );

        // Assert
        verify(
          mockApiDevice.registerDevice(
            fcmToken: customFcmToken,
            deviceId: customDeviceId,
            platformTag: customPlatformTag,
            osTag: customOsTag,
            appGuid: customAppGuid,
            version: customVersion,
            userGuid: customUserGuid,
            deviceInfo: customDeviceInfo,
          ),
        ).called(1);
      });
    });

    group("Edge cases and boundary conditions", () {
      test("should handle null response data gracefully", () async {
        // Arrange
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          message: "Success but no data",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          fcmToken: testFcmToken,
          deviceId: testDeviceId,
          platformTag: testPlatformTag,
          osTag: testOsTag,
          appGuid: testAppGuid,
          version: testVersion,
          userGuid: testUserGuid,
          deviceInfo: testDeviceInfo,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert - since statusCode is 200, responseToResource will try to call response.dataOfType
        // which tries to cast null as DeviceInfoResponseModel and might cause issues
        expect(result.resourceType, ResourceType.error);
        expect(result.data, isNull);
      });

      test("should handle empty string parameters", () async {
        // Arrange
        const String emptyString = "";
        final DeviceInfoRequestModel emptyDeviceInfo = DeviceInfoRequestModel(
          deviceName: emptyString,
          mcc: emptyString,
          mnc: emptyString,
        );

        final DeviceInfoResponseModel expectedResponse =
            DeviceInfoResponseModel();
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          data: expectedResponse,
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: emptyString,
            deviceId: emptyString,
            platformTag: emptyString,
            osTag: emptyString,
            appGuid: emptyString,
            version: emptyString,
            userGuid: emptyString,
            deviceInfo: emptyDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final Resource<DeviceInfoResponseModel?> result =
            await repository.registerDevice(
          fcmToken: emptyString,
          deviceId: emptyString,
          platformTag: emptyString,
          osTag: emptyString,
          appGuid: emptyString,
          version: emptyString,
          userGuid: emptyString,
          deviceInfo: emptyDeviceInfo,
        ) as Resource<DeviceInfoResponseModel?>;

        // Assert
        expect(result.resourceType, ResourceType.success);
        expect(result.data, expectedResponse);

        verify(
          mockApiDevice.registerDevice(
            fcmToken: emptyString,
            deviceId: emptyString,
            platformTag: emptyString,
            osTag: emptyString,
            appGuid: emptyString,
            version: emptyString,
            userGuid: emptyString,
            deviceInfo: emptyDeviceInfo,
          ),
        ).called(1);
      });
    });

    group("Repository contract compliance", () {
      test("should implement ApiDeviceRepository interface", () {
        expect(repository, isA<ApiDeviceRepository>());
      });

      test("should return FutureOr<dynamic> as specified in interface", () {
        // Arrange
        final ResponseMain<DeviceInfoResponseModel> responseMain =
            ResponseMain<DeviceInfoResponseModel>.createErrorWithData(
          data: DeviceInfoResponseModel(),
          message: "Success",
          statusCode: 200,
        );

        when(
          mockApiDevice.registerDevice(
            fcmToken: testFcmToken,
            deviceId: testDeviceId,
            platformTag: testPlatformTag,
            osTag: testOsTag,
            appGuid: testAppGuid,
            version: testVersion,
            userGuid: testUserGuid,
            deviceInfo: testDeviceInfo,
          ),
        ).thenAnswer((_) async => responseMain);

        // Act
        final FutureOr<dynamic> result = repository.registerDevice(
          fcmToken: testFcmToken,
          deviceId: testDeviceId,
          platformTag: testPlatformTag,
          osTag: testOsTag,
          appGuid: testAppGuid,
          version: testVersion,
          userGuid: testUserGuid,
          deviceInfo: testDeviceInfo,
        );

        // Assert
        expect(result, isA<FutureOr<dynamic>>());
        expect(result, isA<Future<Resource<DeviceInfoResponseModel?>>>());
      });
    });
  });
}
