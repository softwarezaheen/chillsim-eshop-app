class RegionsResponseModel {
  RegionsResponseModel({
    this.icon,
    this.zoneName,
    this.regionCode,
    this.regionName,
  });
  // Factory method to create an instance from a JSON map
  factory RegionsResponseModel.fromJson(Map<String, dynamic> json) {
    return RegionsResponseModel(
      regionCode: json["region_code"],
      regionName: json["region_name"],
      zoneName: json["zone_name"],
      icon: json["icon"],
    );
  }

  final String? icon;
  final String? zoneName;
  final String? regionCode;
  final String? regionName;

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      "region_code": regionCode,
      "region_name": regionName,
      "zone_name": zoneName,
      "icon": icon,
    };
  }

  static List<RegionsResponseModel> getMockRegions() {
    return <RegionsResponseModel>[
      RegionsResponseModel(
        regionName: "GLOBAL",
        zoneName: "GLOBAL",
        regionCode: "29b0bf21-0861-4222-839c-0da178a6371c",
        icon: "https://placehold.co/400x400",
      ),
      RegionsResponseModel(
        regionName: "ZONE_TEST_11",
        zoneName: "zone test 11",
        regionCode: "639d0e67-129d-4291-bc02-3db4b43924fd",
        icon: "https://placehold.co/400x400",
      ),
      RegionsResponseModel(
        regionName: "ZONE_TESTTT3",
        zoneName: "zone testtt3",
        regionCode: "a4172519-470b-4465-a146-36f44e5383c2",
        icon: "https://placehold.co/400x400",
      ),
      RegionsResponseModel(
        regionName: "EUROPE",
        zoneName: "Europe",
        regionCode: "742bb566-517f-e311-93f4-80ee7353f479",
        icon: "https://placehold.co/400x400",
      ),
    ];
  }
}
