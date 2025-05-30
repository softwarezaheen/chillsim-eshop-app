import "package:esim_open_source/data/remote/responses/bundles/bundle_category_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/country_response_model.dart";
import "package:esim_open_source/utils/parsing_helper.dart";

class BundleResponseModel {
  BundleResponseModel({
    this.planType,
    this.activityPolicy,
    this.displayTitle,
    this.displaySubtitle,
    this.bundleCode,
    this.bundleCategory,
    this.bundleMarketingName,
    this.bundleName,
    this.countCountries,
    this.currencyCode,
    this.gprsLimitDisplay,
    this.price,
    this.priceDisplay,
    this.unlimited,
    this.validity,
    this.validityDisplay,
    this.countries,
    this.icon,
  });

  // Factory method to create an instance from JSON
  factory BundleResponseModel.fromJson({dynamic json}) {
    return BundleResponseModel(
      displayTitle: json["display_title"],
      displaySubtitle: json["display_subtitle"],
      bundleCode: json["bundle_code"],
      bundleCategory: json["bundle_category"] != null
          ? BundleCategoryResponseModel.fromJson(json["bundle_category"])
          : null,
      bundleMarketingName: json["bundle_marketing_name"],
      bundleName: json["bundle_name"],
      countCountries: json["count_countries"],
      currencyCode: json["currency_code"],
      gprsLimitDisplay: json["gprs_limit_display"],
      price: (json["price"] as num?)?.toDouble(),
      priceDisplay: json["price_display"],
      unlimited: json["unlimited"],
      validity: json["validity"],
      validityDisplay: json["validity_display"],
      icon: json["icon"],
      countries: json["countries"] != null
          ? List<CountryResponseModel>.from(
              json["countries"]
                  .map((dynamic item) => CountryResponseModel.fromJson(item)),
            )
          : null,
      planType: json["plan_type"],
      activityPolicy: json["activity_policy"],
    );
  }

  final String? displayTitle;
  final String? displaySubtitle;
  final String? bundleCode;
  final BundleCategoryResponseModel? bundleCategory;
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
  final List<CountryResponseModel>? countries;
  final String? planType;
  final String? activityPolicy;

