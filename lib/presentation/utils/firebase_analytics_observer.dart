// Copyright 2021 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import "dart:async";
import "dart:developer";

import "package:flutter/services.dart";
import "package:flutter/widgets.dart";

/// Signature for a function that extracts a screen name from [RouteSettings].
///
/// Usually, the route name is not a plain string, and it may contains some
/// unique ids that makes it difficult to aggregate over them in Firebase
/// Analytics.
typedef ScreenNameExtractor = String? Function(RouteSettings settings);

String? defaultNameExtractor(RouteSettings settings) => settings.name;

/// [RouteFilter] allows to filter out routes that should not be tracked.
///
/// By default, only [PageRoute]s are tracked.
typedef RouteFilter = bool Function(Route<dynamic>? route);

bool defaultRouteFilter(Route<dynamic>? route) => route is PageRoute;

/// A [NavigatorObserver] that sends events to Firebase Analytics when the
/// currently active [ModalRoute] changes.
///
/// When a route is pushed or popped, and if [routeFilter] is true,
/// [nameExtractor] is used to extract a name  from [RouteSettings] of the now
/// active route and that name is sent to Firebase.
///
/// The following operations will result in sending a screen view event:
/// ```dart
/// Navigator.pushNamed(context, '/contact/123');
///
/// Navigator.push<void>(context, MaterialPageRoute(
///   settings: RouteSettings(name: '/contact/123'),
///   builder: (_) => ContactDetail(123)));
///
/// Navigator.pushReplacement<void>(context, MaterialPageRoute(
///   settings: RouteSettings(name: '/contact/123'),
///   builder: (_) => ContactDetail(123)));
///
/// Navigator.pop(context);
/// ```
///
/// To use it, add it to the `navigatorObservers` of your [Navigator], e.g. if
/// you're using a [MaterialApp]:
/// ```dart
/// MaterialApp(
///   home: MyAppHome(),
///   navigatorObservers: [
///     FirebaseAnalyticsObserver(analytics: service.analytics),
///   ],
/// );
/// ```
///
/// You can also track screen views within your [ModalRoute] by implementing
/// [RouteAware<ModalRoute<dynamic>>] and subscribing it to [FirebaseAnalyticsObserver]. See the
/// [RouteObserver<ModalRoute<dynamic>>] docs for an example.
///
typedef FirebaseAnalyticsFunction = Future<void> Function({
  required String screenName,
});

class FirebaseAnalyticsObserver extends RouteObserver<ModalRoute<dynamic>> {
  /// Creates a [NavigatorObserver] that sends events to [FirebaseAnalytics].
  ///
  /// When a route is pushed or popped, [nameExtractor] is used to extract a
  /// name from [RouteSettings] of the now active route and that name is sent to
  /// Firebase. Defaults to `defaultNameExtractor`.
  ///
  /// If a [PlatformException] is thrown while the observer attempts to send the
  /// active route to [analytics], `onError` will be called with the
  /// exception. If `onError` is omitted, the exception will be printed using
  /// `log()`.
  ///

  FirebaseAnalyticsObserver({
    required this.setScreenName,
    this.nameExtractor = defaultNameExtractor,
    this.routeFilter = defaultRouteFilter,
    Function(PlatformException error)? onError,
  }) : _onError = onError;

  // final FirebaseAnalytics analytics;
  final FirebaseAnalyticsFunction setScreenName;
  final ScreenNameExtractor nameExtractor;
  final RouteFilter routeFilter;
  final void Function(PlatformException error)? _onError;

  Future<void> _sendScreenView(Route<dynamic> route) async {
    final String? screenName = nameExtractor(route.settings);
    if (screenName != null) {
      unawaited(
        setScreenName(screenName: screenName).catchError(
          (Object error) {
            final void Function(PlatformException error)? onError = _onError;
            if (onError == null) {
              log("$FirebaseAnalyticsObserver: $error");
            } else {
              onError(error as PlatformException);
            }
          },
          test: (Object error) => error is PlatformException,
        ),
      );

      // analytics.setCurrentScreen(screenName: screenName).catchError(
      //   (Object error) {
      //     final _onError = this._onError;
      //     if (_onError == null) {
      //       log('$FirebaseAnalyticsObserver: $error');
      //     } else {
      //       _onError(error as PlatformException);
      //     }
      //   },
      //   test: (Object error) => error is PlatformException,
      // );
    }
  }

  @override
  Future<void> didPush(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) async {
    super.didPush(route, previousRoute);
    if (routeFilter(route)) {
      unawaited(_sendScreenView(route));
    }
  }

  @override
  Future<void> didReplace({
    Route<dynamic>? newRoute,
    Route<dynamic>? oldRoute,
  }) async {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null && routeFilter(newRoute)) {
      unawaited(_sendScreenView(newRoute));
    }
  }

  @override
  Future<void> didPop(
    Route<dynamic> route,
    Route<dynamic>? previousRoute,
  ) async {
    super.didPop(route, previousRoute);
    if (previousRoute != null &&
        routeFilter(previousRoute) &&
        routeFilter(route)) {
      unawaited(_sendScreenView(previousRoute));
    }
  }
}
