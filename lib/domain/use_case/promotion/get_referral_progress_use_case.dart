import "dart:async";

import "package:esim_open_source/data/remote/responses/promotion/referral_progress_response_model.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetReferralProgressUseCase
    implements UseCase<Resource<ReferralProgressResponseModel?>, NoParams> {
  GetReferralProgressUseCase(this.repository);

  final ApiPromotionRepository repository;

  @override
  FutureOr<Resource<ReferralProgressResponseModel?>> execute(
    NoParams params,
  ) async {
    return await repository.getReferralProgress();
  }
}
