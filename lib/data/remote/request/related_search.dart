class RelatedSearchRequestModel {
  RelatedSearchRequestModel({
    this.region,
    this.countries,
  });

  RegionRequestModel? region;
  List<CountriesRequestModel>? countries;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "region": region?.toJson(),
      "countries": countries
          ?.map((CountriesRequestModel country) => country.toJson())
          .toList(),
    };
  }
}

class RegionRequestModel {
  RegionRequestModel({
    this.isoCode,
    this.regionName,
  });

  String? isoCode;
  String? regionName;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "iso_code": isoCode,
      "region_name": regionName,
    };
  }
}

class CountriesRequestModel {
  CountriesRequestModel({
    this.isoCode,
    this.countryName,
  });

  String? isoCode;
  String? countryName;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "iso3_code": isoCode,
      "country_name": countryName,
    };
  }
}
