import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/resend_otp_use_case.dart";
import "package:esim_open_source/domain/use_case/auth/verify_otp_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class VerifyLoginViewModel extends BaseModel {
  VerifyLoginViewModel({required this.emailAddress});

  bool _isVerifyButtonEnabled = false;
  bool get isVerifyButtonEnabled => _isVerifyButtonEnabled;

  String emailAddress;
  String _pinCode = "";
  String _errorMessage = "";
  @override
  String get errorMessage => _errorMessage;

  final int otpCount = 6;

  final ResendOtpUseCase resendOtpUseCase =
      ResendOtpUseCase(locator<ApiAuthRepository>());
  final VerifyOtpUseCase verifyOtpUseCase =
      VerifyOtpUseCase(locator<ApiAuthRepository>());

  List<String> initialVerificationCode = <String>[];

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    initialVerificationCode =
        List<String>.generate(otpCount, (int index) => "");
  }

  Future<void> backButtonTapped() async {
    navigationService.back();
  }

  Future<void> verifyButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<AuthResponseModel> authResponse = await verifyOtpUseCase.execute(
      VerifyOtpParams(
        pinCode: _pinCode,
        email: emailAddress,
      ),
    );

    await handleResponse(
      authResponse,
      onSuccess: (Resource<AuthResponseModel> response) async {
        await navigateToHomePager();
      },
      onFailure: (Resource<AuthResponseModel> response) async {
        _errorMessage = LocaleKeys.verifyLogin_wrongCode.tr();
        notifyListeners();
      },
    );

    setViewState(ViewState.idle);
  }

  Future<void> resendCodeButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<EmptyResponse?> resendOtpResponse = await resendOtpUseCase.execute(
      ResendOtpParams(
        email: emailAddress,
      ),
    );

    await handleResponse(
      resendOtpResponse,
      onSuccess: (Resource<EmptyResponse?> response) async {},
    );

    setViewState(ViewState.idle);
  }

  void otpFieldChanged(String verificationCode) {
    fillInitial(verificationCode);
    _isVerifyButtonEnabled = false;
    notifyListeners();
  }

  Future<void> otpFieldSubmitted(String verificationCode) async {
    fillInitial(verificationCode);
    _pinCode = verificationCode;
    _isVerifyButtonEnabled = true;
    notifyListeners();
  }

  void fillInitial(String verificationCode) {
    initialVerificationCode = List<String>.generate(
      otpCount,
      (int index) =>
          index < verificationCode.length ? verificationCode[index] : "",
    );
    notifyListeners();
  }
}
