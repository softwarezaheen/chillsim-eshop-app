import "dart:async";
import "dart:developer";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/request/related_search.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_taxes_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/auth/tmp_login_use_case.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/promotion/validate_promo_code_use_case.dart";
import "package:esim_open_source/domain/use_case/user/assign_user_bundle_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_bundle_exists_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_loading_view/purchase_loading_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/order_status_enum.dart";
import "package:flutter/material.dart";
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

  //#region UseCases
  final TmpLoginUseCase tmpLoginUseCase = TmpLoginUseCase(locator());
  final GetBundleExistsUseCase getBundleExistsUseCase =
      GetBundleExistsUseCase(locator());
  final ValidatePromoCodeUseCase validatePromoCodeUseCase =
      ValidatePromoCodeUseCase(locator());
  final GetUserInfoUseCase getUserInfoUseCase =
      GetUserInfoUseCase(locator());
  //#endregion

  //#region Variables
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

  BundleTaxesResponseModel? _taxes;
  BundleTaxesResponseModel? get taxes => _taxes;

  //Promo code sub view
  bool isPromoCodeExpanded = false;

  String get _referralCode =>
      localStorageService.getString(LocalStorageKeys.referralCode) ?? "";
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

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    _emailController.addListener(_validateForm);
    _promoCodeController.addListener(() {
      final String text = _promoCodeController.text;
      if (text != text.toUpperCase()) {
        final TextSelection selection = _promoCodeController.selection;
        _promoCodeController.value = TextEditingValue(
          text: text.toUpperCase(),
          selection: selection,
        );
        notifyListeners(); // <-- This ensures the UI updates after text change
      } else {
        notifyListeners(); // Still notify on regular changes
      }
    });

    if (_referralCode.isNotEmpty) {
      unawaited(validatePromoCode(_referralCode));
    }

    if (_bundle != null && _bundle!.bundleCode != null) {
      unawaited(loadTaxes());
      
      // Log view product details event
      unawaited(analyticsService.logEvent(
        event: ViewItemEvent(
          item: EcommerceItem(
            id: _bundle!.bundleCode!,
            name: _bundle!.displayTitle ?? _bundle!.bundleName ?? '',
            category: 'esim_bundle',
            price: (_bundle!.price ?? 0).toDouble(),
          ),
          platform: Platform.isIOS ? 'iOS' : 'Android',
          currency: _bundle!.currencyCode ?? "EUR",
        ),
      ));
    }
  }

  void updateTermsSelections() {
    _isTermsChecked = !_isTermsChecked;
    notifyListeners();
    _validateForm();
  }

  void expandedCallBack() {
    isPromoCodeExpanded = !isPromoCodeExpanded;
    notifyListeners();
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

  void _validateForm() {
    final String emailAddress = _emailController.text.trim();
    _emailErrorMessage = _validateEmailAddress(emailAddress);
    _isLoginEnabled = _emailErrorMessage == "" && isTermsChecked;

    notifyListeners();
  }

  String _validateEmailAddress(String text) {
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
      // let payment sheet handle everything

      if (isUserLoggedIn) {
        //check if exists
        bool bundleExists = await _checkIfBundleExists();
        if (bundleExists && context.mounted) {
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
            await _continueToPurchase();
          } else if (bundleExistsAction == BundleExistsAction.goToEsim) {
            locator<HomePagerViewModel>().changeSelectedTabIndex(index: 1);
            navigationService.clearTillFirstAndShow(HomePager.routeName);
          }
        } else {
          await _continueToPurchase();
        }
      } else {
        await _continueToPurchase();
      }
    }
  }

  Future<void> _continueToPurchase() async {
    List<PaymentType> paymentTypeList = AppEnvironment.appEnvironmentHelper
        .paymentTypeList(isUserLoggedIn: isUserLoggedIn);
    final double price = bundle?.price ?? 0;

    //check 100% discount
    if (price == 0) {
      //payment type does not matter
      _triggerAssignFlow(
        paymentType: PaymentType.card,
      );
      return;
    }

    if (paymentTypeList.isEmpty) {
      //no payment type available
      showToast(LocaleKeys.no_payment_method_available.tr());
      return;
    }

    //choose payment method
    if (paymentTypeList.length == 1) {
      //check if it's wallet, then check if wallet available
      PaymentType paymentType = paymentTypeList.first;

      switch (paymentType) {
        case PaymentType.wallet:
          if (isUserLoggedIn) {
            final bool hasSufficientBalance =
                userAuthenticationService.walletAvailableBalance >= price;
            if (!hasSufficientBalance) {
              showToast(LocaleKeys.no_sufficient_balance_in_wallet.tr());
              return;
            }
            _triggerAssignFlow(paymentType: paymentType);
          } else {
            //case not valid
          }
        case PaymentType.dcb:
        case PaymentType.card:
        case PaymentType.applePay:
          _triggerAssignFlow(paymentType: paymentType);
      }
    } else {
      _choosePaymentMethod(paymentTypeList);
    }
  }

  Future<void> _choosePaymentMethod(
    List<PaymentType> paymentTypeList,
  ) async {
    final double price = bundle?.price ?? 0;
    SheetResponse<PaymentType>? response =
        await bottomSheetService.showCustomSheet(
      data: PaymentSelectionBottomRequest(
        paymentTypeList: paymentTypeList,
        amount: price,
      ),
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.paymentSelection,
    );
    if (response?.confirmed ?? false) {
      _triggerAssignFlow(paymentType: response?.data ?? PaymentType.card);
    }
  }

  Future<void> _triggerAssignFlow({
    required PaymentType paymentType,
  }) async {
    String? bearerToken;
    if (!isUserLoggedIn) {
      bearerToken = await _getTemporaryToken();
      if (bearerToken == null) {
        return;
      }
    }

    setViewState(ViewState.busy);
    Resource<BundleAssignResponseModel?> response =
        await AssignUserBundleUseCase(locator()).execute(
      AssignUserBundleParam(
        bundleCode: bundle?.bundleCode ?? "",
        promoCode: _promoCode ?? "",
        referralCode: "",
        affiliateCode: "",
        paymentType: paymentType == PaymentType.wallet
            ? paymentType.type
            : AppEnvironment
                .appEnvironmentHelper.defaultPaymentTypeList.first.type,
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

        // Log checkout event
        final double fee = 0; // TODO: Get fee from response if available
        final double tax = 0; // TODO: Get tax from response if available
        
        // Log add to cart event
        final item = EcommerceItem(
          id: bundle?.bundleCode ?? '',
            name: bundle?.displayTitle ?? bundle?.bundleName ?? '',
            category: 'esim_bundle',
            price: (bundle?.price ?? 0).toDouble(),
            quantity: 1,
        );
        await analyticsService.logEvent(
          event: AddToCartEvent(
            item: item,
            platform: Platform.isIOS ? 'iOS' : 'Android',
            currency: bundle?.currencyCode ?? 'EUR',
          ),
        );
        await analyticsService.logEvent(
          event: BeginCheckoutEvent(
            items: [item],
            platform: Platform.isIOS ? 'iOS' : 'Android',
            currency: bundle?.currencyCode ?? 'EUR',
            shipping: fee / 100,
            tax: tax / 100,
            coupon: _promoCode,
          ),
        );

        PaymentStatus paymentStatus =
            PaymentStatus.fromString(result.data?.paymentStatus);
        if (paymentStatus == PaymentStatus.completed) {
          if (paymentType == PaymentType.wallet) {
            await _refreshUserInfo();
          }
          _navigateToLoading(
            result.data?.orderId ?? "",
            bearerToken,
          );
          return;
        }

        _initiatePaymentRequest(
          paymentType: paymentType,
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
      },
    );
  }

  Future<void> _initiatePaymentRequest({
    required PaymentType paymentType,
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
      await paymentService.prepareCheckout(
        paymentType: paymentType,
        publishableKey: publishableKey,
        merchantIdentifier: merchantIdentifier,
      );

      PaymentResult paymentResult = await paymentService.processOrderPayment(
        paymentType: paymentType,
        orderID: orderID,
        billingCountryCode: billingCountryCode,
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerId: customerId,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
        testEnv: test,
      );

      setViewState(ViewState.idle);

      switch (paymentResult) {
        case PaymentResult.completed:
          _navigateToLoading(
            orderID,
            bearerToken,
          );

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
          debugPrint("result: $result");
          if (result) {
            _navigateToLoading(
              orderID,
              bearerToken,
            );
          } else {
            cancelOrder(orderID: orderID);
          }
      }
    } on Exception catch (e) {
      showToast(
        e.toString().replaceAll("Exception:", ""),
      );
      setViewState(ViewState.idle);
      unawaited(cancelOrder(orderID: orderID));
      return;
    }
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

  Future<void> _navigateToLoading(String orderID, String? bearerToken) async {
    // remove the promo code after payment successfully completed
    _removePromoCodeFromLocalStorage();

    String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
    analyticsService.logEvent(
      event: AnalyticEvent.buySuccess(
        utm: utm,
        platform: Platform.isAndroid ? "Android" : "iOS",
        amount: _bundle?.priceDisplay ?? "",
        currency: _bundle?.currencyCode ?? "",
      ),
    );

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

  //#endregion

  //#region Apis
  Future<String?> _getTemporaryToken() async {
    setViewState(ViewState.busy);
    Resource<AuthResponseModel?> response = await tmpLoginUseCase.execute(
      TmpLoginParams(email: _emailController.text.trim()),
    );
    setViewState(ViewState.idle);
    String? token;

    switch (response.resourceType) {
      case ResourceType.success:
        if (response.data == null) {
          handleError(response);
        } else {
          token = response.data?.accessToken;
        }
      case ResourceType.error:
        handleError(response);
      case ResourceType.loading:
    }

    return token;
  }

  Future<bool> _checkIfBundleExists() async {
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

  Future<void> validatePromoCode(String promoCode) async {
    if (!promoCodeFieldEnabled) {
      _promoCode = null;
      _bundle = _tempBundle;
      _promoCodeController.clear();
      updatePromoCodeView(isEnabled: true);
      // Reload taxes without promo code
      await loadTaxes(manageViewState: false);
      notifyListeners();
      return;
    }

    setViewState(ViewState.busy);

    Resource<BundleResponseModel?> response =
        await validatePromoCodeUseCase.execute(
      ValidatePromoCodeUseCaseParams(
        promoCode: promoCode.trim().toUpperCase(),
        bundleCode: bundle?.bundleCode ?? "",
      ),
    );

    await handleResponse(
      response,
      onSuccess: (Resource<BundleResponseModel?> result) async {
        _bundle = result.data;
        _promoCode = promoCode;
        _promoCodeController.text = _referralCode;
        isPromoCodeExpanded = true;
        updatePromoCodeView(
          message: result.message ?? "",
          isEnabled: false,
          fieldColor: Colors.green,
        );
        //load taxes again
        await loadTaxes(manageViewState: false);
      },
      onFailure: (Resource<BundleResponseModel?> result) async {
        _bundle = _tempBundle;
        _promoCode = null;
        isPromoCodeExpanded = false;
        _removePromoCodeFromLocalStorage();
        if (isPromoCodeExpanded) {
          updatePromoCodeView(
            message: result.message ?? "Not found",
            isEnabled: true,
            fieldColor: Colors.red,
          );
        } else {
          updatePromoCodeView(isEnabled: true);
        }
      },
    );

    setViewState(ViewState.idle);
  }

  void _removePromoCodeFromLocalStorage() {
    unawaited(
      locator<LocalStorageService>().remove(LocalStorageKeys.referralCode),
    );
  }
//#endregion

//#taxes
  Future<void> loadTaxes({bool manageViewState = true}) async {
    if (_bundle?.bundleCode == null || _bundle!.bundleCode!.isEmpty) {
      return;
    }
    if (manageViewState) {
      setViewState(ViewState.busy);
    }
    final ResponseMain<BundleTaxesResponseModel> response =
        await locator<ApiUser>().getTaxes(bundleCode: _bundle!.bundleCode!, promoCode: _promoCode,);

    if (response.status == "success" && response.data != null ) {
      _taxes = response.data;
      log("Taxes loaded: fee=${_taxes?.fee}, vat=${_taxes?.vat}, originalPrice=${_taxes?.originalAmount}, total=${_taxes?.total}  ");
      notifyListeners();
    } else {
      // Optionally handle error
      log("Failed to load taxes: ${response.message}");
    }
    if (manageViewState) {
      setViewState(ViewState.idle);
    }
  }

  Future<void> _refreshUserInfo() async {
    Resource<AuthResponseModel?> response =
        await getUserInfoUseCase.execute(NoParams());
    handleResponse(
      response,
      onSuccess: (Resource<AuthResponseModel?> result) async {},
    );
  }
}
