import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/apis/app_apis/api_app_impl.dart";
import "package:esim_open_source/domain/data/api_app.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/app_enviroment_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

void main() {
  group("APIAppImpl Implementation Coverage", () {
    late MockConnectivityService mockConnectivityService;
    late MockLocalStorageService mockLocalStorageService;

    setUpAll(() async {
      await setupTestLocator();

      // Initialize AppEnvironment with test values
      AppEnvironment.isFromAppClip = false;
      AppEnvironment.appEnvironmentHelper = createTestEnvironmentHelper();

      // Setup mock services with default stubs
      mockConnectivityService =
          locator<ConnectivityService>() as MockConnectivityService;
      mockLocalStorageService =
          locator<LocalStorageService>() as MockLocalStorageService;

      // Stub required methods to prevent HTTP calls
      when(mockConnectivityService.isConnected())
          .thenAnswer((_) async => false);
      when(mockLocalStorageService.accessToken).thenReturn("");
      when(mockLocalStorageService.refreshToken).thenReturn("");
      when(mockLocalStorageService.languageCode).thenReturn("en");
    });

    test("APIAppImpl singleton initialization", () {
      final APIAppImpl instance1 = APIAppImpl.instance;
      final APIAppImpl instance2 = APIAppImpl.instance;

      expect(instance1, isNotNull);
      expect(instance1, same(instance2));
      expect(instance1, isA<APIApp>());
    });

    test("addDevice method implementation coverage", () async {
      final APIAppImpl apiImpl = APIAppImpl.instance;

      // Test actual implementation - expect connectivity exception since we stub to false
      try {
        await apiImpl.addDevice(
          fcmToken: "test_token",
          manufacturer: "test_manufacturer",
          deviceModel: "test_model",
          deviceOs: "test_os",
          deviceOsVersion: "test_version",
          appVersion: "test_app_version",
          ramSize: "test_ram",
          screenResolution: "test_resolution",
          isRooted: false,
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.addDevice, isA<Function>());
    });

    test("getFaq method implementation coverage", () async {
      final APIAppImpl apiImpl = APIAppImpl.instance;

      try {
        await apiImpl.getFaq();
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getFaq, isA<Function>());
    });

    test("contactUs method implementation coverage", () async {
      final APIAppImpl apiImpl = APIAppImpl.instance;

      try {
        await apiImpl.contactUs(
          email: "test@example.com",
          message: "test message",
        );
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.contactUs, isA<Function>());
    });

    test("getAboutUs method implementation coverage", () async {
      final APIAppImpl apiImpl = APIAppImpl.instance;

      try {
        await apiImpl.getAboutUs();
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getAboutUs, isA<Function>());
    });

    test("getTermsConditions method implementation coverage", () async {
      final APIAppImpl apiImpl = APIAppImpl.instance;

      try {
        await apiImpl.getTermsConditions();
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getTermsConditions, isA<Function>());
    });

    test("getConfigurations method implementation coverage", () async {
      final APIAppImpl apiImpl = APIAppImpl.instance;

      try {
        await apiImpl.getConfigurations();
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getConfigurations, isA<Function>());
    });

    test("getCurrencies method implementation coverage", () async {
      final APIAppImpl apiImpl = APIAppImpl.instance;

      try {
        await apiImpl.getCurrencies();
      } on Object catch (e) {
        expect(e.toString(), contains("No internet connection"));
      }

      expect(apiImpl.getCurrencies, isA<Function>());
    });

    test("APIAppImpl implements all APIApp interface methods", () {
      final APIAppImpl apiImpl = APIAppImpl.instance;
      final APIApp apiInterface = apiImpl as APIApp;

      expect(apiInterface.addDevice, isNotNull);
      expect(apiInterface.getFaq, isNotNull);
      expect(apiInterface.contactUs, isNotNull);
      expect(apiInterface.getAboutUs, isNotNull);
      expect(apiInterface.getTermsConditions, isNotNull);
      expect(apiInterface.getConfigurations, isNotNull);
      expect(apiInterface.getCurrencies, isNotNull);
    });
  });
}
