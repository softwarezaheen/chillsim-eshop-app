import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_promotion_repository.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

class ApplyReferralCodeUserCaseParams {
  ApplyReferralCodeUserCaseParams({
    required this.referralCode,
  });

  final String referralCode;
}

class ApplyReferralCodeUseCase
    implements
        UseCase<Resource<EmptyResponse?>, ApplyReferralCodeUserCaseParams> {
  ApplyReferralCodeUseCase(this.repository);

  final ApiPromotionRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(
    ApplyReferralCodeUserCaseParams params,
  ) async {
    Resource<EmptyResponse?> response = await repository.applyReferralCode(
      referralCode: params.referralCode,
    );
    if (response.resourceType == ResourceType.success) {
      locator<LocalStorageService>()
          .setString(LocalStorageKeys.referralCode, "");
    } else {
      log("Show error with text: ${response.message}");
      showToast(
        response.message ?? "Invalid referral code",
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey,
      );
    }
    return response;
  }
}
