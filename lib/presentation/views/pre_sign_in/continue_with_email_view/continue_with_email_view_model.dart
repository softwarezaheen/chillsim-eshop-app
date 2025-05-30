import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/verify_login_view/verify_login_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class ContinueWithEmailViewModel extends BaseModel {
  //#region UseCases
  final LoginUseCase loginUseCase = LoginUseCase(locator<ApiAuthRepository>());
  //#endregion

  //#region Variables
  final ContinueWithEmailState _state = ContinueWithEmailState();
  ContinueWithEmailState? get state => _state;

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    _state.emailController.addListener(_validateForm);
  }

  void _validateForm() {
    final String emailAddress = _state.emailController.text;
    _state
      ..emailErrorMessage = validateEmailAddress(emailAddress)
      ..isLoginEnabled =
          _state.emailErrorMessage == "" && _state.isTermsChecked;

    notifyListeners();
  }

  Future<void>? loginButtonTapped() async {
    await _loginWithEmail();
  }

  void updateTermsSelections() {
    _state.isTermsChecked = !_state.isTermsChecked;
    notifyListeners();
    _validateForm();
  }

  String validateEmailAddress(String text) {
    if (text.trim().isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    if (text.trim().isValidEmail()) {
      return "";
    }

    return LocaleKeys.enter_a_valid_email_address.tr();
  }

  void backButtonTapped() {
    navigationService.back();
  }

  Future<void>? showTermsSheet() async {
    SheetResponse<EmptyBottomSheetResponse>? response =
        await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.termsCondition,
      isScrollControlled: true,
      enableDrag: false,
    );
    if (response?.confirmed ?? false) {
      _state.isTermsChecked = true;
      _validateForm();
    }
  }

  //#endregion

  //#region Apis
  Future<void> _loginWithEmail() async {
    setViewState(ViewState.busy);

    Resource<EmptyResponse?> loginResponse = await loginUseCase.execute(
      LoginParams(
        email: _state.emailController.text,
      ),
    );

    await handleResponse(
      loginResponse,
      onSuccess: (Resource<EmptyResponse?> response) async {
        navigationService.navigateTo(
          VerifyLoginView.routeName,
          arguments: _state.emailController.text,
        );
      },
    );

    setViewState(ViewState.idle);
  }
  //#endregion
}

class ContinueWithEmailState {
  bool isTermsChecked = false;
  bool isLoginEnabled = false;
  String? emailErrorMessage;
  final TextEditingController emailController = TextEditingController();
}
