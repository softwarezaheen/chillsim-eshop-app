import "package:esim_open_source/data/data_source/home_data_entities/bundle_type.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_bundle_category_entity.dart";
import "package:esim_open_source/data/data_source/my_esim_entities/esim_country_entity.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:objectbox/objectbox.dart";

@Entity()
class EsimBundleEntity {
  // enum for global/cruise bundles

  EsimBundleEntity({
    required this.displayTitle,
    required this.displaySubtitle,
    required this.bundleCode,
    required this.bundleMarketingName,
    required this.bundleName,
    required this.countCountries,
    required this.currencyCode,
    required this.gprsLimitDisplay,
    required this.price,
    required this.priceDisplay,
    required this.unlimited,
    required this.validity,
    required this.validityDisplay,
    required this.bundleTypeValue,
    required this.icon,
    required this.planType,
    required this.activityPolicy,
  });

  factory EsimBundleEntity.fromModel(
    BundleResponseModel model,
    BundleType type,
  ) {
    return EsimBundleEntity(
      icon: model.icon,
      displayTitle: model.displayTitle,
      displaySubtitle: model.displaySubtitle,
      bundleCode: model.bundleCode,
      bundleMarketingName: model.bundleMarketingName,
      bundleName: model.bundleName,
      countCountries: model.countCountries,
      currencyCode: model.currencyCode,
      gprsLimitDisplay: model.gprsLimitDisplay,
      price: model.price,
      priceDisplay: model.priceDisplay,
      unlimited: model.unlimited,
      validity: model.validity,
      validityDisplay: model.validityDisplay,
      bundleTypeValue: type.index,
      planType: model.planType,
      activityPolicy: model.activityPolicy,
    );
  }

  @Id()
  int id = 0;

  final String? displayTitle;
  final String? displaySubtitle;
  final String? bundleCode;
  final String? bundleMarketingName;
  final String? bundleName;
  final int? countCountries;
  final String? currencyCode;
  final String? gprsLimitDisplay;
  final double? price;
  final String? priceDisplay;
  final bool? unlimited;
  final int? validity;
  final String? validityDisplay;
  final String? icon;
  final String? planType;
  final String? activityPolicy;

  final ToOne<EsimBundleCategoryEntity> bundleCategory =
      ToOne<EsimBundleCategoryEntity>();
  final ToMany<EsimCountryEntity> countries = ToMany<EsimCountryEntity>();

  @Property(type: PropertyType.byte)
  int bundleTypeValue = 0; // Default to global (0)

  // Getter and setter for BundleType
  BundleType get bundleType => BundleType.values[bundleTypeValue];

  set bundleType(BundleType type) => bundleTypeValue = type.index;

  BundleResponseModel toModel() {
    return BundleResponseModel(
      icon: icon,
      displayTitle: displayTitle,
      displaySubtitle: displaySubtitle,
      bundleCode: bundleCode,
      bundleMarketingName: bundleMarketingName,
      bundleName: bundleName,
      countCountries: countCountries,
      currencyCode: currencyCode,
      gprsLimitDisplay: gprsLimitDisplay,
      price: price,
      priceDisplay: priceDisplay,
      unlimited: unlimited,
      validity: validity,
      validityDisplay: validityDisplay,
      bundleCategory: bundleCategory.target?.toModel(),
      countries: countries.map((EsimCountryEntity c) => c.toModel()).toList(),
      activityPolicy: activityPolicy,
      planType: planType,
    );
  }
}
