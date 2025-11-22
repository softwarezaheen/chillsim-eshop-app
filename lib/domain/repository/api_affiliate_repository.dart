import 'dart:async';

abstract interface class ApiAffiliateRepository {
  FutureOr<dynamic> trackAffiliateClick({required String clickId});
}
