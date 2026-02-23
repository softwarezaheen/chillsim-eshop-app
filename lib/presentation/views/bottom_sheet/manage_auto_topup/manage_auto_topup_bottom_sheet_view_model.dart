import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/user/auto_topup_config_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:stacked_services/stacked_services.dart";

class ManageAutoTopupBottomSheetViewModel extends BaseModel {
  ManageAutoTopupBottomSheetViewModel({
    required this.request,
    required this.completer,
  });

  final SheetRequest<ManageAutoTopupSheetRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  final ManageAutoTopupState _state = ManageAutoTopupState();
  ManageAutoTopupState get state => _state;

  @override
  void onViewModelReady() {
    final ManageAutoTopupSheetRequest data = request.data!;
    _state.iccid = data.iccid;
    _state.labelName = data.labelName;
    _state.isEnabled = data.isAutoTopupEnabled;
    _state.bundleName = data.bundleName;
    notifyListeners();
    unawaited(_loadConfig());
  }

  Future<void> _loadConfig() async {
    final String iccid = _state.iccid ?? "";
    if (iccid.isEmpty) return;

    _state.isLoadingConfig = true;
    notifyListeners();

    final Resource<dynamic> response =
        await locator<ApiUserRepository>().getAutoTopupConfig(iccid: iccid);

    await handleResponse(
      response,
      onSuccess: (Resource<dynamic> result) async {
        _state.config = result.data as AutoTopupConfigResponseModel?;
        _state.isLoadingConfig = false;
        notifyListeners();
      },
      onFailure: (Resource<dynamic> result) async {
        _state.isLoadingConfig = false;
        notifyListeners();
      },
    );
  }

  Future<void> onDisableConfirmed() async {
    _state.isUpdating = true;
    notifyListeners();

    final Resource<dynamic> response =
        await locator<ApiUserRepository>().disableAutoTopup(
      iccid: _state.iccid ?? "",
    );

    await handleResponse(
      response,
      onSuccess: (Resource<dynamic> result) async {
        _state.isUpdating = false;
        await showToast(LocaleKeys.auto_topup_disable_success.tr());
        completer(
          SheetResponse<MainBottomSheetResponse>(
            data: const MainBottomSheetResponse(canceled: false),
          ),
        );
      },
      onFailure: (Resource<dynamic> result) async {
        _state.isUpdating = false;
        showNativeErrorMessage(
          "",
          LocaleKeys.auto_topup_disable_error.tr(),
        );
        notifyListeners();
      },
    );
  }

  void close() {
    completer(
      SheetResponse<MainBottomSheetResponse>(
        data: const MainBottomSheetResponse(),
      ),
    );
  }
}

class ManageAutoTopupState {
  String? iccid;
  String? labelName;
  bool isEnabled = true;
  String? bundleName;
  AutoTopupConfigResponseModel? config;
  bool isLoadingConfig = false;
  bool isUpdating = false;
}
