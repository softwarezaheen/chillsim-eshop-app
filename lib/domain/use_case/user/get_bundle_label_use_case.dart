import "dart:async";

import "package:esim_open_source/data/remote/responses/empty_response.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";

class GetBundleLabelUseCase
    implements UseCase<Resource<EmptyResponse?>, BundleLabelParams> {
  GetBundleLabelUseCase(this.repository);

  final ApiUserRepository repository;

  @override
  FutureOr<Resource<EmptyResponse?>> execute(BundleLabelParams params) async {
    return await repository.getBundleLabel(
      code: params.code,
      label: params.label,
    );
  }
}

class BundleLabelParams {
  BundleLabelParams({required this.code, required this.label});

  final String code;
  final String label;
}
