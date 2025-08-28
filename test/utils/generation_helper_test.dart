import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/secure_storage_service.dart";
import "package:esim_open_source/utils/generation_helper.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../locator_test.mocks.dart";

Future<void> main() async {
  setUpAll(() {
    // Initialize the service locator for testing
    if (!locator.isRegistered<LocalStorageService>()) {
      locator.registerLazySingleton<LocalStorageService>(
        MockLocalStorageService.new,
      );
    }
    if (!locator.isRegistered<AppConfigurationService>()) {
      locator.registerLazySingleton<AppConfigurationService>(
        MockAppConfigurationService.new,
      );
    }
  });

  tearDownAll(locator.reset);

  group("GenerationHelper Tests", () {
    group("getUniqueDeviceID", () {
      test("handles null services gracefully", () async {
        final String result = await getUniqueDeviceID(null, null);

        expect(result, isNotEmpty);
        expect(result.length, equals(16));
      });

      test("returns existing device ID from secure storage", () async {
        final MockSecureStorageService mockSecureStorage =
            MockSecureStorageService();
        final MockDeviceInfoService mockDeviceInfo = MockDeviceInfoService();

        when(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .thenAnswer((_) async => "existing-device-id");

        final String result =
            await getUniqueDeviceID(mockDeviceInfo, mockSecureStorage);

        expect(result, equals("existing-device-id"));
        verify(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .called(1);
        verifyNever(mockDeviceInfo.deviceID);
      });

      test("gets device ID from device info service when storage is empty",
          () async {
        final MockSecureStorageService mockSecureStorage =
            MockSecureStorageService();
        final MockDeviceInfoService mockDeviceInfo = MockDeviceInfoService();

        when(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .thenAnswer((_) async => "");
        when(mockDeviceInfo.deviceID).thenAnswer((_) async => "device-info-id");

        final String result =
            await getUniqueDeviceID(mockDeviceInfo, mockSecureStorage);

        expect(result, equals("device-info-id"));
        verify(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .called(1);
        verify(mockDeviceInfo.deviceID).called(1);
        verify(
          mockSecureStorage.setString(
            SecureStorageKeys.deviceID,
            "device-info-id",
          ),
        ).called(1);
      });

      test("generates random string when both services return empty", () async {
        final MockSecureStorageService mockSecureStorage =
            MockSecureStorageService();
        final MockDeviceInfoService mockDeviceInfo = MockDeviceInfoService();

        when(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .thenAnswer((_) async => "");
        when(mockDeviceInfo.deviceID).thenAnswer((_) async => "");

        final String result =
            await getUniqueDeviceID(mockDeviceInfo, mockSecureStorage);

        expect(result, isNotEmpty);
        expect(result.length, equals(16));
        verify(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .called(1);
        verify(mockDeviceInfo.deviceID).called(1);
        verify(mockSecureStorage.setString(SecureStorageKeys.deviceID, result))
            .called(1);
      });

      test("handles empty device ID from device info service", () async {
        final MockSecureStorageService mockSecureStorage =
            MockSecureStorageService();
        final MockDeviceInfoService mockDeviceInfo = MockDeviceInfoService();

        when(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .thenAnswer((_) async => "");
        when(mockDeviceInfo.deviceID).thenAnswer((_) async => "");

        final String result =
            await getUniqueDeviceID(mockDeviceInfo, mockSecureStorage);

        expect(result, isNotEmpty);
        expect(result.length, equals(16));
      });

      test("saves generated ID to secure storage", () async {
        final MockSecureStorageService mockSecureStorage =
            MockSecureStorageService();

        when(mockSecureStorage.getString(SecureStorageKeys.deviceID))
            .thenAnswer((_) async => "");

        final String result = await getUniqueDeviceID(null, mockSecureStorage);

        expect(result, isNotEmpty);
        verify(mockSecureStorage.setString(SecureStorageKeys.deviceID, result))
            .called(1);
      });
    });

    group("getSelectedCurrencyCode", () {
      late MockLocalStorageService mockLocalStorage;
      late MockAppConfigurationService mockAppConfig;

      setUp(() {
        mockLocalStorage = MockLocalStorageService();
        mockAppConfig = MockAppConfigurationService();

        // Reset and register fresh mocks for each test
        locator
          ..unregister<LocalStorageService>()
          ..unregister<AppConfigurationService>()
          ..registerLazySingleton<LocalStorageService>(() => mockLocalStorage)
          ..registerLazySingleton<AppConfigurationService>(
            () => mockAppConfig,
          );
      });

      test("returns currency from local storage when available", () {
        when(mockLocalStorage.currencyCode).thenReturn("USD");

        final String result = getSelectedCurrencyCode();

        expect(result, equals("USD"));
        verify(mockLocalStorage.currencyCode).called(1);
        verifyNever(mockAppConfig.getDefaultCurrency);
      });

      test("returns default currency when local storage is null", () {
        when(mockLocalStorage.currencyCode).thenReturn(null);
        when(mockAppConfig.getDefaultCurrency).thenReturn("EUR");
        when(mockLocalStorage.setString(any, any))
            .thenAnswer((_) async => true);

        final String result = getSelectedCurrencyCode();

        expect(result, equals("EUR"));
        verify(mockLocalStorage.currencyCode).called(1);
        verify(mockAppConfig.getDefaultCurrency)
            .called(2); // Called twice in the function
        verify(mockLocalStorage.setString(LocalStorageKeys.appCurrency, "EUR"))
            .called(1);
      });

      test("returns default currency when local storage is empty", () {
        when(mockLocalStorage.currencyCode).thenReturn("");
        when(mockAppConfig.getDefaultCurrency).thenReturn("GBP");
        when(mockLocalStorage.setString(any, any))
            .thenAnswer((_) async => true);

        final String result = getSelectedCurrencyCode();

        expect(result, equals("GBP"));
        verify(mockLocalStorage.currencyCode).called(1);
        verify(mockAppConfig.getDefaultCurrency).called(2);
        verify(mockLocalStorage.setString(LocalStorageKeys.appCurrency, "GBP"))
            .called(1);
      });

      test("returns empty string when both storage and config are empty", () {
        when(mockLocalStorage.currencyCode).thenReturn(null);
        when(mockAppConfig.getDefaultCurrency).thenReturn("");

        final String result = getSelectedCurrencyCode();

        expect(result, equals(""));
        verify(mockLocalStorage.currencyCode).called(1);
        verify(mockAppConfig.getDefaultCurrency).called(1);
        verifyNever(mockLocalStorage.setString(any, any));
      });

      test("handles different currency codes", () {
        when(mockLocalStorage.currencyCode).thenReturn("JPY");

        final String result = getSelectedCurrencyCode();

        expect(result, equals("JPY"));

        // Test another currency
        when(mockLocalStorage.currencyCode).thenReturn("CAD");

        final String result2 = getSelectedCurrencyCode();
        expect(result2, equals("CAD"));
      });

      test("sets default currency in storage when retrieved from config", () {
        when(mockLocalStorage.currencyCode).thenReturn("");
        when(mockAppConfig.getDefaultCurrency).thenReturn("AUD");
        when(mockLocalStorage.setString(any, any))
            .thenAnswer((_) async => true);

        getSelectedCurrencyCode();

        verify(mockLocalStorage.setString(LocalStorageKeys.appCurrency, "AUD"))
            .called(1);
      });
    });

    group("generateRandomString", () {
      test("generates string of correct length", () {
        final String result = generateRandomString(10);
        expect(result.length, equals(10));
      });

      test("generates different strings on multiple calls", () {
        final String result1 = generateRandomString(16);
        final String result2 = generateRandomString(16);

        expect(result1, isNot(equals(result2)));
        expect(result1.length, equals(16));
        expect(result2.length, equals(16));
      });

      test("generates empty string for zero length", () {
        final String result = generateRandomString(0);
        expect(result, equals(""));
      });

      test("generates valid characters only", () {
        const String validChars =
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        final String result = generateRandomString(100);

        for (int i = 0; i < result.length; i++) {
          expect(validChars.contains(result[i]), isTrue);
        }
      });

      test("handles large length values", () {
        final String result = generateRandomString(1000);
        expect(result.length, equals(1000));
        expect(result, isNotEmpty);
      });
    });
  });
}
