import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_bundle_consumption_response.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/user/get_user_consumption_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:stacked_services/stacked_services.dart";

class MyESimBundleBottomSheetViewModel extends BaseModel {
  MyESimBundleBottomSheetViewModel({
    required this.request,
    required this.completer,
  });

  //#region UseCases
  final GetUserConsumptionUseCase getUserConsumptionUseCase =
      GetUserConsumptionUseCase(locator<ApiUserRepository>());

  //#endregion

  //#region Variables
  final MyESimBundleBottomState _state = MyESimBundleBottomState();

  MyESimBundleBottomState get state => _state;

  final SheetRequest<MyESimBundleRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  /// Tracks whether auto top-up was disabled during this sheet session,
  /// so the caller can do a targeted in-place update instead of a full refresh.
  bool _autoTopupWasDisabled = false;

//#endregion

//#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();

    PurchaseEsimBundleResponseModel? item =
        request.data?.eSimBundleResponseModel;

    bool isUnlimited = item?.unlimited ?? false;

    _state
      ..item = item
      ..showTopUP =
          (request.data?.eSimBundleResponseModel?.isTopupAllowed ?? true) &&
          !(item?.autoTopupEnabled ?? false)
      ..isAutoTopupEnabled = item?.autoTopupEnabled ?? false
      ..autoTopupBundleName =
          item?.autoTopupBundleName ?? item?.displayTitle
      ..showAutoTopupWidget = item?.isTopupAllowed ?? false
      ..consumptionLoading = !isUnlimited;

    if (isUnlimited) {
      notifyListeners();
    } else {
      unawaited(_fetchConsumptionData());
    }
  }

//#endregion

//#region Apis
  Future<void> _fetchConsumptionData() async {
    _state.consumptionLoading = true;
    Resource<UserBundleConsumptionResponse?> response =
        await getUserConsumptionUseCase
            .execute(UserConsumptionParam(iccID: _state.item?.iccid ?? ""));
    handleResponse<UserBundleConsumptionResponse?>(
      response,
      onSuccess: (Resource<UserBundleConsumptionResponse?> result) async {
        setViewState(ViewState.idle);
        double dataUsed = (result.data?.dataUsed ?? 0).toDouble();
        double dataAllocated = (result.data?.dataAllocated ?? 0).toDouble();
        String dataAllocatedDisplay = result.data?.dataAllocatedDisplay ?? "";
        String dataUsedDisplay = result.data?.dataUsedDisplay ?? "";

        double percentage = (dataUsed / dataAllocated) * 100;
        percentage = double.parse(percentage.toStringAsFixed(2));
        _state
          ..percentageUI = "$percentage %"
          ..consumption = percentage / 100
          ..consumptionText = "$dataUsedDisplay of $dataAllocatedDisplay"
          ..consumptionLoading = false;
      },
      onFailure: (Resource<UserBundleConsumptionResponse?> result) async {
        _state
          ..errorMessage = result.message ?? "Something Went Wrong"
          ..consumptionLoading = false;
      },
    );
  }

//#endregion

  void onTopUpClick() {
    completer(
      SheetResponse<MainBottomSheetResponse>(
        data: const MainBottomSheetResponse(
          canceled: false,
          tag: "top_up",
        ),
      ),
    );
  }

  Future<void> onAutoTopupToggle(bool value) async {
    if (!value) {
      await _disableAutoTopup();
    }
  }

  /// Disables auto top-up. Called after user confirms via the adaptive dialog in the view.
  Future<void> _disableAutoTopup() async {
    final String? iccid = _state.item?.iccid;
    if (iccid == null) return;

    _state.isUpdatingAutoTopup = true;
    notifyListeners();

    final Resource<dynamic> response =
        await locator<ApiUserRepository>().disableAutoTopup(iccid: iccid);

    await handleResponse(
      response,
      onSuccess: (Resource<dynamic> result) async {
        _state.isAutoTopupEnabled = false;
        _state.showTopUP = true;
        _autoTopupWasDisabled = true;
        await showToast(LocaleKeys.auto_topup_disable_success.tr());
      },
      onFailure: (Resource<dynamic> result) async {
        showNativeErrorMessage("", LocaleKeys.auto_topup_disable_error.tr());
      },
    );

    _state.isUpdatingAutoTopup = false;
    notifyListeners();
  }

  Future<void> onManageAutoTopupClick() async {
    final SheetResponse<MainBottomSheetResponse>? response =
        await locator<BottomSheetService>()
            .showCustomSheet<MainBottomSheetResponse,
                ManageAutoTopupSheetRequest>(
          variant: BottomSheetType.manageAutoTopup,
          data: ManageAutoTopupSheetRequest(
            iccid: _state.item?.iccid ?? "",
            isAutoTopupEnabled: _state.isAutoTopupEnabled,
            labelName: _state.item?.labelName as String?,
            bundleName:
                _state.autoTopupBundleName ?? _state.item?.displayTitle ?? "",
          ),
        );
    if (response?.data?.canceled == false) {
      _state.isAutoTopupEnabled = false;
      _autoTopupWasDisabled = true;
      notifyListeners();
    }
  }

  /// Closes the sheet, signalling to the caller whether auto top-up was
  /// changed so it can do a targeted in-place update without a full list reload.
  void closeSheet() {
    if (_autoTopupWasDisabled) {
      completer(
        SheetResponse<MainBottomSheetResponse>(
          data: const MainBottomSheetResponse(
            canceled: false,
            tag: "auto_topup_disabled",
          ),
        ),
      );
    } else {
      completer(SheetResponse<MainBottomSheetResponse>());
    }
  }
}

class MyESimBundleBottomState {
  PurchaseEsimBundleResponseModel? item;
  String? errorMessage;
  String percentageUI = "0.0 %";
  String consumptionText = "";
  double consumption = 0;
  bool consumptionLoading = true;
  bool showTopUP = true;
  bool isAutoTopupEnabled = false;
  bool isUpdatingAutoTopup = false;
  String? autoTopupBundleName;
  bool showAutoTopupWidget = false;
}
