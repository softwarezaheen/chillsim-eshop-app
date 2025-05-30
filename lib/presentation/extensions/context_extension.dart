import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/material.dart";

extension AppColorExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
