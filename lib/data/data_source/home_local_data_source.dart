// repositories/home_data_repository.dart
import "package:esim_open_source/data/data_source/home_data_entities/bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/bundle_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/bundle_type.dart";
import "package:esim_open_source/data/data_source/home_data_entities/country_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/home_data_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/region_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";
import "package:esim_open_source/objectbox.g.dart";

class HomeLocalDataSource {
  HomeLocalDataSource(this._store)
      : _homeDataBox = _store.box<HomeDataEntity>(),
        _countryBox = _store.box<CountryEntity>(),
        _bundleCategoryBox = _store.box<BundleCategoryEntity>();
  final Store _store;
  final Box<HomeDataEntity> _homeDataBox;
  final Box<CountryEntity> _countryBox;
  final Box<BundleCategoryEntity> _bundleCategoryBox;

  Future<void> saveHomeData(HomeDataResponseModel data) async {
    _store.runInTransaction(TxMode.write, () {
      final HomeDataEntity homeData =
          HomeDataEntity(lastUpdated: DateTime.now())
            //save version
            ..version = data.version;

      // Save regions
      if (data.regions != null) {
        for (final RegionsResponseModel region in data.regions!) {
          final RegionEntity regionEntity = RegionEntity.fromModel(region);
          homeData.regions.add(regionEntity);
        }
      }

      // Save countries
      if (data.countries != null) {
        for (final CountryResponseModel country in data.countries!) {
          final CountryEntity countryEntity = CountryEntity.fromModel(country);
          homeData.countries.add(countryEntity);
        }
      }

      // Save global bundles
      if (data.globalBundles != null) {
        for (final BundleResponseModel bundle in data.globalBundles!) {
          final BundleEntity bundleEntity =
              BundleEntity.fromModel(bundle, BundleType.global);

          // Save bundle category if exists
          if (bundle.bundleCategory != null) {
            final BundleCategoryEntity categoryEntity =
                BundleCategoryEntity.fromModel(bundle.bundleCategory!);
            _bundleCategoryBox.put(categoryEntity);
            bundleEntity.bundleCategory.target = categoryEntity;
          }

          // Link countries
          if (bundle.countries != null) {
            for (final CountryResponseModel country in bundle.countries!) {
              final CountryEntity countryEntity = _findOrCreateCountry(country);
              bundleEntity.countries.add(countryEntity);
            }
          }

          homeData.bundles.add(bundleEntity);
        }
      }

      // Save cruise bundles
      if (data.cruiseBundles != null) {
        for (final BundleResponseModel bundle in data.cruiseBundles!) {
          final BundleEntity bundleEntity =
              BundleEntity.fromModel(bundle, BundleType.cruise);

          // Save bundle category if exists
          if (bundle.bundleCategory != null) {
            final BundleCategoryEntity categoryEntity =
                BundleCategoryEntity.fromModel(bundle.bundleCategory!);
            _bundleCategoryBox.put(categoryEntity);
            bundleEntity.bundleCategory.target = categoryEntity;
          }

          // Link countries
          if (bundle.countries != null) {
            for (final CountryResponseModel country in bundle.countries!) {
              final CountryEntity countryEntity = _findOrCreateCountry(country);
              bundleEntity.countries.add(countryEntity);
            }
          }

          homeData.bundles.add(bundleEntity);
        }
      }

      _homeDataBox.put(homeData);
    });
  }

  CountryEntity _findOrCreateCountry(CountryResponseModel country) {
    final CountryEntity? existingCountry = _countryBox
        .query(CountryEntity_.iso3Code.equals(country.iso3Code ?? ""))
        .build()
        .findFirst();

    if (existingCountry != null) {
      return existingCountry;
    }

    final CountryEntity newCountry = CountryEntity.fromModel(country);
    _countryBox.put(newCountry);
    return newCountry;
  }

  HomeDataResponseModel? getHomeData() {
    final HomeDataEntity? homeData = _homeDataBox
        .query()
        .order(HomeDataEntity_.lastUpdated, flags: Order.descending)
        .build()
        .findFirst();

    return homeData?.toModel();
  }

  Future<void> clearCache() async {
    _store.runInTransaction(TxMode.write, () {
      _homeDataBox.removeAll();
      _countryBox.removeAll();
      _bundleCategoryBox.removeAll();
    });
  }
}
