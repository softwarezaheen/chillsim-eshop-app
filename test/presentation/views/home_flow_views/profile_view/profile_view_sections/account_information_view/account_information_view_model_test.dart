import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/account_information_view/account_information_view_model.dart";
import "package:flutter_test/flutter_test.dart";

import "../../../../../../helpers/view_helper.dart";
import "../../../../../../helpers/view_model_helper.dart";
import "../../../../../../locator_test.dart";

Future<void> main() async {
  await prepareTest();
  late AccountInformationViewModel viewModel;

  setUp(() async {
    await setupTest();
    viewModel = locator<AccountInformationViewModel>();
  });

  tearDown(() async {
    await tearDownTest();
  });

  tearDownAll(() async {
    await tearDownAllTest();
  });

  group("AccountInformationViewModel Tests", () {
    late AccountInformationViewModel viewModel;

    setUp(() {
      onViewModelReadyMock(viewName: "AccountInformationView");
      viewModel = AccountInformationViewModel();
    });

    test("initial values", () {
      expect(viewModel.receiveUpdated, isFalse);
      expect(viewModel.isValidEmail, isFalse);
      expect(viewModel.saveButtonEnabled, isFalse);
      expect(viewModel.userEmail, isEmpty);
      expect(viewModel.userPhoneNumber, isEmpty);
      expect(viewModel.isPhoneValid, isFalse);
    });

    test("controllers are initialized", () {
      expect(viewModel.nameController, isNotNull);
      expect(viewModel.emailController, isNotNull);
      expect(viewModel.familyNameController, isNotNull);
      expect(viewModel.phoneController, isNotNull);
    });

    test("validateEmailAddress - empty email", () {
      final String result = viewModel.validateEmailAddress("");
      expect(result, isNotEmpty);
      expect(viewModel.isValidEmail, isFalse);
    });

    test("validateEmailAddress - invalid email", () {
      final String result = viewModel.validateEmailAddress("invalid");
      expect(result, isNotEmpty);
      expect(viewModel.isValidEmail, isFalse);
    });

    test("validateEmailAddress - valid email", () {
      final String result = viewModel.validateEmailAddress("test@example.com");
      expect(result, isEmpty);
      expect(viewModel.isValidEmail, isTrue);
    });

    test("updateSwitch changes value", () {
      expect(viewModel.receiveUpdated, isFalse);
      viewModel.updateSwitch(newValue: true);
      expect(viewModel.receiveUpdated, isTrue);
    });

    test("validateNumber updates state", () {
      viewModel.validateNumber("961", "12345678", isValid: true);
      expect(viewModel.isPhoneValid, isTrue);
      expect(viewModel.userPhoneNumber, equals("12345678"));
    });

    test("updateButtonState - phone login", () {
      AppEnvironment.appEnvironmentHelper.setLoginTypeFromApi =
          LoginType.phoneNumber;
      viewModel.updateButtonState();
      expect(viewModel.saveButtonEnabled, isA<bool>());
    });

    test("updateButtonState - email login", () {
      AppEnvironment.appEnvironmentHelper.setLoginTypeFromApi = LoginType.email;
      viewModel.updateButtonState();
      expect(viewModel.saveButtonEnabled, isA<bool>());
    });

    test("updateButtonState handles validation errors", () {
      viewModel..userPhoneNumber = "invalid"
      ..isPhoneValid = false
      ..updateButtonState();
      expect(viewModel.validationError, isNotNull);

      viewModel..isPhoneValid = true
      ..updateButtonState();
      expect(viewModel.validationError, isNull);
    });

    test("property getters work correctly", () {
      expect(viewModel.validationError, isNull);
      expect(viewModel.emailErrorMessage, isNull);
      expect(viewModel.nameController.text, isEmpty);
      expect(viewModel.familyNameController.text, isEmpty);
      expect(viewModel.emailController.text, isEmpty);
    });

    test("updateUserInfoUseCase is initialized", () {
      expect(viewModel.updateUserInfoUseCase, isNotNull);
    });
  });
}
