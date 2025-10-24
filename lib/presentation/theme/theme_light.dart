import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/material.dart";

ThemeData get themeLight => ThemeData(
      colorScheme:
          ColorScheme.fromSwatch(backgroundColor: Colors.white).copyWith(),
      extensions: <ThemeExtension<AppColors>>[AppColors.lightThemeColors],
      fontFamily: AppEnvironment.appEnvironmentHelper.environmentFamilyName,
      listTileTheme: const ListTileThemeData(
        selectedTileColor: Colors.transparent,
        selectedColor: Colors.black87,
        textColor: Color(0XFF122544), // baseBlack
      ),
    );
