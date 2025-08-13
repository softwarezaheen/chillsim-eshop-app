import "package:esim_open_source/presentation/extensions/navigation_service_extensions.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";

sealed class RedirectionCategoryType {
  const RedirectionCategoryType(this.routes);

  final List<NavigationServiceRoute> routes;
}

// Notifications
class Empty extends RedirectionCategoryType {
  Empty() : super(<NavigationServiceRoute>[]);
}

class BuyBundle extends RedirectionCategoryType {
  BuyBundle() : super(<NavigationServiceRoute>[]);
}

class BuyTopUp extends RedirectionCategoryType {
  BuyTopUp() : super(<NavigationServiceRoute>[]);
}

class RewardAvailable extends RedirectionCategoryType {
  RewardAvailable() : super(<NavigationServiceRoute>[]);
}

class CashbackReward extends RedirectionCategoryType {
  CashbackReward(this.cashbackReward) : super(<NavigationServiceRoute>[]);
  final String cashbackReward;
}

class ConsumptionBundleDetail extends RedirectionCategoryType {
  ConsumptionBundleDetail(this.iccid) : super(<NavigationServiceRoute>[]);
  final String iccid;
}

class PlanStarted extends RedirectionCategoryType {
  PlanStarted() : super(<NavigationServiceRoute>[]);
}

class ShareBundleNotification extends RedirectionCategoryType {
  ShareBundleNotification() : super(<NavigationServiceRoute>[]);
}

class WalletTopUpSuccess extends RedirectionCategoryType {
  WalletTopUpSuccess() : super(<NavigationServiceRoute>[]);
}

class WalletTopUpFailed extends RedirectionCategoryType {
  WalletTopUpFailed() : super(<NavigationServiceRoute>[]);
}

// Deep Links
class CountriesTap extends RedirectionCategoryType {
  CountriesTap() : super(<NavigationServiceRoute>[]);
}

class RegionsTap extends RedirectionCategoryType {
  RegionsTap() : super(<NavigationServiceRoute>[]);
}

class ReferAndEarn extends RedirectionCategoryType {
  ReferAndEarn() : super(<NavigationServiceRoute>[]);
}

class CountrySelected extends RedirectionCategoryType {
  CountrySelected(this.countryCode) : super(<NavigationServiceRoute>[]);
  final String countryCode;
}

class RegionSelected extends RedirectionCategoryType {
  RegionSelected(this.regionCode) : super(<NavigationServiceRoute>[]);
  final String regionCode;
}

// enum InAppRedirection {
//   cashback,
//   referral;
//
//   String get routeName => StoryViewer.routeName;
//
//   dynamic get arguments {
//     switch (this) {
//       case InAppRedirection.cashback:
//         return CashbackStoriesView().storyViewerArgs;
//       case InAppRedirection.referral:
//         return ReferalStoriesView().storyViewerArgs;
//     }
//   }
// }

abstract class RedirectionsHandlerService {
  Future<void> handleInitialRedirection(void Function() callBack);

  void redirectToRoute({
    required InAppRedirection redirection,
  });

  void serialiseAndRedirectNotification({
    required bool isClicked,
    required bool isInitial,
    Map<String, dynamic>? handlePushData,
  });

  void serialiseAndRedirectDeepLink({
    required bool isInitial,
    required Uri uriDeepLinkData,
  });

  void notificationInboxRedirections({
    required String iccID,
    required String category,
    required bool isUnlimitedData,
  });
}
