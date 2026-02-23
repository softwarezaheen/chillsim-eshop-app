import "dart:async";

import "package:esim_open_source/data/remote/apis/affiliates/api_affiliates.dart";
import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/data/api_affiliate.dart";

class APIAffiliateImpl extends APIService implements ApiAffiliate {
  APIAffiliateImpl.privateConstructor() : super.privateConstructor();

  @override
  FutureOr<ResponseMain<EmptyResponse?>> trackAffiliateClick({
    required String clickId,
  }) async {
    Map<String, dynamic> params = <String, dynamic>{
      "identifier": clickId,
    };

    ResponseMain<EmptyResponse?> response = await sendRequest(
      endPoint: createAPIEndpoint(
        endPoint: AffiliateApis.trackAffiliateClick,
        parameters: params,
      ),
      fromJson: EmptyResponse.fromJson,
    );
    return response;
  }
}
