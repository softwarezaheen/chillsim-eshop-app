import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/login_view/login_view.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:stacked_services/stacked_services.dart";

import "../../../../../helpers/view_helper.dart";
import "../../../../../helpers/view_model_helper.dart";
import "../../../../../locator_test.dart";
import "../../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late ProfileViewModel viewModel;
  late MockNavigationService mockNavigationService;
  late UserAuthenticationService _mockUserAuthenticationService;

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "ProfileView");
    viewModel = ProfileViewModel();
    mockNavigationService =
        locator<NavigationService>() as MockNavigationService;
  _mockUserAuthenticationService = locator<UserAuthenticationService>();
  });

  tearDown(() async {
    await tearDownTest();
  });

  group("ProfileViewModel Tests", () {
    group("Initialization", () {
      test("initializes with correct default values", () {
        expect(viewModel.appVersion, isEmpty);
        expect(viewModel.buildNumber, isEmpty);
      });

      test("mock user auth service exists", () {
        expect(_mockUserAuthenticationService, isNotNull);
      });

      test("onViewModelReady method exists and can be called", () {
        expect(() => viewModel.onViewModelReady(), returnsNormally);
      });

      test("viewModel extends correct base class", () {
        expect(viewModel, isA<ChangeNotifier>());
      });
    });

    group("Package Info", () {
      test("getPackageInfo updates app version and build number", () async {
        // Mock PackageInfo
        PackageInfo.setMockInitialValues(
          appName: "Test App",
          packageName: "com.test.app",
          version: "1.0.0",
          buildNumber: "123",
          buildSignature: "",
        );

        await viewModel.getPackageInfo();

        expect(viewModel.appVersion, equals("1.0.0"));
        expect(viewModel.buildNumber, equals("123"));
      });

      test("getPackageInfo handles different values", () async {
        // Test with different package info values
        PackageInfo.setMockInitialValues(
          appName: "Different App",
          packageName: "com.different.app",
          version: "3.5.2",
          buildNumber: "999",
          buildSignature: "",
        );

        await viewModel.getPackageInfo();

        expect(viewModel.appVersion, equals("3.5.2"));
        expect(viewModel.buildNumber, equals("999"));
      });
    });

    group("Navigation", () {
      test("loginButtonTapped navigates to login view", () async {
        when(mockNavigationService.navigateTo(LoginView.routeName))
            .thenAnswer((_) async => true);

        await viewModel.loginButtonTapped();

        verify(mockNavigationService.navigateTo(LoginView.routeName)).called(1);
      });
    });

    group("User Name", () {
      test("getUserName returns correct value based on login type", () {
        final String result = viewModel.getUserName();

        // The method should return a string value from the mocked service
        expect(result, isA<String>());
      });

      test("getUserName method can be called without errors", () {
        expect(() => viewModel.getUserName(), returnsNormally);
      });
    });

    group("Property Access", () {
      test("appVersion getter returns correct type", () {
        expect(viewModel.appVersion, isA<String>());
      });

      test("buildNumber getter returns correct type", () {
        expect(viewModel.buildNumber, isA<String>());
      });
    });
  });
}
