import "dart:developer" as dev;

import "package:esim_open_source/data/services/consent_initializer.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";

mixin NavigationHelperMixin on BaseViewModel {
  NavigationService get navigationService => locator<NavigationService>();

  Future<void> navigateToHomePager<T>({InAppRedirection? redirection, BuildContext? context}) async {
    DataPlansViewModel.tabBarSelectedIndex = 0;
    DataPlansViewModel.cruiseTabBarSelectedIndex = 0;
    locator
      ..resetLazySingleton(instance: locator<MyESimViewModel>())
      ..resetLazySingleton(instance: locator<ProfileViewModel>())
      ..resetLazySingleton(instance: locator<HomePagerViewModel>())
      ..resetLazySingleton(instance: locator<DataPlansViewModel>());
    await navigationService.pushNamedAndRemoveUntil(
      HomePager.routeName,
      arguments: redirection,
    );
    
    // Show consent dialog after navigation if needed (with longer delay for stability)
    if (context != null) {
      Future<void>.delayed(const Duration(milliseconds: 1000), () async {
        if (context.mounted) {
          try {
            await ConsentInitializer.showConsentDialogIfNeeded(context);
          } on Object catch (e) {
            dev.log("ConsentInitializer: Error showing consent dialog: $e");
          }
        } else {
          dev.log("ConsentInitializer: Context not available for consent dialog");
        }
      });
    }
  }
}
