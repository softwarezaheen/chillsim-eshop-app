import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/regions_response_model.dart";

class HomeDataResponseModel {
  HomeDataResponseModel({
    this.regions,
    this.countries,
    this.globalBundles,
    this.cruiseBundles,
    this.version,
  });

  // Factory method to create an instance from JSON
  factory HomeDataResponseModel.fromJson(Map<String, dynamic> json) {
    return HomeDataResponseModel(
      regions: json["regions"] != null
          ? (json["regions"] as List<RegionsResponseModel>)
              .map((dynamic item) => RegionsResponseModel.fromJson(item))
              .toList()
          : null,
      countries: json["countries"] != null
          ? (json["countries"] as List<CountryResponseModel>)
              .map((dynamic item) => CountryResponseModel.fromJson(item))
              .toList()
          : null,
      globalBundles: json["global_bundles"] != null
          ? (json["global_bundles"] as List<BundleResponseModel>)
              .map((dynamic item) => BundleResponseModel.fromJson(json: item))
              .toList()
          : null,
      cruiseBundles: json["cruise_bundles"] != null
          ? (json["cruise_bundles"] as List<BundleResponseModel>)
              .map((dynamic item) => BundleResponseModel.fromJson(json: item))
              .toList()
          : null,
    );
  }

  factory HomeDataResponseModel.fromAPIJson({dynamic json}) {
    return HomeDataResponseModel(
      regions: json["regions"] != null
          ? List<RegionsResponseModel>.from(
              json["regions"]
                  .map((dynamic item) => RegionsResponseModel.fromJson(item)),
            )
          : null,
      countries: json["countries"] != null
          ? List<CountryResponseModel>.from(
              json["countries"]
                  .map((dynamic item) => CountryResponseModel.fromJson(item)),
            )
          : null,
      globalBundles: json["global_bundles"] != null
          ? List<BundleResponseModel>.from(
              json["global_bundles"].map(
                (dynamic item) => BundleResponseModel.fromJson(json: item),
              ),
            )
          : null,
      cruiseBundles: json["cruise_bundles"] != null
          ? List<BundleResponseModel>.from(
              json["cruise_bundles"].map(
                (dynamic item) => BundleResponseModel.fromJson(json: item),
              ),
            )
          : null,
    );
  }

  final List<RegionsResponseModel>? regions;
  final List<CountryResponseModel>? countries;
  final List<BundleResponseModel>? globalBundles;
  final List<BundleResponseModel>? cruiseBundles;
  String? version;

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "version": version,
      "regions":
          regions?.map((RegionsResponseModel item) => item.toJson()).toList(),
      "countries":
          countries?.map((CountryResponseModel item) => item.toJson()).toList(),
      "global_bundles": globalBundles
          ?.map((BundleResponseModel item) => item.toJson())
          .toList(),
      "cruise_bundles": cruiseBundles
          ?.map((BundleResponseModel item) => item.toJson())
          .toList(),
    };
  }
}
