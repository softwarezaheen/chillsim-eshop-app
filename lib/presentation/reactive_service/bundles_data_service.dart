import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/extensions/string_extensions.dart";
import "package:stacked/stacked.dart";

class BundleServicesStreamModel {
  BundleServicesStreamModel({
    required this.homeData,
    required this.shouldRenderShimmer,
  });
  final bool shouldRenderShimmer;
  final Resource<HomeDataResponseModel> homeData;
}

class BundlesDataService with ListenableServiceMixin {
  BundlesDataService() {
    // Listen to all reactive values
    listenToReactiveValues(<ReactiveValue<dynamic>>[
      _homeData,
      _globalBundles,
      _cruiseBundles,
      _countries,
      _regions,
      _isLoading,
      _hasError,
      _errorMessage,
    ]);

    // Initialize data
    unawaited(_initializeData());
  }

  final ApiBundlesRepository _apiBundlesRepository =
      locator<ApiBundlesRepository>();

  // Stream subscription - MUST be canceled to prevent memory leak and rebuild loops
  StreamSubscription<BundleServicesStreamModel>? _homeDataStreamSubscription;

  // Reactive values
  final ReactiveValue<HomeDataResponseModel?> _homeData =
      ReactiveValue<HomeDataResponseModel?>(null);
  final ReactiveValue<List<BundleResponseModel>?> _globalBundles =
      ReactiveValue<List<BundleResponseModel>?>(null);
  final ReactiveValue<List<BundleResponseModel>?> _cruiseBundles =
      ReactiveValue<List<BundleResponseModel>?>(null);
  final ReactiveValue<List<CountryResponseModel>?> _countries =
      ReactiveValue<List<CountryResponseModel>?>(null);
  final ReactiveValue<List<RegionsResponseModel>?> _regions =
      ReactiveValue<List<RegionsResponseModel>?>(null);
  final ReactiveValue<bool> _isLoading = ReactiveValue<bool>(false);
  final ReactiveValue<bool> _hasError = ReactiveValue<bool>(false);
  final ReactiveValue<String?> _errorMessage = ReactiveValue<String?>(null);

  // Getters
  HomeDataResponseModel? get homeData => _homeData.value;

  List<BundleResponseModel>? get globalBundles => _globalBundles.value;

  List<BundleResponseModel>? get cruiseBundles => _cruiseBundles.value;

  List<CountryResponseModel>? get countries => _countries.value;

  List<RegionsResponseModel>? get regions => _regions.value;

  bool get isBundleServicesLoading => _isLoading.value;

  bool get hasError => _hasError.value;

  String? get errorMessage => _errorMessage.value;

  // Initialize data
  Future<void> _initializeData({
    bool isFromRefresh = false,
  }) async {
    try {
      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = null;
      notifyListeners();

      Future<HomeDataVersionResult> version = _fetchHomeDataVersion();

      // CRITICAL FIX: Cancel old subscription before creating new one
      // This prevents memory leaks and infinite rebuild loops
      await _homeDataStreamSubscription?.cancel();
      _homeDataStreamSubscription = _apiBundlesRepository.homeDataStream.listen(
        (BundleServicesStreamModel streamResponse) {
          if (streamResponse.shouldRenderShimmer) {
            _isLoading.value = true;
            notifyListeners();
            return;
          }
          if (streamResponse.homeData.resourceType == ResourceType.success) {
            unawaited(_updateData(streamResponse.homeData.data));
            return;
          } else if (streamResponse.homeData.resourceType ==
              ResourceType.error) {
            _hasError.value = true;
            _errorMessage.value = streamResponse.homeData.message;
          }
          _isLoading.value = false;
          notifyListeners();
        },
        onError: (dynamic error) {
          _hasError.value = true;
          _errorMessage.value = error.toString();
          _isLoading.value = false;
          notifyListeners();
        },
      );

      _apiBundlesRepository.getHomeData(
        version: version,
        isFromRefresh: isFromRefresh,
      );
      // Listen to updates from HomeDataService
    } on Error catch (e) {
      _hasError.value = true;
      _errorMessage.value = e.toString();
      _isLoading.value = false;
    }
  }

