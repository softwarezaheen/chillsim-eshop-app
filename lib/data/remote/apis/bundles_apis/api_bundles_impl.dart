import "dart:async";

import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/bundles_apis/bundles_apis.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_consumption_response.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/home_data_response_model.dart";
import "package:esim_open_source/domain/data/api_bundles.dart";

class APIBundlesImpl extends APIService implements APIBundles {
  APIBundlesImpl._privateConstructor() : super.privateConstructor();

  static APIBundlesImpl? _instance;

  static APIBundlesImpl get instance {
    if (_instance == null) {
      _instance = APIBundlesImpl._privateConstructor();
      _instance?._initialise();
    }
    return _instance!;
  }

  void _initialise() {}

  @override
  FutureOr<ResponseMain<BundleConsumptionResponse>> getBundleConsumption({
    required String iccID,
  }) async {
    ResponseMain<BundleConsumptionResponse> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundleConsumption,
        paramIDs: <String>[iccID],
      ),
      fromJson: BundleConsumptionResponse.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<HomeDataResponseModel>> getAllData() async {
    ResponseMain<HomeDataResponseModel> homeDataResponse = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getAllData,
      ),
      fromJson: HomeDataResponseModel.fromAPIJson,
    );

    return homeDataResponse;
  }

  @override
  FutureOr<ResponseMain<List<BundleResponseModel>>> getAllBundles() async {
    ResponseMain<List<BundleResponseModel>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundles,
      ),
      fromJson: BundleResponseModel.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<BundleResponseModel>> getBundle({
    required String code,
  }) async {
    ResponseMain<BundleResponseModel> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundle,
        paramIDs: <String>[code],
      ),
      fromJson: BundleResponseModel.fromJson,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<BundleResponseModel>>> getBundlesByRegion({
    required String regionCode,
  }) async {
    ResponseMain<List<BundleResponseModel>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundlesByRegion,
        paramIDs: <String>[regionCode],
      ),
      fromJson: BundleResponseModel.fromJsonList,
    );
    return response;
  }

  @override
  FutureOr<ResponseMain<List<BundleResponseModel>>> getBundlesByCountries({
    required String countryCodes,
  }) async {
    ResponseMain<List<BundleResponseModel>> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: BundlesApis.getBundlesByCountries,
        queryParameters: <String, String>{"country_codes": countryCodes},
      ),
      fromJson: BundleResponseModel.fromJsonList,
    );
    return response;
  }
}
