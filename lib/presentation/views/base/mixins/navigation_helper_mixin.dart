import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_model.dart";
import "package:stacked/stacked.dart";
import "package:stacked_services/stacked_services.dart";

mixin NavigationHelperMixin on BaseViewModel {
  NavigationService get navigationService => locator<NavigationService>();

  Future<void> navigateToHomePager<T>({InAppRedirection? redirection}) async {
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
  }
}
