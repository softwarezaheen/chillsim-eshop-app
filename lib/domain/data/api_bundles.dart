import "dart:async";

abstract interface class APIBundles {

  FutureOr<dynamic> getBundleConsumption({
    required String iccID,
  });

  FutureOr<dynamic> getAllData();

  FutureOr<dynamic> getBundle({required String code});

  FutureOr<dynamic> getAllBundles();

  FutureOr<dynamic> getBundlesByRegion({required String regionCode});

  FutureOr<dynamic> getBundlesByCountries({required String countryCodes});
}
