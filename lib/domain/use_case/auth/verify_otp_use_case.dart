import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_app_repository.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_device_repository.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/app/add_device_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/apply_referral_code_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";

class VerifyOtpParams {
  VerifyOtpParams({
    this.username = "",
    this.pinCode = "",
    this.providerToken = "",
    this.providerType = "",
  });

  final String username;
  final String pinCode;
  final String providerType;

  final String providerToken;
}

class VerifyOtpUseCase
    implements UseCase<Resource<AuthResponseModel>, VerifyOtpParams> {
  VerifyOtpUseCase(this.repository);

  final ApiAuthRepository repository;

  final UserAuthenticationService userAuthenticationService =
      locator<UserAuthenticationService>();

  final AddDeviceUseCase addDeviceUseCase = AddDeviceUseCase(
    locator<ApiAppRepository>(),
    locator<ApiDeviceRepository>(),
  );

  final LocalStorageService localStorageService =
      locator<LocalStorageService>();
  final ApplyReferralCodeUseCase applyReferralCodeUseCase =
      ApplyReferralCodeUseCase(
    locator<ApiPromotionRepository>(),
  );

  @override
  FutureOr<Resource<AuthResponseModel>> execute(VerifyOtpParams params) async {
    Resource<AuthResponseModel> response = await repository.verifyOtp(
      email:
          AppEnvironment.appEnvironmentHelper.loginType == LoginType.phoneNumber
              ? null
              : params.username,
      phoneNumber:
          AppEnvironment.appEnvironmentHelper.loginType == LoginType.phoneNumber
              ? params.username
              : null,
      pinCode: params.pinCode,
      providerType: params.providerType,
      providerToken: params.providerToken,
    );
    await userAuthenticationService.saveUserResponse(response.data);
    String referralCode =
        localStorageService.getString(LocalStorageKeys.referralCode) ?? "";
    log("Referral code from otp use case: $referralCode");

    if (referralCode.isNotEmpty) {
      await applyReferralCodeUseCase
          .execute(ApplyReferralCodeUserCaseParams(referralCode: referralCode));
    }
    // Device registration is handled in verify_login_view_model.dart with fresh FCM token
    // Removed duplicate fire-and-forget call here
    return response;
  }
}
