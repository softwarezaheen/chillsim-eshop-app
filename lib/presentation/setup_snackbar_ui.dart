import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/enums/snackbar_type.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

void setupSnackbarUi() {
  // Registers a config to be used when calling showSnackbar
  locator<SnackbarService>()
    ..registerSnackbarConfig(
      SnackbarConfig(
        backgroundColor: Colors.red,
        mainButtonTextColor: Colors.black,
      ),
    )
    ..registerCustomSnackbarConfig(
      variant: SnackbarType.blueAndYellow,
      config: SnackbarConfig(
        backgroundColor: Colors.blueAccent,
        textColor: Colors.yellow,
        borderRadius: 1,
        dismissDirection: DismissDirection.horizontal,
      ),
    )
    ..registerCustomSnackbarConfig(
      variant: SnackbarType.greenAndRed,
      config: SnackbarConfig(
        backgroundColor: Colors.white,
        titleColor: Colors.green,
        messageColor: Colors.red,
        borderRadius: 1,
      ),
    );
}
