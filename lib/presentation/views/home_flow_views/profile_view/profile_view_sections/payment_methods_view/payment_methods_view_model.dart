import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/user/auto_topup_config_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/saved_payment_method_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class PaymentMethodsViewModel extends BaseModel {
  //#region Variables
  final PaymentMethodsState _state = PaymentMethodsState();

  PaymentMethodsState get state => _state;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(_fetchPaymentMethods());
    unawaited(_fetchAutoTopupConfigs());
  }

  //#endregion

  //#region Apis
  Future<void> _fetchPaymentMethods() async {
    setViewState(ViewState.busy);

    final Resource<List<SavedPaymentMethodResponseModel>> response =
        await locator<ApiUserRepository>().getPaymentMethods();

    handleResponse<List<SavedPaymentMethodResponseModel>>(
      response,
      onSuccess:
          (Resource<List<SavedPaymentMethodResponseModel>> result) async {
        _state.paymentMethods = result.data ?? <SavedPaymentMethodResponseModel>[];
        setViewState(ViewState.idle);
      },
      onFailure:
          (Resource<List<SavedPaymentMethodResponseModel>> result) async {
        _state.errorMessage = result.message ?? "";
        setViewState(ViewState.idle);
      },
    );
  }

  Future<void> refreshPaymentMethods() async {
    await _fetchPaymentMethods();
    await _fetchAutoTopupConfigs();
  }

  Future<void> _fetchAutoTopupConfigs() async {
    try {
      final Resource<dynamic> response =
          await locator<ApiUserRepository>().getAutoTopupConfigs();

      await handleResponse(
        response,
        onSuccess: (Resource<dynamic> result) async {
          if (result.data is List<AutoTopupConfigResponseModel>) {
            _state.autoTopupConfigs = result.data as List<AutoTopupConfigResponseModel>;
            _checkDefaultPaymentMethodInUse();
          }
        },
        onFailure: (Resource<dynamic> result) async {
          // Silently fail - auto-topup check is not critical
          _state.autoTopupConfigs = <AutoTopupConfigResponseModel>[];
        },
      );
    } on Exception  {
      // Silently fail - auto-topup check is not critical
      _state.autoTopupConfigs = <AutoTopupConfigResponseModel>[];
    }
  }

  void _checkDefaultPaymentMethodInUse() {
    // Find the default payment method
    final SavedPaymentMethodResponseModel? defaultPm = _state.paymentMethods
        .cast<SavedPaymentMethodResponseModel?>()
        .firstWhere(
          (SavedPaymentMethodResponseModel? pm) => pm?.isDefault ?? false,
          orElse: () => null,
        );

    if (defaultPm == null) {
      _state.hasAutoTopupOnDefaultPm = false;
      notifyListeners();
      return;
    }

    // Check if any active auto-topup config uses this payment method (or uses default)
    _state.hasAutoTopupOnDefaultPm = _state.autoTopupConfigs.any(
      (AutoTopupConfigResponseModel config) =>
          (config.enabled ?? false) &&
          (config.paymentMethodId == null ||
              config.paymentMethodId == defaultPm.id),
    );

    notifyListeners();
  }

  Future<void> onSetDefault(String paymentMethodId) async {
    _state.updatingId = paymentMethodId;
    notifyListeners();

    try {
      final Resource<SavedPaymentMethodResponseModel> response =
          await locator<ApiUserRepository>().setDefaultPaymentMethod(
        pmId: paymentMethodId,
      );

      await handleResponse<SavedPaymentMethodResponseModel>(
        response,
        onSuccess: (Resource<SavedPaymentMethodResponseModel> result) async {
          await showToast(
            LocaleKeys.payment_methods_set_default_success.tr(),
          );
          await _fetchPaymentMethods();
        },
        onFailure: (Resource<SavedPaymentMethodResponseModel> result) async {
          showNativeErrorMessage(
            "",
            LocaleKeys.payment_methods_set_default_error.tr(),
          );
        },
      );
    } on Exception {
      showNativeErrorMessage(
        "",
        LocaleKeys.payment_methods_set_default_error.tr(),
      );
    } finally {
      _state.updatingId = null;
      notifyListeners();
    }
  }

  Future<void> onDelete(String paymentMethodId) async {
    // Check if trying to delete default PM with active auto-topup
    final SavedPaymentMethodResponseModel? pm = _state.paymentMethods
        .cast<SavedPaymentMethodResponseModel?>()
        .firstWhere(
          (SavedPaymentMethodResponseModel? p) => p?.id == paymentMethodId,
          orElse: () => null,
        );

    if ((pm?.isDefault ?? false) && _state.hasAutoTopupOnDefaultPm) {
      showNativeErrorMessage(
        LocaleKeys.payment_methods_delete_blocked_title.tr(),
        LocaleKeys.payment_methods_delete_blocked_message.tr(),
      );
      return;
    }

    _state.updatingId = paymentMethodId;
    notifyListeners();

    try {
      final Resource<dynamic> response =
          await locator<ApiUserRepository>().deletePaymentMethod(
        pmId: paymentMethodId,
      );

      await handleResponse(
        response,
        onSuccess: (Resource<dynamic> result) async {
          await showToast(LocaleKeys.payment_methods_delete_success.tr());
          await _fetchPaymentMethods();
        },
        onFailure: (Resource<dynamic> result) async {
          showNativeErrorMessage(
            "",
            LocaleKeys.payment_methods_delete_error.tr(),
          );
        },
      );
    } on Exception {
      showNativeErrorMessage(
        "",
        LocaleKeys.payment_methods_delete_error.tr(),
      );
    } finally {
      _state.updatingId = null;
      notifyListeners();
    }
  }

  Future<void> onSync() async {
    _state.isSyncing = true;
    notifyListeners();

    try {
      final Resource<List<SavedPaymentMethodResponseModel>> response =
          await locator<ApiUserRepository>().syncPaymentMethods();

      await handleResponse<List<SavedPaymentMethodResponseModel>>(
        response,
        onSuccess: (Resource<List<SavedPaymentMethodResponseModel>> result) async {
          await showToast(LocaleKeys.payment_methods_sync_success.tr());
          await _fetchPaymentMethods();
        },
        onFailure: (Resource<List<SavedPaymentMethodResponseModel>> result) async {
          showNativeErrorMessage(
            "",
            LocaleKeys.payment_methods_sync_error.tr(),
          );
        },
      );
    } on Exception {
      showNativeErrorMessage(
        "",
        LocaleKeys.payment_methods_sync_error.tr(),
      );
    } finally {
      _state.isSyncing = false;
      notifyListeners();
    }
  }

  //#endregion
}

class PaymentMethodsState {
  List<SavedPaymentMethodResponseModel> paymentMethods =
      <SavedPaymentMethodResponseModel>[];
  List<AutoTopupConfigResponseModel> autoTopupConfigs =
      <AutoTopupConfigResponseModel>[];
  String? errorMessage;
  String? updatingId;
  bool isSyncing = false;
  bool hasAutoTopupOnDefaultPm = false;
}
