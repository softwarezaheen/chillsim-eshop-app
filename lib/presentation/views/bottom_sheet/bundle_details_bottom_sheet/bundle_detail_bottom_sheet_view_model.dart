import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/use_case/auth/tmp_login_use_case.dart";
import "package:esim_open_source/domain/use_case/bundles/get_bundle_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/validate_promo_code_use_case.dart";
import "package:esim_open_source/domain/use_case/user/assign_user_bundle_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_exists_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/payment_selection_bottom_sheet/payment_selection_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:stacked_services/stacked_services.dart";

class BundleDetailBottomSheetViewModel extends BaseModel {
  BundleDetailBottomSheetViewModel({
    RegionRequestModel? region,
    List<CountriesRequestModel>? countries,
    BundleResponseModel? bundle,
  })  : _bundle = bundle,
        _region = region,
        _tempBundle = bundle,
        _countries = countries;

  final GetBundleUseCase getBundleUseCase = GetBundleUseCase(locator());
  final TmpLoginUseCase tmpLoginUseCase = TmpLoginUseCase(locator());
  final GetBundleExistsUseCase getBundleExistsUseCase =
      GetBundleExistsUseCase(locator());
  final ValidatePromoCodeUseCase validatePromoCodeUseCase =
      ValidatePromoCodeUseCase(locator());

  final RegionRequestModel? _region;
  BundleResponseModel? _bundle;
  final BundleResponseModel? _tempBundle;
  final List<CountriesRequestModel>? _countries;

  BundleResponseModel? get bundle => _bundle;

  bool _isTermsChecked = false;
  bool _isLoginEnabled = false;

  final TextEditingController _emailController = TextEditingController();

  String? _promoCode;
  String? _emailErrorMessage;

  String get emailErrorMessage => _emailErrorMessage ?? "";

  bool get isTermsChecked => _isTermsChecked;

  bool get isLoginEnabled => _isLoginEnabled;

  TextEditingController get emailController => _emailController;

  bool get isPromoCodeEnabled =>
      AppEnvironment.appEnvironmentHelper.enablePromoCode;

  bool get isPurchaseButtonEnabled {
    if (isUserLoggedIn) {
      return true;
    }
    return _isLoginEnabled;
  }

  //Promo code sub view
  bool isPromoCodeExpanded = false;
  final TextEditingController _promoCodeController = TextEditingController();

  TextEditingController get promoCodeController => _promoCodeController;

  String promoCodeMessage = "";
  bool promoCodeFieldEnabled = true;
  Color? promoCodeFieldColor;

  IconData get promoCodeFieldIcon {
    if (promoCodeFieldEnabled) {
      return Icons.error_outline;
    }
    return Icons.check_circle_outline;
  }

  String get promoCodeButtonText {
    if (promoCodeFieldEnabled) {
      return LocaleKeys.promoCodeView_buttonText.tr();
    }
    return LocaleKeys.promoCodeView_cancelButtonText.tr();
  }

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    _emailController.addListener(_validateForm);
    _promoCodeController.addListener(notifyListeners);

