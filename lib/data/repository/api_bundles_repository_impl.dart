import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/data_source/home_local_data_source.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_consumption_response.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model.dart";
import "package:esim_open_source/domain/data/api_bundles.dart";
import "package:esim_open_source/domain/repository/api_bundles_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/extensions/string_extensions.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";

class ApiBundlesRepositoryImpl implements ApiBundlesRepository {
  ApiBundlesRepositoryImpl({
    required HomeLocalDataSource repository,
    required APIBundles apiBundles,
  })  : _repository = repository,
        _apiBundles = apiBundles;

  final HomeLocalDataSource _repository;
  final APIBundles _apiBundles;

  // Stream controller to emit updates
  final StreamController<BundleServicesStreamModel> _homeDataController =
      StreamController<BundleServicesStreamModel>.broadcast();

  @override
  Stream<BundleServicesStreamModel> get homeDataStream =>
      _homeDataController.stream;

  @override
  FutureOr<Resource<BundleConsumptionResponse?>> getBundleConsumption({
    required String iccID,
  }) {
    return responseToResource(
      _apiBundles.getBundleConsumption(iccID: iccID),
    );
  }

  @override
  FutureOr<Stream<BundleServicesStreamModel>> getHomeData({
    required Future<HomeDataVersionResult> version,
    bool forceRefresh = false,
    bool isFromRefresh = false,
  }) async {
    triggerHomeData(
      version: version,
      forceRefresh: forceRefresh,
      isFromRefresh: isFromRefresh,
    );
    return _homeDataController.stream;
  }

