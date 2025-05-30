import "dart:collection";
import "dart:developer";

import "package:esim_open_source/di/locator.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";

class CustomRouteObserver extends RouteObserver<Route<dynamic>> {
  final NavigationRouter _navigationRouter = locator<NavigationRouter>();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // if (route is HomePager) {
    // Page was pushed
    // _navigationService.setIsPageVisible(true);
    if (previousRoute != null) {
      _navigationRouter.setIsPageVisible(
        routeName: previousRoute.settings.name,
        value: false,
        notifyChanges: false,
      );
    }
    _navigationRouter.setIsPageVisible(
      routeName: route.settings.name,
      value: true,
      notifyChanges: true,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // if (route is HomePager) {
    //   route.settings.name
    //   // Page was popped
    if (previousRoute != null) {
      _navigationRouter.setIsPageVisible(
        routeName: previousRoute.settings.name,
        value: true,
        notifyChanges: false,
      );
    }
    _navigationRouter.setIsPageVisible(
      routeName: route.settings.name,
      value: false,
      notifyChanges: true,
    );

    // }
  }
}

class NavigationRouter with ListenableServiceMixin {
  final Map<String, bool> _isPageVisibleMap = HashMap<String, bool>();

  bool isPageVisible(String routeName) => _isPageVisibleMap[routeName] ?? false;

  void setIsPageVisible({
    required bool value,
    required bool notifyChanges,
    String? routeName,
  }) {
    if (routeName != null && routeName.isNotEmpty) {
      _isPageVisibleMap[routeName] = value;
      if (notifyChanges) {
        log("Notifying listeners for route: $routeName");
        notifyListeners();
      } // Notify dependents of the change
    }
  }
}