  Future<void> _updateData(HomeDataResponseModel? data) async {
    log("Updating data: ${data?.toJson()}");
    _isLoading.value = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 500));
    _homeData.value = data;
    _globalBundles.value = data?.globalBundles;
    _cruiseBundles.value = data?.cruiseBundles;
    _countries.value = data?.countries;
    _regions.value = data?.regions;
    _isLoading.value = false;
    notifyListeners();
  }

  // Convenience methods
  List<BundleResponseModel>? getBundlesByCountry(String iso3Code) {
    return _globalBundles.value
        ?.where(
          (BundleResponseModel bundle) =>
              bundle.countries?.any(
                (CountryResponseModel country) => country.iso3Code == iso3Code,
              ) ??
              false,
        )
        .toList();
  }

  List<BundleResponseModel>? getBundlesByRegion(String regionCode) {
    return _globalBundles.value
        ?.where(
          (BundleResponseModel bundle) =>
              bundle.countries?.any(
                (CountryResponseModel country) =>
                    country.zoneName == regionCode,
              ) ??
              false,
        )
        .toList();
  }

  CountryResponseModel? getCountryByCode(String iso3Code) {
    return _countries.value?.firstWhere(
      (CountryResponseModel country) => country.iso3Code == iso3Code,
    );
  }

  RegionsResponseModel? getRegionByCode(String regionCode) {
    return _regions.value?.firstWhere(
      (RegionsResponseModel region) => region.regionCode == regionCode,
    );
  }

  // Data refresh methods
  Future<void> refreshData() async {
    log("App refreshing started - checking for updates");
    
    // IMPORTANT: Always fetch fresh config from server to check for version changes
    // This is NOT cached - it makes a network call every time
    await locator<AppConfigurationService>().getAppConfigurations();
    
    // Fetch the latest bundle version from server
    final HomeDataVersionResult version = await _fetchHomeDataVersion();
    
    // Get the currently cached version (includes currency and language)
    String cachedVersion = _homeData.value?.version ?? "";
    
    // Build the version string to compare (catalog version + currency + language)
    String versionToCheck = version.version.appendAppCurrency.appendAppLanguage;

    log("Version check - Cached: $cachedVersion, Server: $versionToCheck");

    // Only refresh if version has changed OR if we have no data yet
    if (cachedVersion == versionToCheck && version.version.isNotEmpty && _homeData.value != null) {
      log("Version unchanged - skipping refresh");
      return;
    }

    // If already loading, don't start another load
    if (_isLoading.value) {
      log("Already loading - skipping duplicate refresh");
      return;
    }

    log("Version changed or no data - triggering refresh");
    _initializeData(isFromRefresh: true);
  }

  Future<void> clearData() async {
    await _apiBundlesRepository.clearCache();
    _homeData.value = null;
    _globalBundles.value = null;
    _cruiseBundles.value = null;
    _countries.value = null;
    _regions.value = null;
    _hasError.value = false;
    _errorMessage.value = null;
    notifyListeners();
  }

  Future<HomeDataVersionResult> _fetchHomeDataVersion() async {
    try {
      String version =
          await locator<AppConfigurationService>().getCatalogVersion;

      if (version.isNotEmpty) {
        return HomeDataVersionResult(version: version);
      }
    } on Object catch (e) {
      log("Error fetching HomeData Version: $e");
      return HomeDataVersionResult(
        version: "",
        isSuccess: false,
        errorMessage: e.toString(),
      );
    }

    return HomeDataVersionResult(
      version: "",
      isSuccess: false,
    );
  }

  // Dispose method to clean up subscriptions and prevent memory leaks
  void dispose() {
    _homeDataStreamSubscription?.cancel();
  }
}

class HomeDataVersionResult {
  HomeDataVersionResult({
    required this.version,
    this.isSuccess = true,
    this.errorMessage,
  });

  final String version;
  final bool isSuccess;
  final String? errorMessage;
}
