import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/auto_topup_config_response_model.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/flutter_channel_handler_service.dart";
import "package:esim_open_source/domain/use_case/auth/update_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/shared/validation_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/file_helper.dart";
import "package:esim_open_source/utils/image_helper.dart";
import "package:flutter/material.dart";

class PurchaseOrderSuccessViewModel extends BaseModel {
  PurchaseOrderSuccessViewModel({required this.purchaseESimBundle});

  //#region UseCases

  //#endregion

  //#region Variables
  final PurchaseEsimBundleResponseModel? purchaseESimBundle;
  final PurchaseOrderSuccessState _state = PurchaseOrderSuccessState();

  PurchaseOrderSuccessState get state => _state;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    unawaited(initState());
  }

  Future<void> initState() async {
    _state
      ..smDpAddress = purchaseESimBundle?.smdpAddress ?? ""
      ..activationCode = purchaseESimBundle?.activationCode ?? ""
      ..showInstallButton = await isInstallButtonEnabled()
      ..showGoToMyEsimButton = isUserLoggedIn
      ..isUpdatingConsent = false
      ..showMarketingWidget = !isNewsletterSubscribed
      ..showAutoTopupPrompt =
          isUserLoggedIn &&
          (purchaseESimBundle?.isTopupAllowed ?? false) &&
          !(purchaseESimBundle?.unlimited ?? false)
      ..autoTopupEnabled = purchaseESimBundle?.autoTopupEnabled ?? false
      ..autoTopupBundleName = purchaseESimBundle?.displayTitle ?? "";
    notifyListeners();
  }

  Future<void> onBackPressed() async {
    navigationService.clearTillFirstAndShow(HomePager.routeName);
  }

  Future<void> copyToClipboard(String text) async {
    if (isBusy) {
      return;
    }
    copyText(text);
  }

  Future<void> openAndroidEsimSettings() async {
    try {
      await locator<FlutterChannelHandlerService>().openSimProfilesSettings();
    } on Object catch (ex) {
      showNativeErrorMessage("", ex.toString().replaceAll("Exception:", ""));
    }
  }

  Future<void> onShareClick() async {
    String path = await captureImage(
      globalKey: state.globalKey,
      fileName: state.smDpAddress,
    );
    shareImage(imagePath: path);
  }

  Future<void> onDownloadClick() async {
    String path = await captureImage(
      globalKey: state.globalKey,
      fileName: state.smDpAddress,
    );
    saveImageToGallery(
      imagePath: path,
      toastMessage: LocaleKeys.qr_code_saved.tr(),
    );
  }

  //#endregion

  //#region Apis

  //#endregion

  void onUserGuideClick() {
    unawaited(navigationService.navigateTo(UserGuideView.routeName));
  }

  Future<void> onGotoMyESimClick() async {
    locator<HomePagerViewModel>().changeSelectedTabIndex(index: 1);
    navigationService.clearTillFirstAndShow(HomePager.routeName);
  }

  Future<void> onInstallClick() async {
    try {
      if (Platform.isAndroid) {
        // unawaited(
        await locator<FlutterChannelHandlerService>().openEsimSetupForAndroid(
          smdpAddress: _state.smDpAddress,
          activationCode: _state.activationCode,
          // ),
        );
      } else {
        // unawaited(
        await locator<FlutterChannelHandlerService>().openEsimSetupForIOS(
          smdpAddress: _state.smDpAddress,
          activationCode: _state.activationCode,
          //   ),
        );
      }
    } on Object catch (ex) {
      showNativeErrorMessage("", ex.toString().replaceAll("Exception:", ""));
    }
  }

  /// Disable auto top-up for the purchased eSIM
  Future<void> onDisableAutoTopup() async {
    if (_state.isDisablingAutoTopup) {
      return;
    }
    final String? iccid = purchaseESimBundle?.iccid;
    if (iccid == null) {
      return;
    }
    _state.isDisablingAutoTopup = true;
    notifyListeners();
    final Resource<dynamic> response =
        await locator<ApiUserRepository>().disableAutoTopup(
      iccid: iccid,
    );
    await handleResponse(
      response,
      onSuccess: (Resource<dynamic> result) async {
        _state.autoTopupEnabled = false;
        await showToast(LocaleKeys.auto_topup_disable_success.tr());
      },
      onFailure: (Resource<dynamic> result) async {
        showNativeErrorMessage(
          "",
          LocaleKeys.auto_topup_disable_error.tr(),
        );
      },
    );
    _state.isDisablingAutoTopup = false;
    notifyListeners();
  }

  /// Enable auto top-up for the purchased eSIM
  Future<void> onEnableAutoTopup() async {
    if (_state.isEnablingAutoTopup) {
      return;
    }
    final String? iccid = purchaseESimBundle?.iccid;
    final String? bundleCode = purchaseESimBundle?.bundleCode;
    if (iccid == null || bundleCode == null) {
      return;
    }
    _state.isEnablingAutoTopup = true;
    notifyListeners();
    final Resource<AutoTopupConfigResponseModel?> response =
        await locator<ApiUserRepository>().enableAutoTopup(
      iccid: iccid,
      bundleCode: bundleCode,
      userProfileId: purchaseESimBundle?.userProfileId,
    );
    await handleResponse(
      response,
      onSuccess: (Resource<AutoTopupConfigResponseModel?> result) async {
        _state.autoTopupEnabled = true;
        await showToast(LocaleKeys.auto_topup_enabled_success.tr());
      },
      onFailure: (Resource<AutoTopupConfigResponseModel?> result) async {
        showNativeErrorMessage(
          "",
          LocaleKeys.auto_topup_enable_error.tr(),
        );
      },
    );
    _state.isEnablingAutoTopup = false;
    notifyListeners();
  }

  /// Handle marketing consent toggle
  Future<void> onMarketingConsentToggle(bool value) async {
    if (_state.isUpdatingConsent) {
      return;
    }

    _state.isUpdatingConsent = true;
    notifyListeners();

    try {
      final Resource<AuthResponseModel> response = await UpdateUserInfoUseCase(locator<ApiAuthRepository>()).execute(
        UpdateUserInfoParams(
          email: userEmailAddress,
          msisdn: userMsisdn,
          firstName: userFirstName,
          lastName: userLastName,
          isNewsletterSubscribed: value,
        ),
      );

      await handleResponse(
        response,
        onSuccess: (Resource<AuthResponseModel> result) async {
          // Update only user info while preserving access/refresh tokens
          await userAuthenticationService.updateUserResponse(result.data);
          
          await showToast(
            value
                ? LocaleKeys.marketing_consent_enabled_success.tr()
                : LocaleKeys.marketing_consent_disabled_success.tr(),
          );
        },
        onFailure: (Resource<AuthResponseModel> result) async {
          showNativeErrorMessage("", LocaleKeys.marketing_consent_update_failed.tr());
        },
      );
    } catch (e) {
      showNativeErrorMessage("", LocaleKeys.marketing_consent_update_failed.tr());
    } finally {
      _state.isUpdatingConsent = false;
      notifyListeners();
    }
  }
}

class PurchaseOrderSuccessState {
  String smDpAddress = "";
  String activationCode = "";
  bool showInstallButton = false;
  bool showGoToMyEsimButton = false;
  bool isUpdatingConsent = false;
  bool showMarketingWidget = false;
  bool showAutoTopupPrompt = false;
  bool isEnablingAutoTopup = false;
  bool isDisablingAutoTopup = false;
  bool autoTopupEnabled = false;
  String autoTopupBundleName = "";
  GlobalKey globalKey = GlobalKey();

  String get qrCodeValue => "LPA:1\$$smDpAddress\$$activationCode";
}
