import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/enums/dialog_icon_type.dart";
import "package:esim_open_source/presentation/enums/dialog_type.dart";
import "package:esim_open_source/presentation/setup_dialog_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";

mixin DialogUtilitiesMixin on BaseViewModel {
  DialogService get dialogService => locator<DialogService>();
  SnackbarService get snackBarService => locator<SnackbarService>();
  BottomSheetService get bottomSheetService => locator<BottomSheetService>();

  Future<DialogResponse<MainDialogResponse>?> showErrorMessageDialog(
    String? message, {
    TextStyle? descriptionTextStyle,
    String? cancelText,
    DialogIconType? iconType,
  }) {
    return dialogService.showCustomDialog(
      variant: DialogType.basic,
      barrierDismissible: true,
      data: MainDialogRequest(
        descriptionTextStyle: descriptionTextStyle,
        informativeOnly: true,
        description: message,
        dismissibleDialog: true,
        cancelText: cancelText,
        iconType: iconType ?? DialogIconType.warning,
      ),
    );
  }

  Future<void> showErrorDialogWithRetry({
    String? title,
    String? message,
    required VoidCallback onRetry,
  }) async {
    final DialogResponse<MainDialogResponse>? result =
        await dialogService.showCustomDialog(
      variant: DialogType.basic,
      barrierDismissible: true,
      data: MainDialogRequest(
        title: title,
        description: message,
        iconType: DialogIconType.warning,
        mainButtonTitle: LocaleKeys.action_retry.tr(),
        mainButtonTag: "retry",
        cancelText: LocaleKeys.action_dismiss.tr(),
        showCancelButton: true,
        dismissibleDialog: true,
      ),
    );

    // If user clicked Retry button, execute callback
    if (result?.data?.tag == "retry" && result?.data?.canceled == false) {
      onRetry();
    }
  }

  Future<void> showNativeErrorMessage(
    String? titleMessage,
    String? contentMessage,
  ) async {
    if (Platform.isIOS) {
      await dialogService.showDialog(
        title: titleMessage ?? "Error",
        description: contentMessage ?? "Please try again",
      );
    } else {
      await showToast(
        contentMessage ?? "Error",
      );
    }
  }

  bool isKeyboardVisible(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return isKeyboardVisible;
  }

  Future<String?> listenForSMS() async {
    return null;
  }

  Future<void> stopSmsListener() async {
    // return AndroidSmsRetriever.stopSmsListener();
  }

  // Static to prevent multiple dialogs from different ViewModels
  static BuildContext? _dialogContext;

  Future<void> showNoConnectionDialog(String routeName) async {
    // Use static guard to ensure only ONE dialog shows across all ViewModels
    if (StackedService.navigatorKey?.currentContext != null &&
        _dialogContext == null) {
      _dialogContext = StackedService.navigatorKey?.currentContext;

      await showNativeDialog(
        context: _dialogContext!,
        titleText: LocaleKeys.noConnection_titleText.tr(),
        contentText: LocaleKeys.noConnection_contentText.tr(),
        buttons: <NativeButtonParams>[
          NativeButtonParams(
            buttonTitle: LocaleKeys.noConnection_buttonTitleText.tr(),
            buttonAction: () {
              _dialogContext = null;
              Navigator.pop(
                StackedService.navigatorKey!.currentContext!,
              );
            },
          ),
        ],
      );
    }
  }

  void closeConnectionDialog() {
    if (_dialogContext != null) {
      Navigator.pop(_dialogContext!);
      _dialogContext = null;
    }
  }
}
