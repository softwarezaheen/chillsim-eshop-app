import "dart:developer";

import "package:app_links/app_links.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/domain/repository/services/redirections_handler_service.dart";

enum DeepLinkDecodeKeys {
  referralCode;

  String get referralCodePathKey {
    switch (this) {
      case DeepLinkDecodeKeys.referralCode:
        return "referral";
    }
  }
}

class DeepLinkHandler {
  final String tag = "DeepLinkHandler";
  DeepLinkHandler._initialize({required this.redirectionsHandlerService});
  static DeepLinkHandler shared = DeepLinkHandler._initialize(
    redirectionsHandlerService: locator<RedirectionsHandlerService>(),
  );

  final AppLinks _appLinks = AppLinks();

  final RedirectionsHandlerService redirectionsHandlerService;

  Future<void> init(
    Function({
      required Uri uri,
      required bool isInitial,
    }) onDeepLink,
  ) async {
    // Handle cold start
    try {
      log("$tag | init: start");
      final Uri? initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        onDeepLink(uri: initialLink, isInitial: true);
      }
    } on Object catch (e) {
      log("$tag | init: Failed to get initial deep link: $e");
    }

    // Handle resumed app
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        onDeepLink(uri: uri, isInitial: false);
      }
    });
  }

  void handleDeepLink({
    required Uri uri,
    required bool isInitial,
  }) {
    log("Received deep link: $uri");
    log("Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}, QueryParams: ${uri.query}.");
    redirectionsHandlerService.serialiseAndRedirectDeepLink(
      isInitial: isInitial,
      uriDeepLinkData: uri,
    );
  }
}
