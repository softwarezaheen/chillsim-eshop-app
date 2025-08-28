import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/services/connectivity_service_impl.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/connectivity_service.dart";
import "package:esim_open_source/presentation/extensions/stacked_services/custom_route_observer.dart";
import "package:esim_open_source/presentation/reactive_service/user_authentication_service.dart";
import "package:esim_open_source/presentation/views/base/mixins/dialog_utilities_mixin.dart";
import "package:esim_open_source/presentation/views/base/mixins/navigation_helper_mixin.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:stacked/stacked.dart";

mixin ConnectivityHandlerMixin on BaseViewModel implements ConnectionListener {
  ConnectivityService get connectivityService => locator<ConnectivityService>();
  NavigationRouter get navigationRouter => locator<NavigationRouter>();
  UserAuthenticationService get userAuthenticationService => 
      locator<UserAuthenticationService>();

  String routeName = "";

  bool get isUserLoggedIn => userAuthenticationService.isUserLoggedIn;

  void onViewModelReady() {
    log("ViewModel $runtimeType Ready");
    navigationRouter.addListener(_onViewDidAppearHandler);
    if (navigationRouter.isPageVisible(routeName)) {
      _onViewDidAppearHandler();
    }
  }

  void _onViewDidAppearHandler() {
    if (navigationRouter.isPageVisible(routeName)) {
      log("ViewModel: onViewDidAppear $runtimeType");
      onViewDidAppear();
    }
  }

  void onViewDidAppear() {
    connectivityService.addListener(this);
    unawaited(onConnectivityChangedUpdate());
  }

  void onDispose() {
    log("ViewModel $runtimeType Disposed");
    navigationRouter.removeListener(_onViewDidAppearHandler);
  }

  @override
  void dispose() {
    connectivityService.removeListener(this);
    super.dispose();
  }

  @override
  Future<void> onConnectivityChanged({required bool connected}) async {
    if (connected) {
      locator<HomePagerViewModel>().lockTabBar = false;
      if (this is DialogUtilitiesMixin) {
        (this as DialogUtilitiesMixin).closeConnectionDialog();
      }
    } else {
      if (this is NavigationHelperMixin) {
        await (this as NavigationHelperMixin).navigationService
            .clearTillFirstAndShow(HomePager.routeName);
      }

      int? index = locator<HomePagerViewModel>().getSelectedTabIndex();
      if (index == 1 && isUserLoggedIn) {
        locator<HomePagerViewModel>().lockTabBar = true;
        return;
      }

      if (navigationRouter.isPageVisible(routeName)) {
        log("Pop displayed by: $routeName");
        if (this is DialogUtilitiesMixin) {
          (this as DialogUtilitiesMixin).showNoConnectionDialog(routeName);
        }
      }
    }
  }

  Future<void> onConnectivityChangedUpdate() async {
    await onConnectivityChanged(connected: await connectivityService.isConnected());
  }
}
