import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";
import "package:esim_open_source/presentation/extensions/navigation_service_extensions.dart";

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
  CashbackReward() : super(<NavigationServiceRoute>[]);
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
  CountrySelected(this.countryModel) : super(<NavigationServiceRoute>[]);
  final CountryResponseModel countryModel;
}

class RegionSelected extends RedirectionCategoryType {
  RegionSelected(this.regionModel) : super(<NavigationServiceRoute>[]);
  final RegionsResponseModel regionModel;
}

abstract class RedirectionsHandlerService {
  Future<void> handleInitialRedirection(void Function() callBack);

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
    required String iccid,
    required String category,
    required bool isUnlimitedData,
  });
}
