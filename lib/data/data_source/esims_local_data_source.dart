// repositories/home_data_repository.dart
import "dart:developer";

import "package:esim_open_source/data/data_source/home_data_entities/bundle_type.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_country_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/transaction_history_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/transaction_history_response_model.dart";
import "package:esim_open_source/objectbox.g.dart";

class EsimsLocalDataSource {
  EsimsLocalDataSource(this._store)
      : _esimBox = _store.box<EsimEntity>(),
        _countryBox = _store.box<EsimCountryEntity>(),
        _bundleCategoryBox = _store.box<EsimBundleCategoryEntity>();

  final Store _store;
  final Box<EsimEntity> _esimBox;
  final Box<EsimCountryEntity> _countryBox;
  final Box<EsimBundleCategoryEntity> _bundleCategoryBox;

  Future<void> replacePurchasedEsims(
    List<PurchaseEsimBundleResponseModel>? dataList,
  ) async {
    if (dataList == null) {
      return;
    }
    clearCache();
    _store.runInTransaction(TxMode.write, () {
      for (final PurchaseEsimBundleResponseModel data in dataList) {
        final EsimEntity esimData = EsimEntity.fromModel(data);

        // Save bundle category
        if (data.bundleCategory != null) {
          final EsimBundleCategoryEntity categoryEntity =
              EsimBundleCategoryEntity.fromModel(data.bundleCategory!);
          esimData.bundleCategory.target = categoryEntity;
        }

        // Save countries
        if (data.countries != null) {
          for (final CountryResponseModel country in data.countries!) {
            final EsimCountryEntity countryEntity =
                EsimCountryEntity.fromModel(country);
            esimData.countries.add(countryEntity);
          }
        }

        // Save transactions history
        if (data.transactionHistory != null) {
          for (final TransactionHistoryResponseModel transaction
              in data.transactionHistory!) {
            final TransactionHistoryEntity transactionHistoryEntity =
                TransactionHistoryEntity.fromModel(transaction);

            if (transaction.bundle != null) {
              final EsimBundleEntity bundleEntity = EsimBundleEntity.fromModel(
                transaction.bundle!,
                BundleType.global,
              );

              // Save bundle category if exists
              if (transaction.bundle?.bundleCategory != null) {
                final EsimBundleCategoryEntity categoryEntity =
                    EsimBundleCategoryEntity.fromModel(
                  transaction.bundle!.bundleCategory!,
                );
                _bundleCategoryBox.put(categoryEntity);
                bundleEntity.bundleCategory.target = categoryEntity;
              }

              // Link countries
              if (transaction.bundle!.countries != null) {
                for (final CountryResponseModel country
                    in transaction.bundle!.countries!) {
                  final EsimCountryEntity countryEntity =
                      _findOrCreateCountry(country);
                  bundleEntity.countries.add(countryEntity);
                }
              }

              transactionHistoryEntity.bundle.target = bundleEntity;
            }

            esimData.transactionHistory.add(transactionHistoryEntity);
          }
        }

        _esimBox.put(esimData);
      }
    });

    log("Purchased Esim Saved to db");
  }

  EsimCountryEntity _findOrCreateCountry(CountryResponseModel country) {
    final EsimCountryEntity? existingCountry = _countryBox
        .query(EsimCountryEntity_.iso3Code.equals(country.iso3Code ?? ""))
        .build()
        .findFirst();

    if (existingCountry != null) {
      return existingCountry;
    }

    final EsimCountryEntity newCountry = EsimCountryEntity.fromModel(country);
    _countryBox.put(newCountry);
    return newCountry;
  }

  List<PurchaseEsimBundleResponseModel>? getPurchasedEsims() {
    final List<EsimEntity> esimData = _esimBox.query().build().find();
    log("Purchased Esim from db count ${esimData.length}");
    return esimData.map((EsimEntity esim) => esim.toModel()).toList();
  }

  Future<void> clearCache() async {
    _store.runInTransaction(TxMode.write, () {
      _esimBox.removeAll();
      _countryBox.removeAll();
      _bundleCategoryBox.removeAll();
    });
  }
}
