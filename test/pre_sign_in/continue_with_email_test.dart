// continue_with_email_view_model_test.dart

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view_model.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mockito/mockito.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:stacked_services/stacked_services.dart";
import "package:stacked_themes/stacked_themes.dart";

import "../helpers/haptic_helper.dart";
import "../helpers/view_helper.dart";
import "../helpers/view_model_helper.dart";
import "../locator_test.dart";

class MockContinueWithEmailViewModel extends Mock
    implements ContinueWithEmailViewModel {
  @override
  ViewState get viewState => ViewState.idle;

  @override
  bool get isBusy => false;
}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  await EasyLocalization.ensureInitialized();
  await ThemeManager.initialise();

  late ContinueWithEmailViewModel viewModel;
  late MockContinueWithEmailViewModel mockViewModel;

  setUp(() async {
    await setupTestLocator();
    HapticHelperTest.implementHaptic();
    AppEnvironment.setupEnvironment();
    viewModel = ContinueWithEmailViewModel();
    mockViewModel = MockContinueWithEmailViewModel();
  });

  group("View Model Testing", () {
    test("Back button tapped", () {
      when(locator<NavigationService>().back()).thenReturn(true);
      viewModel.backButtonTapped();
      verify(locator<NavigationService>().back()).called(1);
    });

    test("Update terms selection tapped", () {
      viewModel.state?.isTermsChecked = false;
      viewModel.updateTermsSelections();
      expect(viewModel.state?.isTermsChecked, true);
    });

    test("Email address validation error", () {
      viewModel.state?.emailController.text = "raed.com";
      String result = viewModel
          .validateEmailAddress(viewModel.state?.emailController.text ?? "");
      expect(result, LocaleKeys.enter_a_valid_email_address.tr());
    });

    test("Initial state is correct", () {
      expect(viewModel.state?.isLoginEnabled, false);
      expect(viewModel.state?.isTermsChecked, false);
      expect(viewModel.state?.emailErrorMessage, isNull);
    });

    test("validateEmailAddress returns required field error when empty", () {
      expect(viewModel.validateEmailAddress(""), isNotEmpty);
    });

    test("validateEmailAddress returns valid for proper email", () {
      expect(viewModel.validateEmailAddress("test@example.com"), "");
    });

    test("validateForm enables login only with valid email and terms checked",
        () async {
      onViewModelReadyMock();
      viewModel.onViewModelReady();

      viewModel.state?.isTermsChecked = true;
      viewModel.state?.emailController.text = "test@example.com";

      expect(viewModel.state?.isLoginEnabled, true);
      expect(viewModel.state?.emailErrorMessage, "");
    });

    test("loginWithEmail navigates to verify view on success", () async {
      viewModel.state?.emailController.text = "test@example.com";

      when(locator<ApiAuthRepository>().login(email: "test@example.com"))
          .thenAnswer(
        (_) async =>
            Resource<EmptyResponse>.success(EmptyResponse(), message: ""),
      );

      when(
        locator<NavigationService>().navigateTo(
          "VerifyLoginView",
          arguments: "test@example.com",
        ),
      ).thenAnswer((_) async => true);

      await viewModel.loginButtonTapped();

      verify(
        locator<NavigationService>().navigateTo(
          "VerifyLoginView",
          arguments: "test@example.com",
        ),
      ).called(1);
    });

    test("showTermsSheet sets isTermsChecked to true when confirmed", () async {
      when(
        locator<BottomSheetService>().showCustomSheet(
          variant: BottomSheetType.termsCondition,
          isScrollControlled: true,
          enableDrag: false,
        ),
      ).thenAnswer(
        (_) async => SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
      );

      await viewModel.showTermsSheet();

      expect(viewModel.state?.isTermsChecked, true);
    });
  });

  group("View Testing", () {
    testWidgets("Renders ContinueWithEmailView with input and button",
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestableWidget(
          ContinueWithEmailView(
            overrideViewModel: mockViewModel,
          ),
        ),
      );

      expect(find.byType(MainInputField), findsOneWidget);
      expect(find.byType(MainButton), findsOneWidget);
      expect(find.textContaining("terms"), findsOneWidget);
    });

    testWidgets("Tapping on terms checkbox calls updateTermsSelections",
        (WidgetTester tester) async {
      when(mockViewModel.state).thenReturn(ContinueWithEmailState());

      await tester.pumpWidget(
        createTestableWidget(
          ContinueWithEmailView(
            overrideViewModel: mockViewModel,
          ),
        ),
      );

      expect(mockViewModel.state?.isTermsChecked, false);
      final Finder gesture = find.byType(GestureDetector).at(2);
      await tester.tap(gesture);
      await tester.pump();

      verify(mockViewModel.updateTermsSelections()).called(1);
    });

    testWidgets("Pressing MainButton triggers loginButtonTapped",
        (WidgetTester tester) async {
      when(mockViewModel.state)
          .thenReturn(ContinueWithEmailState()..isLoginEnabled = true);

      await tester.pumpWidget(
        createTestableWidget(
          ContinueWithEmailView(
            overrideViewModel: mockViewModel,
          ),
        ),
      );

      await tester.tap(find.byType(MainButton));
      await tester.pump();

      verify(mockViewModel.loginButtonTapped()).called(1);
    });
  });

  tearDown(() async {
    locator.reset();
    resetMockitoState();
  });

  tearDownAll(() async {
    HapticHelperTest.deInitHaptic();
  });
}
