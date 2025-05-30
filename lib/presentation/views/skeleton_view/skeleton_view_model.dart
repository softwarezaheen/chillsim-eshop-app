import "dart:async";
import "dart:developer";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/apis/api_provider.dart";
import "package:esim_open_source/data/remote/apis/skeleton_apis/skeleton_apis.dart";
import "package:esim_open_source/data/remote/base_api_services.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/skeleton_responses/skeleton_responses.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/use_case/auth/login_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:firebase_core/firebase_core.dart";

class SkeletonViewModel extends BaseModel {
  final LoginUseCase loginUseCase = LoginUseCase(locator<ApiAuthRepository>());
  // final RegisterWithoutMobileNumberUseCase registerWithoutMobileNumberUseCase =
  //     RegisterWithoutMobileNumberUseCase(locator<ApiAuthRepository>());

  String projectID = "";

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    log("viewModel ready");
    log("Running with url: ${BaseApiService.baseURL}");

    getFirebaseID();
  }

  @override
  void onDispose() {
    super.onDispose();
    log("viewModel disposed");
  }

  void getFirebaseID() {
    FirebaseApp app = Firebase.app();
    String projectId = app.options.projectId;
    projectID = projectId;
    notifyListeners();
  }

  Future<void> getFacts() async {
    ResponseMain<FactModel> factResponseMain =
        await APIService.instance.sendRequest(
      endPoint:
          APIService.instance.createAPIEndpoint(endPoint: SkeletonApis.fact),
      fromJson: FactModel.fromJsonDynamic,
    );

    log("success with version");

    Resource<FactModel> response = await responseToResource(factResponseMain);

    switch (response.resourceType) {
      case ResourceType.success:
        log("success with fact ${response.data?.fact}");
      default:
        log("error calling fact func");
    }
  }

  Future<void> getCoins() async {
    Map<String, Object> queryParams = <String, Object>{
      "vs_currency": "usd",
      "order": "market_cap_desc",
      "per_page": 100,
      "page": 1,
      "sparkline": false,
    };

    ResponseMain<List<CoinModel>> coinsResponseMain =
        await APIService.instance.sendRequest(
      endPoint: APIService.instance.createAPIEndpoint(
        endPoint: SkeletonApis.coins,
        queryParameters: queryParams,
      ),
      fromJson: CoinModel.fromJsonList,
    );

    Resource<List<CoinModel>> response =
        await responseToResource(coinsResponseMain);

    switch (response.resourceType) {
      case ResourceType.success:
        log("success with count ${response.data?.length}");
        log(
          "success with last CoinName: ${response.data?.last.coinName}",
        );
        log(
          "success with first CoinName: ${response.data?.first.coinName}",
        );
      default:
        log("error calling coin func");
    }
  }

  Future<void> loginUser() async {
    setViewState(ViewState.busy);
    // Resource<LoginResponse> loginResponse = await loginUseCase.execute(
    //   LoginParams(
    //     email: "nadim.elhaber@gmail.com",
    //   ),
    // );
    //
    // await handleResponse(
    //   loginResponse,
    //   onSuccess: (Resource<LoginResponse> response) async {
    //     log("success with id ${response.data?.clientId}");
    //   },
    // );

    setViewState(ViewState.idle);
  }

  // Future<void> _handleLoginSuccess(Resource<LoginResponse> response) async {}

  Future<void> registerUser() async {
    setViewState(ViewState.busy);

    // RegisterWithoutMobileNumberRequest req = RegisterWithoutMobileNumberRequest(
    //   clientName: "clientName",
    //   password: "password",
    //   typeTag: "BUSINESS",
    //   username: "email",
    //   policyId: "POLICY_ID",
    //   parentId: "PARENT_ID",
    //   code: "000",
    // );

    // Resource<RegisterResponse> registerResponse =
    //     await registerWithoutMobileNumberUseCase
    //         .execute(RegisterWithoutMobileNumberParams(req));

    // await handleResponse(
    //   registerResponse,
    //   onFailure: (Resource<RegisterResponse> response) async {
    //     log("failed to call register api");
    //     setViewState(ViewState.idle);
    //   },
    //   onSuccess: (Resource<RegisterResponse> response) async {
    //     log(
    //       "success with id ${response.data?.client?.clientTypeId}",
    //     );
    //     setViewState(ViewState.idle);
    //   },
    // );
  }

  // Future<void> _handleRegisterSuccess(
  //     Resource<RegisterResponse> response) async {}

  Future<void> showLoader() async {
    setViewState(ViewState.busy);
    await Future<void>.delayed(const Duration(seconds: 5));
    setViewState(ViewState.success);
  }
}
