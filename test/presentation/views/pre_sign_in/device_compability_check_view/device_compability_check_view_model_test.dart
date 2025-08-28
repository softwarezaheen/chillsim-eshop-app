import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view_model.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../helpers/view_model_helper.dart";
import "../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();
  late DeviceCompabilityCheckViewModel viewModel;
  late LocalStorageService localStorageService;
  tearDown(() async {
    await tearDownTest();
  });

  setUp(() async {
    await setupTest();
    onViewModelReadyMock(viewName: "DeviceCompabilityView");
    viewModel = DeviceCompabilityCheckViewModel();
    localStorageService = locator<LocalStorageService>();
    when(
      localStorageService.setBool(
        LocalStorageKeys.hasPreviouslyStarted,
        value: true,
      ),
    ).thenAnswer((_) async => true);
  });

  test("initialization sets default values", () async {
    await viewModel.onViewModelReady();
    await viewModel.startChecking();
  });
}
