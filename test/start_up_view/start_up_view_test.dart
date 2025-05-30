import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/views/start_up_view/startup_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../helpers/fake_build_context.dart";
import "../locator_test.dart";

class TestableStartUpViewModel extends StartUpViewModel {
  @override
  Future<void> showDeviceCompromisedDialog(BuildContext context) async {
    // no-op for test
  }
}

void main() {
  late TestableStartUpViewModel viewModel;

  late DeviceInfoService deviceInfoService;
  late ApiAuthRepository apiAuthRepository;

  setUp(() async {
    await setupTestLocator();

    deviceInfoService = locator<DeviceInfoService>();
    apiAuthRepository = locator<ApiAuthRepository>();

    viewModel = TestableStartUpViewModel();
  });

  test("checkIfDeviceCompatible returns true when device is compromised",
      () async {
    when(deviceInfoService.isRooted).thenAnswer((_) async => true);
    when(deviceInfoService.isDevelopmentModeEnable)
        .thenAnswer((_) async => false);
    when(deviceInfoService.isPhysicalDevice).thenAnswer((_) async => true);

    final bool result = await viewModel.checkIfDeviceCompatible(FakeContext());

    expect(result, true);
  });

  test("checkIfDeviceCompatible returns true when device is not compromised",
      () async {
    when(deviceInfoService.isRooted).thenAnswer((_) async => false);
    when(deviceInfoService.isDevelopmentModeEnable)
        .thenAnswer((_) async => false);
    when(deviceInfoService.isPhysicalDevice).thenAnswer((_) async => true);

    final bool result = await viewModel.checkIfDeviceCompatible(FakeContext());

    expect(result, false);
  });

  test("refreshTokenTrigger sets view state idle on success", () async {
    when(apiAuthRepository.refreshTokenAPITrigger()).thenAnswer(
      (_) async => Resource<AuthResponseModel>.success(
        AuthResponseModel(),
        message: "Success",
      ),
    );

    when(locator<BundlesDataService>().hasError).thenReturn(false);

    await viewModel.refreshTokenTrigger();

    expect(viewModel.isBusy, false);
    expect(viewModel.hasError, false);
  });

  test("refreshTokenTrigger sets error", () async {
    when(apiAuthRepository.refreshTokenAPITrigger()).thenAnswer(
      (_) async => Resource<AuthResponseModel>.error("Failed"),
    );

    await viewModel.refreshTokenTrigger();

    expect(viewModel.isBusy, false);
  });

  test("refreshTokenTrigger sets error on exception", () async {
    when(apiAuthRepository.refreshTokenAPITrigger())
        .thenThrow(Exception("failed"));

    await viewModel.refreshTokenTrigger();

    expect(viewModel.isBusy, false);
  });

  tearDown(() async => locator.reset());
}
