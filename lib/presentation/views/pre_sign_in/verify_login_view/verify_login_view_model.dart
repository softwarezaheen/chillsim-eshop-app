import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/domain/use_case/auth/resend_otp_use_case.dart";
import "package:esim_open_source/domain/use_case/auth/verify_otp_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class VerifyLoginViewModel extends BaseModel {
  VerifyLoginViewModel({this.username, this.redirection});
  InAppRedirection? redirection;

  bool _isVerifyButtonEnabled = false;
  bool get isVerifyButtonEnabled => _isVerifyButtonEnabled;

  String? username;
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
        username: username ?? "",
      ),
    );

    await handleResponse(
      authResponse,
      onSuccess: (Resource<AuthResponseModel> response) async {
        // 🔥 CRITICAL FIX: Fetch FRESH FCM token from Firebase before device re-registration
        // This ensures we send the latest token, not stale value from app startup
        // Matches web app and social login behavior
        try {
          log("🔄 Fetching fresh FCM token for device re-registration...");
          
          // Get fresh FCM token from Firebase (not stale LocalStorage value)
          final PushNotificationService pushNotificationService = locator<PushNotificationService>();
          String? fcmToken = await pushNotificationService.getFcmToken();
          
          // Only save and register if we have a valid token
          if (fcmToken != null && fcmToken.isNotEmpty) {
            // Update LocalStorage with fresh token
            await locator<LocalStorageService>().setString(
              LocalStorageKeys.fcmToken,
              fcmToken,
            );
            log("✅ Fresh FCM token obtained and saved to LocalStorage");
          } else {
            log("⚠️ No FCM token available - user may have denied permission");
          }
          
          // Re-register device with backend (uses token from LocalStorage)
          await addDeviceUseCase.execute(NoParams());
          log("✅ Device re-registered with FCM token after OTP verification");
        } on Exception catch (e) {
          log("⚠️ Failed to re-register device after login: $e");
          // Don't fail login if device registration fails - user can still use app
        }
        
        // OTP flow: Prefer in-memory redirection (passed through navigation) over LocalStorage
        // LocalStorage might have stale data from previous social media login attempt
        InAppRedirection? restoredRedirection = redirection;
        log("ℹ️ OTP Flow - In-memory redirection: ${redirection?.runtimeType ?? 'null'}");
        
        // Clear any stale pending redirection from LocalStorage (from previous social login)
        try {
          final String? staleRedirection = localStorageService.getString(
            LocalStorageKeys.pendingRedirection,
          );
          if (staleRedirection != null) {
            await localStorageService.remove(LocalStorageKeys.pendingRedirection);
            log("🗑️ Cleared stale pending redirection from previous session");
          }
        } on Exception catch (e) {
          log("⚠️ Failed to clear stale redirection: $e");
        }
        
        log("📍 OTP Flow - Final redirection to use: ${restoredRedirection?.runtimeType ?? 'null (will go to home page)'}");
        
        String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
        analyticsService.logEvent(
          event: AnalyticEvent.loginSuccess(
            utm: utm,
            platform: Platform.isAndroid ? "Android" : "iOS",
          ),
        );
        await navigateToHomePager(redirection: restoredRedirection);
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
        username: username ?? "",
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
    
    // Clear any previous error message when new code is entered
    _errorMessage = "";
    notifyListeners();
    
    // Auto-trigger verification when all 6 digits are entered
    if (verificationCode.length == otpCount) {
      log("✅ All 6 OTP digits entered - auto-triggering verification");
      await verifyButtonTapped();
    }
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
