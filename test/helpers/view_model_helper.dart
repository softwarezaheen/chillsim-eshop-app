import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:mockito/mockito.dart";
import "package:stacked_services/stacked_services.dart";

import "../locator_test.dart";

// ignore_for_file: type=lint
void onViewModelReadyMock({
  String viewName = "",
  bool isConnected = true,
  bool clearTillFirstAndShow = true,
}) {
  when(locator<NavigationRouter>().isPageVisible(viewName)).thenReturn(true);
  when(locator<NavigationRouter>().isPageVisible("")).thenReturn(true);
  when(locator<ConnectivityService>().isConnected())
      .thenAnswer((_) async => isConnected);
  when(locator<NavigationService>().clearTillFirstAndShow(HomePager.routeName))
      .thenAnswer((_) async => clearTillFirstAndShow);
  when(locator<NavigationService>().back()).thenReturn(true);
  when(locator<HomePagerViewModel>().getSelectedTabIndex()).thenReturn(0);
  when(locator<NavigationService>()
          .pushNamedAndRemoveUntil(HomePager.routeName))
      .thenAnswer((_) async => clearTillFirstAndShow);

  // Setup UserGuideDetailedViewModel mock
  // setupUserGuideDetailedViewModelMock();
}

// Empty main function to prevent Flutter test runner from treating this as a test file
void main() {}
