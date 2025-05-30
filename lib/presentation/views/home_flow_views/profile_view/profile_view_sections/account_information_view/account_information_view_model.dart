import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/update_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:phone_input/phone_input_package.dart";

class AccountInformationViewModel extends BaseModel {
  bool _receiveUpdates = false;

  bool get receiveUpdated => _receiveUpdates;
  bool _saveButtonEnabled = false;

  String? _validationError;
  String? get validationError => _validationError;

  bool get saveButtonEnabled => _saveButtonEnabled;

  String userEmail = "";
  String userPhoneNumber = "";
  bool isPhoneValid = false;

  TextEditingController get nameController => _nameController;

  TextEditingController get familyNameController => _familyNameController;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final UpdateUserInfoUseCase updateUserInfoUseCase =
      UpdateUserInfoUseCase(locator<ApiAuthRepository>());
  PhoneController phoneController =
      PhoneController(const PhoneNumber(isoCode: IsoCode.LB, nsn: ""));

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userEmail = userEmailAddress;
      _nameController.text = userFirstName;
      _familyNameController.text = userLastName;
      _receiveUpdates = isNewsletterSubscribed;
      phoneController.value = PhoneNumber(
        isoCode: IsoCode.LB,
        nsn: userMsisdn,
      );
      _nameController.addListener(updateButtonState);
      _familyNameController.addListener(updateButtonState);

      notifyListeners();
    });
  }

  void updateSwitch({
    required bool newValue,
  }) {
    _receiveUpdates = newValue;
    updateButtonState();
  }

  void validateNumber(
    String countryCode,
    String phoneNumber, {
    required bool isValid,
  }) {
    isPhoneValid = isValid;
    userPhoneNumber = phoneNumber;
    updateButtonState();
  }

  Future<void> saveButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<AuthResponseModel> updateInfoResponse =
        await updateUserInfoUseCase.execute(
      UpdateUserInfoParams(
        msisdn: userPhoneNumber,
        firstName: _nameController.text,
        lastName: _familyNameController.text,
        isNewsletterSubscribed: _receiveUpdates,
      ),
    );

    await handleResponse(
      updateInfoResponse,
      onSuccess: (Resource<AuthResponseModel> response) async {
        navigationService.back();
      },
    );

    setViewState(ViewState.idle);
  }

  void updateButtonState() {
    bool isValidPhone = (userPhoneNumber.isEmpty)
        ? true
        : ((userPhoneNumber != userMsisdn) && isPhoneValid);

    _saveButtonEnabled = ((_receiveUpdates != isNewsletterSubscribed) ||
            (_nameController.text != userFirstName) ||
            (_familyNameController.text != userLastName) ||
            (userPhoneNumber != userMsisdn)) &&
        isValidPhone;

    if (isPhoneValid) {
      _validationError = null;
    } else if (userPhoneNumber.isNotEmpty) {
      _validationError = LocaleKeys.invalid_phone_number.tr();
    }

    notifyListeners();
  }
}