  // Method to convert instance to JSON
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "display_title": displayTitle,
      "display_subtitle": displaySubtitle,
      "bundle_code": bundleCode,
      "bundle_category": bundleCategory?.toJson(),
      "bundle_marketing_name": bundleMarketingName,
      "bundle_name": bundleName,
      "count_countries": countCountries,
      "currency_code": currencyCode,
      "gprs_limit_display": gprsLimitDisplay,
      "price": price,
      "price_display": priceDisplay,
      "unlimited": unlimited,
      "validity": validity,
      "icon": icon,
      "validity_display": validityDisplay,
      "countries":
          countries?.map((CountryResponseModel item) => item.toJson()).toList(),
      "plan_type": planType,
      "activity_policy": activityPolicy,
    };
  }

  static List<BundleResponseModel> fromJsonList({dynamic json}) {
    return fromJsonListTyped(parser: BundleResponseModel.fromJson, json: json);
  }

  static List<BundleResponseModel> getMockGlobalBundles() {
    final List<BundleResponseModel> mockBundles = <BundleResponseModel>[
      BundleResponseModel(
        icon: "https://placehold.co/600x400?bundle=None",
        bundleCategory: BundleCategoryResponseModel(
          type: "GLOBAL",
          code: "fcb21616-daf2-4159-9457-6b27f15a1985",
          title: "Global",
        ),
        displayTitle: "sd",
        displaySubtitle: "sd",
        bundleMarketingName: "sd",
        bundleName: "sd",
        bundleCode: "None",
        countCountries: 1,
        currencyCode: "BYR",
        gprsLimitDisplay: "1 GB",
        price: 15,
        priceDisplay: "15 BYR",
        unlimited: false,
        validity: 1,
        validityDisplay: "1 Day",
        countries: <CountryResponseModel>[
          CountryResponseModel(
            country: "Albania",
            countryCode: "Unknown",
            iso3Code: "ALB",
            icon: "https://flagsapi.com/None/flat/64.png",
            zoneName: "Unknown",
            alternativeCountry: "Albania",
          ),
        ],
        planType: "Data Only",
        activityPolicy:
            "The validity period starts when the eSIM connects to any supported networks.",
      ),
      BundleResponseModel(
        icon: "https://placehold.co/600x400?bundle=None",
        bundleCategory: BundleCategoryResponseModel(
          type: "GLOBAL",
          code: "fcb21616-daf2-4159-9457-6b27f15a1985",
          title: "Global",
        ),
        displayTitle: "Global 1GB 7Days 2026",
        displaySubtitle: "Global 1GB 7Days",
        bundleMarketingName: "Global 1GB 7Days 2026",
        bundleName: "Global 1GB 7Days 2026",
        bundleCode: "None",
        countCountries: 0,
        currencyCode: "USD",
        gprsLimitDisplay: "1 GB",
        price: 1.5,
        priceDisplay: "1.5 USD",
        unlimited: false,
        validity: 1,
        validityDisplay: "1 Day",
        countries: <CountryResponseModel>[],
        planType: "Data Only",
        activityPolicy:
            "The validity period starts when the eSIM connects to any supported networks.",
      ),
      BundleResponseModel(
        icon: "https://placehold.co/600x400?bundle=None",
        bundleCategory: BundleCategoryResponseModel(
          type: "GLOBAL",
          code: "fcb21616-daf2-4159-9457-6b27f15a1985",
          title: "Global",
        ),
        displayTitle: "Global 1GB 7Days 2025",
        displaySubtitle: "Global 1GB 7Days",
        bundleMarketingName: "Global 1GB 7Days 2025",
        bundleName: "Global 1GB 7Days 2025",
        bundleCode: "None",
        countCountries: 0,
        currencyCode: "USD",
        gprsLimitDisplay: "1 GB",
        price: 1.5,
        priceDisplay: "1.5 USD",
        unlimited: false,
        validity: 1,
        validityDisplay: "1 Day",
        countries: <CountryResponseModel>[],
        planType: "Data Only",
        activityPolicy:
            "The validity period starts when the eSIM connects to any supported networks.",
      ),
      BundleResponseModel(
        icon: "https://placehold.co/600x400?bundle=None",
        bundleCategory: BundleCategoryResponseModel(
          type: "GLOBAL",
          code: "fcb21616-daf2-4159-9457-6b27f15a1985",
          title: "Global",
        ),
        displayTitle: "Global 1GB 7Days",
        displaySubtitle: "Global 1GB 7Days",
        bundleMarketingName: "Global 1GB 7Days",
        bundleName: "Global 1GB 7Days",
        bundleCode: "None",
        countCountries: 2,
        currencyCode: "USD",
        gprsLimitDisplay: "1 GB",
        price: 1.5,
        priceDisplay: "1.5 USD",
        unlimited: false,
        validity: 1,
        validityDisplay: "1 Day",
        countries: <CountryResponseModel>[
          CountryResponseModel(
            country: "France",
            countryCode: "Unknown",
            iso3Code: "FRA",
            icon: "https://flagsapi.com/None/flat/64.png",
            zoneName: "Unknown",
            alternativeCountry: "France",
          ),
          CountryResponseModel(
            country: "Turkey",
            countryCode: "Unknown",
            iso3Code: "TUR",
            icon: "https://flagsapi.com/None/flat/64.png",
            zoneName: "Unknown",
            alternativeCountry: "Türkiye",
          ),
        ],
        planType: "Data Only",
        activityPolicy:
            "The validity period starts when the eSIM connects to any supported networks.",
      ),
      BundleResponseModel(
        icon: "https://placehold.co/600x400?bundle=None",
        bundleCategory: BundleCategoryResponseModel(
          type: "GLOBAL",
          code: "fcb21616-daf2-4159-9457-6b27f15a1985",
          title: "Global",
        ),
        displayTitle: "Global 1GB 7Days",
        displaySubtitle: "Global 1GB 7Days",
        bundleMarketingName: "Global 1GB 7Days",
        bundleName: "Global 1GB 7Days",
        bundleCode: "None",
        countCountries: 0,
        currencyCode: "USD",
        gprsLimitDisplay: "1 GB",
        price: 3,
        priceDisplay: "3 USD",
        unlimited: false,
        validity: 1,
        validityDisplay: "1 Day",
        countries: <CountryResponseModel>[],
        planType: "Data Only",
        activityPolicy:
            "The validity period starts when the eSIM connects to any supported networks.",
      ),
    ];

    return mockBundles;
  }
}
