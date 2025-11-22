import 'dart:async';

import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";

abstract interface class ApiAffiliate {
  FutureOr<ResponseMain<EmptyResponse?>> trackAffiliateClick({
    required String clickId,
  });
}
