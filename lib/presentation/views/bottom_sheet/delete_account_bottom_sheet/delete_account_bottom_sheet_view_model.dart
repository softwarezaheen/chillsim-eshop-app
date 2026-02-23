import "dart:developer";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/delete_account_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/phone_number_utils.dart";
import "package:flutter/cupertino.dart";
import "package:phone_input/phone_input_package.dart";

class DeleteAccountBottomSheetViewModel extends BaseModel {
  String? emailErrorMessage;
  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;
  TextEditingController get emailController => _emailController;
  final TextEditingController _emailController = TextEditingController();
  final DeleteAccountUseCase deleteAccountUseCase =
      DeleteAccountUseCase(locator<ApiAuthRepository>());

  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.SY, nsn: ""));

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the safe phone number creation utility
      phoneController.value = PhoneNumberUtils.createSafePhoneNumber(
        phoneNumberString: userMsisdn,
      );
      _emailController.addListener(_validateForm);
    });
  }

  void _validateForm() {
    final String emailAddress = _emailController.text.trim();
    emailErrorMessage = validateEmailAddress(emailAddress.trim());
    _isButtonEnabled = emailErrorMessage?.isEmpty ?? false;

    notifyListeners();
  }

  String validateEmailAddress(String text) {
    if (text.isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    if (!text.isValidEmail()) {
      return LocaleKeys.enter_a_valid_email_address.tr();
    }

    if (text != userEmailAddress) {
      return LocaleKeys.email_address_mismatch.tr();
    }

    return "";
  }

  void validateNumber({
    required String code,
    required String phoneNumber,
    required bool isValid,
  }) {
    log("User MSISDN: $userMsisdn");
    try {
      // Ensure all inputs are valid before comparison
      if (PhoneNumberUtils.isValidMsisdn(userMsisdn) && code.isNotEmpty) {
        String fullPhoneNumber = "+$code$phoneNumber";
        bool phoneNumberMatches = PhoneNumberUtils.phoneNumbersMatch(
          userMsisdn,
          fullPhoneNumber,
        );
        _isButtonEnabled = isValid && phoneNumberMatches;
      } else {
        _isButtonEnabled = false;
      }
    } on Exception catch (e) {
      log("Error validating phone number: $e");
      _isButtonEnabled = false;
    }
    notifyListeners();
  }

  Future<void> deleteAccountButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<EmptyResponse?> deleteAccountResponse =
        await deleteAccountUseCase.execute(NoParams());

    await handleResponse(
      deleteAccountResponse,
      onSuccess: (Resource<EmptyResponse?> response) async {},
      onFailure: (Resource<EmptyResponse?> response) async {},
    );

    setViewState(ViewState.idle);
  }
}
