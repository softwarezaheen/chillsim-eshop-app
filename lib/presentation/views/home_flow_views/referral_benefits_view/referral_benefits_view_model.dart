import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/remote/responses/promotion/referral_progress_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/get_referral_progress_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class ReferralBenefitsViewModel extends BaseModel {
  ReferralProgressResponseModel? referralProgress;

  final GetReferralProgressUseCase _getReferralProgressUseCase =
      GetReferralProgressUseCase(locator<ApiPromotionRepository>());

  String get referAndEarnAmount =>
      locator<AppConfigurationService>().referAndEarnAmount;

  String get referredDiscountPercentage =>
      locator<AppConfigurationService>().referredDiscountPercentage;

  int get positionInCycle => referralProgress?.positionInCycle ?? 0;
  int get cycleSize => referralProgress?.cycleSize ?? 10;

  @override
  Future<void> onViewModelReady() async {
    super.onViewModelReady();
    await loadReferralProgress();
  }

  Future<void> loadReferralProgress() async {
    applyShimmer = true;

    final Resource<ReferralProgressResponseModel?> response =
        await _getReferralProgressUseCase.execute(NoParams());

    handleResponse(
      response,
      onSuccess: (Resource<ReferralProgressResponseModel?> result) async {
        referralProgress = result.data;
        notifyListeners();
      },
      onFailure: (Resource<ReferralProgressResponseModel?> result) async {
        log("❌ Failed to load referral progress: ${result.message}");
        notifyListeners();
      },
    );

    applyShimmer = false;
  }

  Future<void> shareReferralCode() async {
    await locator<BottomSheetService>().showCustomSheet(
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.shareReferralCode,
    );
  }
}
