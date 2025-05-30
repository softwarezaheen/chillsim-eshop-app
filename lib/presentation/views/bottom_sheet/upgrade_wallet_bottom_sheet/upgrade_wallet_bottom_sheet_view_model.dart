import "dart:async";

import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/use_case/user/top_up_wallet_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:stacked_services/stacked_services.dart";

class UpgradeWalletBottomSheetViewModel extends BaseModel {
  UpgradeWalletBottomSheetViewModel({required this.completer});
  TextEditingController get amountController => _amountController;
  final TextEditingController _amountController = TextEditingController();

  TopUpWalletUseCase topUpWalletUseCase =
      TopUpWalletUseCase(locator<ApiUserRepository>());
  GetUserInfoUseCase getUserInfoUseCase =
      GetUserInfoUseCase(locator<ApiAuthRepository>());

  double amount = 0;
  bool _upgradeButtonEnabled = false;
  bool get upgradeButtonEnabled => _upgradeButtonEnabled;

  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    _amountController.addListener(_validateForm);
  }

  void _validateForm() {
    final String text = _amountController.text.trim();
    const String validAmountPattern = r"^\d+(\.\d{1,2})?$";
    final bool isValid = RegExp(validAmountPattern).hasMatch(text);

    if (isValid) {
      try {
        amount = double.parse(text);
        _upgradeButtonEnabled = true;
      } on Object catch (_) {
        _upgradeButtonEnabled = false;
      }
    } else {
      _upgradeButtonEnabled = false;
    }

    notifyListeners();
  }

  Future<void> upgradeButtonTapped() async {
    setViewState(ViewState.busy);

    Resource<BundleAssignResponseModel?> response =
        await topUpWalletUseCase.execute(
      TopUpWalletParam(
        amount: amount,
        currencyCode: "",
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<BundleAssignResponseModel?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        await initiatePaymentRequest(
          orderID: result.data?.orderId ?? "",
          publishableKey: result.data?.publishableKey ?? "",
          merchantIdentifier: result.data?.merchantIdentifier ?? "",
          paymentIntentClientSecret:
              result.data?.paymentIntentClientSecret ?? "",
          customerId: result.data?.customerId ?? "",
          customerEphemeralKeySecret:
              result.data?.customerEphemeralKeySecret ?? "",
          test: result.data?.testEnv ?? false,
          billingCountryCode: result.data?.billingCountryCode ?? "",
        );
      },
    );
    setViewState(ViewState.idle);
  }

  Future<void> initiatePaymentRequest({
    required String orderID,
    required String customerId,
    required String publishableKey,
    required String billingCountryCode,
    required String merchantIdentifier,
    required String paymentIntentClientSecret,
    required String customerEphemeralKeySecret,
    bool test = false,
  }) async {
    try {
      await paymentService.initializePaymentKeys(
        publishableKey: publishableKey,
        merchantIdentifier: merchantIdentifier,
      );

      await paymentService.triggerPaymentSheet(
        testEnv: test,
        customerId: customerId,
        billingCountryCode: billingCountryCode,
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
      );
    } on Exception catch (e) {
      showToast(
        e.toString().replaceAll("Exception:", ""),
        backgroundColor: Colors.grey,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
      );
      unawaited(cancelOrder(orderID: orderID));
      return;
    }

    setViewState(ViewState.busy);
    await getUserInfoUseCase.execute(NoParams());
    setViewState(ViewState.idle);

    completer(
      SheetResponse<EmptyBottomSheetResponse>(
        confirmed: true,
      ),
    );
  }
}
