// device_compability_check_view_model_test.dart

import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view_model.dart";
import "package:flutter/material.dart";
import "package:flutter_esim/flutter_esim.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";

import "../../../../helpers/view_helper.dart";
import "../../../../locator_test.dart";
import "../../../../locator_test.mocks.dart";

Future<void> main() async {
  await prepareTest();
  late DeviceCompabilityCheckViewModel viewModel;
  FlutterEsim flutterEsim = MockFlutterEsim();

  setUp(() async {
    await setupTest();
    viewModel = locator<DeviceCompabilityCheckViewModel>();

    when(viewModel.isBusy).thenReturn(false);
    when(viewModel.viewState).thenReturn(ViewState.idle);
  });

  testWidgets(
      "Renders DeviceCompabilityCheckView with DeviceCompatibleType.compatible",
      (WidgetTester tester) async {
    when(viewModel.deviceCompatibleType)
        .thenReturn(DeviceCompatibleType.compatible);
    when(flutterEsim.isSupportESim(null)).thenAnswer((_) async => true);

    await tester.pumpWidget(
      createTestableWidget(
        const DeviceCompabilityCheckView(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
  });

  testWidgets(
      "Renders DeviceCompabilityCheckView with DeviceCompatibleType.incompatible",
      (WidgetTester tester) async {
    when(viewModel.deviceCompatibleType)
        .thenReturn(DeviceCompatibleType.incompatible);
    when(flutterEsim.isSupportESim(null)).thenAnswer((_) async => true);

    await tester.pumpWidget(
      createTestableWidget(
        const DeviceCompabilityCheckView(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(Column), findsOneWidget);
  });

  testWidgets(
      "Renders DeviceCompabilityCheckView with DeviceCompatibleType.loading",
      (WidgetTester tester) async {
    when(viewModel.deviceCompatibleType)
        .thenReturn(DeviceCompatibleType.loading);

    await tester.pumpWidget(
      createTestableWidget(
        const DeviceCompabilityCheckView(),
      ),
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  tearDown(() async {
    tearDownTest();
  });

  tearDownAll(() async {
    tearDownAllTest();
  });
}
