import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/material.dart";

ThemeData get themeDark => ThemeData(
      colorScheme:
          ColorScheme.fromSwatch(backgroundColor: Colors.blue).copyWith(),
      extensions: <ThemeExtension<AppColors>>[AppColors.darkThemeColors],
      fontFamily: AppEnvironment.appEnvironmentHelper.environmentFamilyName,
      listTileTheme: const ListTileThemeData(
        selectedTileColor: Colors.transparent,
        selectedColor: Color(0XFF122544), // baseBlack - bottom sheet is always white background
        textColor: Color(0XFF122544), // baseBlack - bottom sheet is always white background
      ),
    );
