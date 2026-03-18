import "dart:async";
import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/services/consent_initializer.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/repository/services/device_info_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/repository/services/push_notification_service.dart";
import "package:esim_open_source/domain/repository/services/remote_config_service.dart";
import "package:esim_open_source/domain/repository/services/social_login_service.dart";
import "package:esim_open_source/domain/use_case/auth/refresh_token_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/force_update/force_update_view.dart";
import "package:esim_open_source/presentation/views/pre_sign_in/device_compability_check_view/device_compability_check_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:package_info_plus/package_info_plus.dart";

class StartUpViewModel extends BaseModel {
  final RefreshTokenUseCase refreshTokenUseCase =
      RefreshTokenUseCase(locator<ApiAuthRepository>());
  final PushNotificationService pushNotificationService =
      locator<PushNotificationService>();

  Future<void> handleStartUpLogic(BuildContext context) async {
    unawaited(_initializePushServices());

    unawaited(_initializeConfigurations());

    setViewState(ViewState.busy);

    await Future<void>.delayed(const Duration(seconds: 2));

    // Check for a required update before anything else.
    // Shows a non-dismissible dialog and blocks further startup if outdated.
    if (context.mounted && await _checkForceUpdate(context)) {
      return;
    }

    if (Environment.isProdEnv) {
      log("Running on prod env checking device compatible");
      if (context.mounted && await checkIfDeviceCompatible(context)) {
        return;
      }
    }

    if (isUserLoggedIn) {
      unawaited(refreshTokenTrigger());
    }

    // Show consent dialog if needed before handling initial redirections
    await ConsentInitializer.showConsentDialogIfNeeded(context);

    redirectionsHandlerService.handleInitialRedirection(getInitialRoute);
  }

  /// Returns true if a force update dialog was shown (startup should stop).
  Future<bool> _checkForceUpdate(BuildContext context) async {
    try {
      final RemoteConfigService remoteConfig = locator<RemoteConfigService>();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // Build number check (primary — simpler, always monotonically increasing)
      final int minimumBuild = await remoteConfig.minimumRequiredBuildNumber;
      final int currentBuild = int.tryParse(packageInfo.buildNumber) ?? 0;
      if (minimumBuild > 0 && currentBuild < minimumBuild) {
        log("Force update required: build $currentBuild < minimum $minimumBuild");
        if (!context.mounted) return false;
        await _showForceUpdateDialog(context, packageInfo.packageName);
        return true;
      }

      // Version name check (fallback — e.g. "1.2.0")
      final String minimumVersion = await remoteConfig.minimumRequiredVersion;
      if (minimumVersion.isEmpty) return false;
      if (!_isVersionLessThan(packageInfo.version, minimumVersion)) {
        return false;
      }

      log("Force update required: version ${packageInfo.version} < minimum $minimumVersion");

      if (!context.mounted) return false;

      await _showForceUpdateDialog(context, packageInfo.packageName);
      return true;
    } catch (e) {
      log("Force update check failed: $e");
      return false;
    }
  }

  Future<void> _showForceUpdateDialog(BuildContext context, String packageName) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => ForceUpdateView(packageName: packageName),
      transitionBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        );
      },
    );
  }

  /// Returns true if [current] is strictly less than [minimum] (semver comparison).
  bool _isVersionLessThan(String current, String minimum) {
    final List<int> c =
        current.split(".").map((String s) => int.tryParse(s) ?? 0).toList();
    final List<int> m =
        minimum.split(".").map((String s) => int.tryParse(s) ?? 0).toList();
    final int length = m.length > c.length ? m.length : c.length;
    for (int i = 0; i < length; i++) {
      final int cv = i < c.length ? c[i] : 0;
      final int mv = i < m.length ? m[i] : 0;
      if (cv < mv) return true;
      if (cv > mv) return false;
    }
    return false;
  }

  @visibleForTesting
  Future<void> showDeviceCompromisedDialog(BuildContext context) async {
    if (context.mounted) {
      showNativeDialog(
        context: context,
        titleText: LocaleKeys.device_security_notice_title.tr(),
        contentText: LocaleKeys.device_security_notice_message.tr(),
      );
    }
  }

  //Tested
  Future<bool> checkIfDeviceCompatible(BuildContext context) async {
    // TODO: TEMPORARY - re-enable device security check before next production release
    // return false;

    // ignore: dead_code
    DeviceInfoService deviceInfo = locator<DeviceInfoService>();
    if (await deviceInfo.isRooted ||
        await deviceInfo.isDevelopmentModeEnable ||
        !await deviceInfo.isPhysicalDevice) {
      log("Device compromised");
      if (context.mounted) {
        showDeviceCompromisedDialog(context);
        return true;
      }
    }
    return false;
  }

  Future<void> getInitialRoute() async {
    if (Platform.isAndroid &&
        !(localStorageService.getBool(LocalStorageKeys.hasPreviouslyStarted) ??
            false)) {
      navigationService.navigateTo(DeviceCompabilityCheckView.routeName);
      return;
    }
    if (AppEnvironment.isFromAppClip) {
      navigationService.replaceWith(AppClipSelectionView.routeName);
      return;
    }
    navigateToHomePager();
  }

  //Tested
  Future<void> refreshTokenTrigger() async {
    setViewState(ViewState.busy);

    try {
      Resource<AuthResponseModel> response =
          await refreshTokenUseCase.execute(NoParams());

      switch (response.resourceType) {
        case ResourceType.success:
          setViewState(ViewState.idle);

        case ResourceType.error:
          // await showErrorMessageDialog(
          //   response.error?.message,
          //   iconType: DialogIconType.warningRed,
          //   cancelText: LocaleKeys.ok.tr(),
          // );
          setViewState(ViewState.idle);
        //await navigationService.replaceWith(ContinueWithEmailView.routeName);
        case ResourceType.loading:
          setViewState(ViewState.busy);
      }
    } on Exception catch (e) {
      log(e.toString());
      // await navigationService.replaceWith(ContinueWithEmailView.routeName);
    }
    setViewState(ViewState.idle);
    //redirectionsHandlerService.handleInitialRedirection(navigateToHomePager);
  }

  Future<void>? _initializeConfigurations() async {
    locator<SocialLoginService>().initialise(
      url: await locator<AppConfigurationService>().getSupabaseUrl,
      anonKey: await locator<AppConfigurationService>().getSupabaseAnon,
    );
  }

  Future<void>? _initializePushServices() async {
    // Get and print the Firebase project settings
    log("Firebase project settings: ${Firebase.app().options}");
    try {
      await pushNotificationService.initialise(
        handlePushData:
            redirectionsHandlerService.serialiseAndRedirectNotification,
      );
      String? fcmToken = await pushNotificationService.getFcmToken();
      
      // Only save FCM token if user granted permission (not null)
      // This prevents storing empty strings that cause "No FCM tokens found" warnings
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await localStorageService.setString(
          LocalStorageKeys.fcmToken,
          fcmToken,
        );
        log("✅ FCM token saved to LocalStorage");
      } else {
        log("⚠️ FCM permission denied or not available - device will not receive push notifications");
      }

      await addDeviceUseCase.execute(NoParams());
    } on Object catch (e) {
      log(e.toString());
    }
  }
}
