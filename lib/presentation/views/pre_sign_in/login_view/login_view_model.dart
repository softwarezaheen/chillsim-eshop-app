import "dart:async";
import "dart:convert";
import "dart:developer";
import "dart:io";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/auth/social_media_verify_login_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/continue_with_email_view/continue_with_email_view.dart";

class LoginViewModel extends BaseModel {
  LoginViewModel({this.redirection});
  InAppRedirection? redirection;
  final SocialLoginService socialLoginService = locator<SocialLoginService>();

  bool _redirecting = false;

  final SocialMediaVerifyLoginUseCase socialMediaVerifyLoginUseCase =
      SocialMediaVerifyLoginUseCase(locator<ApiAuthRepository>());

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(initializeListener());
    
    // Restore pending redirection if LoginView was recreated after external auth
    // This happens when deep link brings user back to app after Facebook/Apple login
    if (redirection == null) {
      try {
        final String? redirectionJson = localStorageService.getString(
          LocalStorageKeys.pendingRedirection,
        );
        if (redirectionJson != null) {
          redirection = InAppRedirection.fromJson(redirectionJson);
          log("🔄 Restored pending redirection in LoginView after deep link return");
        }
      } catch (e) {
        log("⚠️ Failed to restore pending redirection in onViewModelReady: $e");
      }
    }
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
    // Clear pending redirection if user backs out of login
    // Prevents stale purchase intent from previous session
    try {
      await localStorageService.remove(LocalStorageKeys.pendingRedirection);
      log("🗑️ Cleared pending redirection on back navigation");
    } catch (e) {
      log("⚠️ Failed to clear pending redirection: $e");
    }
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
    
    // Save pending redirection before external auth (Facebook/Apple opens browser)
    // This preserves the purchase flow context when user returns via deep link
    if (redirection != null) {
      try {
        final String redirectionJson = jsonEncode(redirection!.toJson());
        await localStorageService.setString(
          LocalStorageKeys.pendingRedirection,
          redirectionJson,
        );
        log("💾 Saved pending redirection before external auth");
      } catch (e) {
        log("⚠️ Failed to save pending redirection: $e");
      }
    }
    
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
        
        // 🔥 CRITICAL FIX: Re-register device with current FCM token after login
        // This ensures FCM token is updated even when user loses authentication and logs back in
        // Without this, device may have stale/null FCM token if Firebase refreshed it while logged out
        try {
          await addDeviceUseCase.execute(NoParams());
          log("✅ Device re-registered with FCM token after social login");
        } catch (e) {
          log("⚠️ Failed to re-register device after login: $e");
          // Don't fail login if device registration fails - user can still use app
        }
        
        // ALWAYS check LocalStorage for pending redirection after social auth
        // The in-memory redirection parameter may be stale after app went inactive during external auth
        InAppRedirection? restoredRedirection;
        try {
          final String? redirectionJson = localStorageService.getString(
            LocalStorageKeys.pendingRedirection,
          );
          if (redirectionJson != null) {
            restoredRedirection = InAppRedirection.fromJson(redirectionJson);
            await localStorageService.remove(LocalStorageKeys.pendingRedirection);
            log("✅ Restored pending redirection from storage: ${restoredRedirection?.runtimeType}");
          } else {
            log("ℹ️ No pending redirection in storage, using in-memory: ${redirection?.runtimeType}");
            restoredRedirection = redirection;
          }
        } catch (e) {
          log("⚠️ Failed to restore pending redirection: $e, using in-memory fallback");
          restoredRedirection = redirection;
        }
        
        String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
        analyticsService.logEvent(
          event: AnalyticEvent.loginSuccess(
            utm: utm,
            platform: Platform.isAndroid ? "Android" : "iOS",
          ),
        );
        
        // Delay navigation to avoid setState during build
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await navigateToHomePager(redirection: restoredRedirection);
      },
      onFailure: (Resource<AuthResponseModel> response) async {
        await handleError(response);
        socialLoginService.logOut();
      },
    );

    setViewState(ViewState.idle);
  }
}
