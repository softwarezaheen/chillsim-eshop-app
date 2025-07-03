import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/auth/social_media_verify_login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";

class LoginViewModel extends BaseModel {
  LoginViewModel({this.redirection});
  final InAppRedirection? redirection;
  final SocialLoginService socialLoginService = locator<SocialLoginService>();

  bool _redirecting = false;

  final SocialMediaVerifyLoginUseCase socialMediaVerifyLoginUseCase =
      SocialMediaVerifyLoginUseCase(locator<ApiAuthRepository>());

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(initializeListener());
  }

  Future<void> initializeListener() async {
    if (!isUserLoggedIn) {
      await socialLoginService.logOut();
    }

    socialLoginService.socialLoginResultStream.listen((SocialLoginResult data) {
      if (_redirecting) {
        return;
      }
      if (data.accessToken.isNotEmpty && data.refreshToken.isNotEmpty) {
        _redirecting = true;
        unawaited(
          validateSignInAndNavigate(
            accessToken: data.accessToken,
            refreshToken: data.refreshToken,
            socialMediaLoginType: data.socialType,
          ),
        );
        return;
      }

      if (data.errorMessage.isNotEmpty) {
        unawaited(
          showNativeErrorMessage(
            "Authentication error",
            data.errorMessage,
          ),
        );
        setViewState(ViewState.idle);
      }
    });
  }

  Future<void> backButtonPressed() async {
    navigationService.back();
  }

  Future<void> navigateToSignInPage() async {
    navigationService.navigateTo(
      ContinueWithEmailView.routeName,
      arguments: redirection,
    );
  }

  Future<void> socialMediaSignInAction(
    SocialMediaLoginType socialMediaLoginType,
  ) async {
    _redirecting = false;
    switch (socialMediaLoginType) {
      case SocialMediaLoginType.apple:
        socialLoginService.signInWithApple();
      case SocialMediaLoginType.google:
        socialLoginService.signInWithGoogle();
      case SocialMediaLoginType.facebook:
        socialLoginService.signInWithFaceBook();
    }
  }

  Future<void> validateSignInAndNavigate({
    required String accessToken,
    required String refreshToken,
    required SocialMediaLoginType socialMediaLoginType,
  }) async {
    if (accessToken.isNotEmpty) {
      await loginUserWithToken(
        accessToken: accessToken,
        refreshToken: refreshToken,
        socialMediaLoginType: socialMediaLoginType,
      );
    } else {
      socialLoginService.logOut();
    }
  }

  Future<void> loginUserWithToken({
    required String accessToken,
    required String refreshToken,
    required SocialMediaLoginType socialMediaLoginType,
  }) async {
    setViewState(ViewState.busy);

    Resource<AuthResponseModel> authResponse =
        await socialMediaVerifyLoginUseCase.execute(
      SocialMediaVerifyLoginParams(
        refreshToken: refreshToken,
        accessToken: accessToken,
      ),
    );

    await handleResponse(
      authResponse,
      onSuccess: (Resource<AuthResponseModel> response) async {
        if (response.data?.accessToken == null ||
            response.data?.refreshToken == null) {
          socialLoginService.logOut();
          return;
        }
        await navigateToHomePager(redirection: redirection);
      },
      onFailure: (Resource<AuthResponseModel> response) async {
        await handleError(response);
        socialLoginService.logOut();
      },
    );

    setViewState(ViewState.idle);
  }
}