  FutureOr<Stream<BundleServicesStreamModel>> triggerHomeData({
    required Future<HomeDataVersionResult> version,
    bool forceRefresh = false,
    bool isFromRefresh = false,
  }) async {
    // First, try to get cached data
    final HomeDataResponseModel? cachedData = _repository.getHomeData();
    if (cachedData != null && !isFromRefresh) {
      _homeDataController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.success(
            cachedData,
            message: null,
          ),
        ),
      );
    }

    String strVersion = "";
    HomeDataVersionResult versionResult = await version;
    if (versionResult.isSuccess) {
      strVersion = versionResult.version;
    }

    // If cache is valid and not forcing refresh, don't fetch new data
    String versionToCheck = strVersion.appendAppCurrency.appendAppLanguage;

    if ((cachedData != null &&
            cachedData.version == versionToCheck &&
            strVersion.isNotEmpty) &&
        !forceRefresh) {
      return _homeDataController.stream;
    }

    // Fetch new data in the background
    _homeDataController.add(
      BundleServicesStreamModel(
        shouldRenderShimmer: true,
        homeData: cachedData == null
            ? Resource<HomeDataResponseModel>.error("No data")
            : Resource<HomeDataResponseModel>.success(
                cachedData,
                message: null,
              ),
      ),
    );
    String newVersion = strVersion.appendAppCurrency.appendAppLanguage;
    _fetchAndUpdateHomeData(_homeDataController, newVersion);

    return _homeDataController.stream;
  }

  Future<void> _fetchAndUpdateHomeData(
    StreamController<BundleServicesStreamModel> controller,
    String version,
  ) async {
    try {
      final ResponseMain<HomeDataResponseModel> response =
          await _apiBundles.getAllData();
      final HomeDataResponseModel newData = response.data..version = version;

      // Save new data
      // final HomeDataResponseModel newData = HomeDataResponseModel(regions: [
      //   RegionsResponseModel(
      //       regionCode: "Tas",
      //       regionName: "ATsia",
      //       zoneName: "Asia-esTim",
      //       icon: "https://plattttcehold.co/120x120"),
      // ], countries: [
      //   CountryResponseModel(
      //       alternativeCountry: "asas,BTN",
      //       country: "Bhutan test 2",
      //       countryCode: "BTN",
      //       iso3Code: "BT",
      //       zoneName: "Bhutan-esim"),
      // ], globalBundles: [
      //   BundleResponseModel(
      //     displayTitle: "Bundle Display Name (Country 3GB)",
      //     displaySubtitle: "Bundle Subtitle Display",
      //     bundleCode: "Country-bundle-084fb2ee-e942-4d9b-8769-184c494ab174",
      //     bundleCategory: BundleCategoryResponseModel(
      //         type: "country", title: "Lebanon", code: "Lb"),
      //     countries: [
      //       CountryResponseModel(
      //         alternativeCountry: "AFG",
      //         country: "Afghanistan",
      //         countryCode: "AFG",
      //         iso3Code: "AF",
      //         zoneName: "Afghanistan-esim",
      //       ),
      //       CountryResponseModel(
      //         alternativeCountry: "asas,BTN",
      //         country: "Bhutan",
      //         countryCode: "BTN",
      //         iso3Code: "BT",
      //         zoneName: "Bhutan-esim",
      //       ),
      //     ],
      //     bundleMarketingName: "Country-bundle 3GB",
      //     bundleName: "Country-bundle 3GB",
      //     countCountries: 147,
      //     currencyCode: "USD",
      //     gprsLimitDisplay: "3 GB",
      //     price: 1.4,
      //     priceDisplay: "USD 1.4",
      //     unlimited: false,
      //     validity: 1,
      //     validityDisplay: "1 Day",
      //   )
      // ]);

      await _repository.saveHomeData(newData);

      // Emit new data as success resource
      _homeDataController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData:
              Resource<HomeDataResponseModel>.success(newData, message: null),
        ),
      );
    } on Error catch (e) {
      // Emit error resource
      _homeDataController.add(
        BundleServicesStreamModel(
          shouldRenderShimmer: false,
          homeData: Resource<HomeDataResponseModel>.error(e.toString()),
        ),
      );
      log("Error fetching new home data: $e");
    }
  }
  //
  // // Update helper methods to work with Resource stream
  // Future<List<BundleResponseModel>?> getGlobalBundles() async {
  //   final Stream<Resource<HomeDataResponseModel>> stream = await getHomeData();
  //   return stream
  //       .where(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.resourceType == ResourceType.success,
  //       )
  //       .map(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.data?.globalBundles,
  //       )
  //       .first;
  // }
  //
  // Future<List<BundleResponseModel>?> getCruiseBundles() async {
  //   final Stream<Resource<HomeDataResponseModel>> stream = await getHomeData();
  //   return stream
  //       .where(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.resourceType == ResourceType.success,
  //       )
  //       .map(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.data?.cruiseBundles,
  //       )
  //       .first;
  // }
  //
  // Future<List<CountryResponseModel>?> getCountries() async {
  //   final Stream<Resource<HomeDataResponseModel>> stream = await getHomeData();
  //   return stream
  //       .where(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.resourceType == ResourceType.success,
  //       )
  //       .map(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.data?.countries,
  //       )
  //       .first;
  // }
  //
  // Future<List<RegionsResponseModel>?> getRegions() async {
  //   final Stream<Resource<HomeDataResponseModel>> stream = await getHomeData();
  //   return stream
  //       .where(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.resourceType == ResourceType.success,
  //       )
  //       .map(
  //         (Resource<HomeDataResponseModel> resource) => resource.data?.regions,
  //       )
  //       .first;
  // }
  //
  // Future<List<BundleResponseModel>?> getBundlesByCountry(
  //   String iso3Code,
  // ) async {
  //   final Stream<Resource<HomeDataResponseModel>> stream = await getHomeData();
  //   return stream
  //       .where(
  //         (Resource<HomeDataResponseModel> resource) => resource.data != null,
  //       )
  //       .map(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.data!.globalBundles
  //                 ?.where(
  //                   (BundleResponseModel bundle) =>
  //                       bundle.countries?.any(
  //                         (CountryResponseModel country) =>
  //                             country.iso3Code == iso3Code,
  //                       ) ??
  //                       false,
  //                 )
  //                 .toList(),
  //       )
  //       .first;
  // }
  //
  // Future<List<BundleResponseModel>?> getLocaleBundleByRegion(
  //   String regionCode,
  // ) async {
  //   final Stream<Resource<HomeDataResponseModel>> stream = await getHomeData();
  //   return stream
  //       .where(
  //         (Resource<HomeDataResponseModel> resource) => resource.data != null,
  //       )
  //       .map(
  //         (Resource<HomeDataResponseModel> resource) =>
  //             resource.data!.globalBundles
  //                 ?.where(
  //                   (BundleResponseModel bundle) =>
  //                       bundle.countries?.any(
  //                         (CountryResponseModel country) =>
  //                             country.zoneName == regionCode,
  //                       ) ??
  //                       false,
  //                 )
  //                 .toList(),
  //       )
  //       .first;
  // }

  @override
  Future<void> clearCache() async {
    await _repository.clearCache();
  }

  @override
  Future<void> dispose() async {
    await _homeDataController.close();
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>>> getAllBundles() async {
    return responseToResource(
      _apiBundles.getAllBundles(),
    );
  }

  @override
  FutureOr<Resource<BundleResponseModel>> getBundle({
    required String code,
  }) async {
    return responseToResource(
      _apiBundles.getBundle(code: code),
    );
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>>> getBundlesByRegion({
    required String regionCode,
  }) async {
    return responseToResource(
      _apiBundles.getBundlesByRegion(regionCode: regionCode),
    );
  }

  @override
  FutureOr<Resource<List<BundleResponseModel>>> getBundlesByCountries({
    required String countryCodes,
  }) async {
    return responseToResource(
      _apiBundles.getBundlesByCountries(countryCodes: countryCodes),
    );
  }
}
