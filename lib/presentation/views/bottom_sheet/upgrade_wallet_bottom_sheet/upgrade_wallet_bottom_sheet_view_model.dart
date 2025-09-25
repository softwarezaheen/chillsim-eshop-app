import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/api_auth_repository.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/use_case/user/top_up_wallet_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
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
    unawaited(_checkPaymentType());
  }

  Future<void> _checkPaymentType() async {
    List<PaymentType> paymentTypeList = AppEnvironment.appEnvironmentHelper
        .paymentTypeList(isUserLoggedIn: true);

    if (paymentTypeList.contains(PaymentType.wallet)) {
      paymentTypeList.remove(PaymentType.wallet);
    }

    if (paymentTypeList.isEmpty) {
      showToast(LocaleKeys.no_payment_method_available.tr());
      return;
    }

    //choose payment method
    if (paymentTypeList.length == 1) {
      //check if it's wallet, then check if wallet available
      PaymentType paymentType = paymentTypeList.first;

      switch (paymentType) {
        case PaymentType.dcb:
        case PaymentType.card:
          _proceedPayment(paymentType: paymentType);
        default:
      }
    } else {
      _choosePaymentMethod(paymentTypeList);
    }
  }

  Future<void> _choosePaymentMethod(
    List<PaymentType> paymentTypeList,
  ) async {
    SheetResponse<PaymentType>? response =
        await bottomSheetService.showCustomSheet(
      data: PaymentSelectionBottomRequest(
        paymentTypeList: paymentTypeList,
        amount: amount,
      ),
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.paymentSelection,
    );
    if (response?.confirmed ?? false) {
      _proceedPayment(paymentType: response?.data ?? PaymentType.card);
    }
  }

  Future<void> _proceedPayment({
    required PaymentType paymentType,
  }) async {
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
          paymentType: paymentType,
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
    required PaymentType paymentType,
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
      await paymentService.prepareCheckout(
        paymentType: paymentType,
        publishableKey: publishableKey,
        merchantIdentifier: merchantIdentifier,
      );

      PaymentResult paymentResult = await paymentService.processOrderPayment(
        paymentType: paymentType,
        testEnv: test,
        customerId: customerId,
        billingCountryCode: billingCountryCode,
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
      );

      switch (paymentResult) {
        case PaymentResult.completed:
          break;
        case PaymentResult.canceled:
          cancelOrder(orderID: orderID);

        case PaymentResult.otpRequested:
          //must send api for request otp , not implemented from backend
          bool result = await locator<NavigationService>().navigateTo(
            VerifyPurchaseView.routeName,
            arguments: VerifyPurchaseViewArgs(
              iccid: "",
              orderID: orderID,
            ),
            preventDuplicates: false,
          );

          if (!result) {
            cancelOrder(orderID: orderID);
          }
      }
    } on Exception catch (e) {
      showToast(e.toString().replaceAll("Exception:", ""));
      hideKeyboard();
      unawaited(cancelOrder(orderID: orderID));
      return;
    }

    hideKeyboard();
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
