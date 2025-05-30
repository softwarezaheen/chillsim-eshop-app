import "package:esim_open_source/data/data_source/home_data_entities/bundle_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/bundle_type.dart";
import "package:esim_open_source/data/data_source/home_data_entities/country_entity.dart";
import "package:esim_open_source/data/data_source/home_data_entities/region_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class HomeDataEntity {
  HomeDataEntity({
    this.lastUpdated,
  });

  factory HomeDataEntity.fromModel() {
    final HomeDataEntity entity = HomeDataEntity(
      lastUpdated: DateTime.now(),
    );
    return entity;
  }

  @Id()
  int id = 0;

  String? version;

  DateTime? lastUpdated;

  final ToMany<RegionEntity> regions = ToMany<RegionEntity>();
  final ToMany<CountryEntity> countries = ToMany<CountryEntity>();
  @Backlink("homeData")
  final ToMany<BundleEntity> bundles = ToMany<BundleEntity>();

  HomeDataResponseModel toModel() {
    return HomeDataResponseModel(
      version: version,
      regions: regions.map((RegionEntity r) => r.toModel()).toList(),
      countries: countries.map((CountryEntity c) => c.toModel()).toList(),
      globalBundles: bundles
          .where((BundleEntity b) => b.bundleType == BundleType.global)
          .map((BundleEntity b) => b.toModel())
          .toList(),
      cruiseBundles: bundles
          .where((BundleEntity b) => b.bundleType == BundleType.cruise)
          .map((BundleEntity b) => b.toModel())
          .toList(),
    );
  }
}