    // getBundleUseCase.execute(BundleParams(code: bundle?.bundleCode ?? ""));
  }

  void updateTermsSelections() {
    _isTermsChecked = !_isTermsChecked;
    notifyListeners();
    _validateForm();
  }

  void _validateForm() {
    final String emailAddress = _emailController.text;
    _emailErrorMessage = validateEmailAddress(emailAddress);
    _isLoginEnabled = _emailErrorMessage == "" && isTermsChecked;

    notifyListeners();
  }

  String validateEmailAddress(String text) {
    if (text.trim().isEmpty) {
      return LocaleKeys.is_required_field.tr();
    }

    if (text.trim().isValidEmail()) {
      return "";
    }

    return LocaleKeys.enter_a_valid_email_address.tr();
  }

  Future<void> buyNowPressed(BuildContext context) async {
    // Show compatible sheet
    SheetResponse<EmptyBottomSheetResponse>? response =
        await bottomSheetService.showCustomSheet(
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.compatibleSheetView,
    );
    if (response?.confirmed ?? false) {
      // Continue on Compatible

      if (!isUserLoggedIn) {
        await continueToPurchase();
        return;
      }

      //check if exists
      bool bundleExists = await checkIfBundleExists();
      if (bundleExists) {
        BundleExistsAction bundleExistsAction = await showNativeDialog(
              context: context,
              barrierDismissible: true,
              titleText: LocaleKeys.bundleExistsView_titleText.tr(),
              contentText: LocaleKeys.bundleExistsView_contentText.tr(),
              buttons: <NativeButtonParams>[
                NativeButtonParams(
                  buttonTitle: LocaleKeys.bundleExistsView_buttonOneText.tr(),
                  buttonAction: () => navigationService.back(
                    result: BundleExistsAction.buyNewEsim,
                  ),
                ),
                NativeButtonParams(
                  buttonTitle: LocaleKeys.bundleExistsView_buttonTwoText.tr(),
                  buttonAction: () => navigationService.back(
                    result: BundleExistsAction.goToEsim,
                  ),
                ),
              ],
            ) ??
            BundleExistsAction.close;
        if (bundleExistsAction == BundleExistsAction.buyNewEsim) {
          await continueToPurchase();
        } else if (bundleExistsAction == BundleExistsAction.goToEsim) {
          locator<HomePagerViewModel>().changeSelectedTabIndex(index: 1);
          navigationService.clearTillFirstAndShow(HomePager.routeName);
        }
      } else {
        await continueToPurchase();
      }
    }
  }

  Future<void> continueToPurchase() async {
    //choose payment method
    if (!isUserLoggedIn) {
      tmpLoginFlow();
      return;
    }

    final bool hasWalletView =
        AppEnvironment.appEnvironmentHelper.enableWalletView;
    final double price = bundle?.price ?? 0;
    final bool hasSufficientBalance =
        userAuthenticationService.walletAvailableBalance >= price;

    if (hasWalletView && hasSufficientBalance) {
      choosePaymentMethod();
    } else {
      triggerAssignFlow(PaymentSelection.card, null);
    }
  }

  Future<void> choosePaymentMethod() async {
    SheetResponse<PaymentSelection>? response =
        await bottomSheetService.showCustomSheet(
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.paymentSelection,
    );
    if (response?.confirmed ?? false) {
      triggerAssignFlow(response?.data ?? PaymentSelection.card, null);
    }
  }

  Future<bool> checkIfBundleExists() async {
    setViewState(ViewState.busy);
    bool bundleExists = false;
    Resource<bool?> response = await getBundleExistsUseCase
        .execute(BundleExistsParams(code: bundle?.bundleCode ?? ""));

    handleResponse(
      response,
      onSuccess: (Resource<bool?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        bundleExists = result.data ?? false;
      },
      onFailure: (Resource<bool?> result) async {},
    );
    setViewState(ViewState.idle);
    return bundleExists;
  }

  Future<void> tmpLoginFlow() async {
    setViewState(ViewState.busy);
    Resource<AuthResponseModel?> response = await tmpLoginUseCase.execute(
      TmpLoginParams(email: _emailController.text.trim()),
    );
    setViewState(ViewState.idle);
    handleResponse(
      response,
      onSuccess: (Resource<AuthResponseModel?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        triggerAssignFlow(
          PaymentSelection.card,
          result.data?.accessToken,
        );
      },
    );
  }

  Future<void> triggerAssignFlow(
    PaymentSelection paymentType,
    String? bearerToken,
  ) async {
    setViewState(ViewState.busy);
    Resource<BundleAssignResponseModel?> response =
        await AssignUserBundleUseCase(locator()).execute(
      AssignUserBundleParam(
        bundleCode: bundle?.bundleCode ?? "",
        promoCode: _promoCode ?? "",
        referralCode: "",
        affiliateCode: "",
        paymentType: paymentType.apiKey,
        bearerToken: bearerToken,
        relatedSearch: RelatedSearchRequestModel(
          region: _region,
          countries: _countries,
        ),
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<BundleAssignResponseModel?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        if (paymentType == PaymentSelection.card) {
          await initiatePaymentRequest(
            bearerToken: bearerToken,
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
        } else {
          await navigateToLoading(
            result.data?.orderId ?? "",
            bearerToken,
          );
        }
      },
    );
    setViewState(ViewState.idle);
  }

  Future<void> showTermsSheet() async {
    SheetResponse<EmptyBottomSheetResponse>? response =
        await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.termsCondition,
      isScrollControlled: true,
      enableDrag: false,
    );
    if (response?.confirmed ?? false) {
      _isTermsChecked = true;
      _validateForm();
    }
  }

  Future<void> initiatePaymentRequest({
    required String orderID,
    required String publishableKey,
    required String merchantIdentifier,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    required String billingCountryCode,
    String? bearerToken,
    bool test = false,
  }) async {
    try {
      await paymentService.initializePaymentKeys(
        publishableKey: publishableKey,
        merchantIdentifier: merchantIdentifier,
      );

      await paymentService.triggerPaymentSheet(
        billingCountryCode: billingCountryCode,
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerId: customerId,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
        testEnv: test,
      );
    } on Exception catch (e) {
      showToast(
        e.toString().replaceAll("Exception:", ""),
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.grey,
      );
      hideKeyboard();
      unawaited(cancelOrder(orderID: orderID));
      return;
    }

    hideKeyboard();
    navigateToLoading(orderID, bearerToken);
  }

  Future<void> navigateToLoading(String orderID, String? bearerToken) async {
    locator.resetLazySingleton(instance: locator<PurchaseLoadingViewModel>());
    navigationService.navigateTo(
      preventDuplicates: false,
      PurchaseLoadingView.routeName,
      arguments: PurchaseLoadingViewData(
        orderID: orderID,
        bearerToken: bearerToken,
      ),
    );
  }

  void expandedCallBack() {
    isPromoCodeExpanded = !isPromoCodeExpanded;
    notifyListeners();
  }

  Future<void> validatePromoCode(String promoCode) async {
    if (!promoCodeFieldEnabled) {
      _promoCode = null;
      _bundle = _tempBundle;
      _promoCodeController.clear();
      updatePromoCodeView(isEnabled: true);
      notifyListeners();
      return;
    }

    setViewState(ViewState.busy);

    Resource<BundleResponseModel?> response =
        await validatePromoCodeUseCase.execute(
      ValidatePromoCodeUseCaseParams(
        promoCode: promoCode.trim(),
        bundleCode: bundle?.bundleCode ?? "",
      ),
    );

    handleResponse(
      response,
      onSuccess: (Resource<BundleResponseModel?> result) async {
        _bundle = result.data;
        _promoCode = promoCode;
        updatePromoCodeView(
          message: result.message ?? "",
          isEnabled: false,
          fieldColor: Colors.green,
        );
      },
      onFailure: (Resource<BundleResponseModel?> result) async {
        _bundle = _tempBundle;
        _promoCode = null;
        updatePromoCodeView(
          message: result.message ?? "",
          isEnabled: true,
          fieldColor: Colors.red,
        );
      },
    );

    setViewState(ViewState.idle);
  }

  void updatePromoCodeView({
    required bool isEnabled,
    Color? fieldColor,
    String message = "",
  }) {
    promoCodeMessage = message;
    promoCodeFieldColor = fieldColor;
    promoCodeFieldEnabled = isEnabled;
    notifyListeners();
  }
}
