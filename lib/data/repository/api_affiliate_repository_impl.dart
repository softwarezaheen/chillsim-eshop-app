import 'dart:async';

import "package:esim_open_source/domain/data/api_affiliate.dart";
import "package:esim_open_source/domain/repository/api_affiliate_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";

class ApiAffiliateRepositoryImpl implements ApiAffiliateRepository {
  ApiAffiliateRepositoryImpl({required this.apiAffiliate});

  final ApiAffiliate apiAffiliate;

  @override
  FutureOr<dynamic> trackAffiliateClick({required String clickId}) {
    return responseToResource(apiAffiliate.trackAffiliateClick(clickId: clickId));
  }
}
