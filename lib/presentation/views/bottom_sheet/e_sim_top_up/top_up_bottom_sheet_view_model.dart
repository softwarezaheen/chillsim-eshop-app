import "dart:async";
import "dart:developer" as dev;
import "dart:io";
import "dart:math";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/data/remote/responses/auth/auth_response_model.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_taxes_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/user_get_billing_info_response_model.dart";
import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/repository/api_user_repository.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/bundles/get_bundle_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_related_topup_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_user_info_use_case.dart";
import "package:esim_open_source/domain/use_case/user/top_up_user_bundle_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/esim_base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/verify_purchase_view/verify_purchase_view.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:esim_open_source/utils/order_status_enum.dart";
import "package:stacked_services/stacked_services.dart";

class TopUpBottomSheetViewModel extends EsimBaseModel {
  TopUpBottomSheetViewModel({required this.request, required this.completer});

  final Map<String, BundleTaxesResponseModel?> bundleTaxes = <String, BundleTaxesResponseModel?>{};
  final Set<String> loadingTaxesBundleCodes = <String>{};

  //#region UseCases
  final TopUpUserBundleUseCase topUpUserBundleUseCase =
      TopUpUserBundleUseCase(locator());
  final GetBundleUseCase getBundleUseCase = GetBundleUseCase(locator());
  //#endregion

  //#region Variables
  final SheetRequest<BundleTopUpBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;
  List<BundleResponseModel> bundleItems = <BundleResponseModel>[];

  /// Whether the user has opted in to enable auto top-up after purchase.
  /// Defaults to true if auto top-up is already active for this eSIM.
  bool autoTopupOptIn = false;

  /// Whether the pending bundle is unlimited (auto top-up would never trigger).
  bool _pendingBundleUnlimited = false;

  /// Guards against double-invocation of the payment flow (e.g. rapid double-tap on "Buy").
  bool _isProcessingPayment = false;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    autoTopupOptIn = request.data?.isAutoTopupEnabled ?? false;
    unawaited(_initializeView());
  }

  Future<void> _initializeView() async {
    // Fetch bundle details for analytics
    final Resource<BundleResponseModel?> bundleResource = await getBundleUseCase.execute(
      BundleParams(code: request.data!.bundleCode),
    );

    if (bundleResource.resourceType == ResourceType.success && bundleResource.data != null) {
      final BundleResponseModel bundle = bundleResource.data!;
      
      // Log view topup details event
      unawaited(analyticsService.logEvent(
        event: ViewItemEvent(
          item: EcommerceItem(
            id: bundle.bundleCode ?? "",
            name: bundle.displayTitle ?? bundle.bundleName ?? "",
            category: "topup",
            price: bundle.price ?? 0,
          ),
          platform: Platform.isIOS ? "iOS" : "Android",
          currency: bundle.currencyCode,
        ),
      ),);
    }

    // Fetch topup related bundles
    unawaited(fetchTopUpRelated());
  }

  void onBuyClick({required int index}) {
    BundleResponseModel item = bundleItems[index];
    dev.log("Top up bundle code: ${item.bundleCode??""}");
    
    // Log add to cart topup event
    unawaited(analyticsService.logEvent(
      event: AddToCartEvent(
        item: EcommerceItem(
          id: item.bundleCode ?? "",
          name: item.displayTitle ?? item.bundleName ?? "",
          category: "topup",
          price: item.price ?? 0,
        ),
        platform: Platform.isIOS ? "iOS" : "Android",
        currency: item.currencyCode ?? "EUR",
      ),
    ),);
    
    // Start payment method selection flow
    unawaited(_initializeTopUpFlow(item));
  }

  Future<void> _initializeTopUpFlow(BundleResponseModel item) async {
    // Check if user has complete billing info before proceeding
    if (isUserLoggedIn) {
      setViewState(ViewState.busy);
      final bool hasBillingInfo = await _hasCompleteBillingInfo();
      setViewState(ViewState.idle);
      
      if (!hasBillingInfo) {
        // Show billing info bottom sheet
        final bool billingConfirmed = await _showBillingInfoBottomSheet();
        if (!billingConfirmed) {
          // User cancelled billing info, don't proceed with purchase
          return;
        }
      }
    }
    
    List<PaymentType> paymentTypeList = AppEnvironment.appEnvironmentHelper
        .paymentTypeList(isUserLoggedIn: isUserLoggedIn);

    final double price = item.price ?? 0;

    //check 100% discount
    if (price == 0) {
      //payment type does not matter
      _triggerTopUpFlow(
        item: item,
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
            unawaited(_triggerTopUpFlow(item: item, paymentType: paymentType));
          } else {
            //case not valid
            showToast(LocaleKeys.no_payment_method_available.tr());
          }
        case PaymentType.dcb:
        case PaymentType.applePay:
          unawaited(_triggerTopUpFlow(item: item, paymentType: paymentType));
        case PaymentType.card:
          // Route through PM sheet for logged-in users to allow saved PM selection
          if (isUserLoggedIn) {
            unawaited(_choosePaymentMethod(<PaymentType>[PaymentType.card], item));
          } else {
            unawaited(_triggerTopUpFlow(item: item, paymentType: paymentType));
          }
      }
    } else {
      unawaited(_choosePaymentMethod(paymentTypeList, item));
    }
  }

  Future<void> _choosePaymentMethod(
    List<PaymentType> paymentTypeList,
    BundleResponseModel item,
  ) async {
    final double price = item.price ?? 0;
    final bool hasCard = paymentTypeList.contains(PaymentType.card);

    if (isUserLoggedIn && hasCard) {
      // Show saved payment method selection sheet for logged-in users
      final SheetResponse<SavedPaymentMethodSheetResult>? pmResponse =
          await bottomSheetService.showCustomSheet(
        data: SavedPaymentMethodSheetRequest(
          amount: price,
          currency: item.currencyCode ?? "",
          walletBalance:
              userAuthenticationService.walletAvailableBalance,
          showWallet: paymentTypeList.contains(PaymentType.wallet),
        ),
        enableDrag: false,
        isScrollControlled: true,
        variant: BottomSheetType.paymentMethod,
      );
      if (pmResponse?.confirmed ?? false) {
        final SavedPaymentMethodSheetResult? result = pmResponse?.data;
        if (result?.canceled ?? false) {
          return;
        }
        _triggerTopUpFlow(
          item: item,
          paymentType: result?.paymentType ?? PaymentType.card,
          paymentMethodId: result?.paymentMethodId,
        );
      }
      return;
    }

    // Fallback: legacy payment selection sheet
    final SheetResponse<PaymentType>? response =
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
      _triggerTopUpFlow(
        item: item,
        paymentType: response?.data ?? PaymentType.card,
      );
    }
  }

  Future<void> _triggerTopUpFlow({
    required BundleResponseModel item,
    required PaymentType paymentType,
    String? paymentMethodId,
  }) async {
    _pendingBundleUnlimited = item.unlimited ?? false;
    unawaited(
      _topUpBundle(
        iccId: request.data?.iccID ?? "",
        bundleCode: item.bundleCode ?? "",
        bundlePrice: item.priceDisplay ?? "",
        bundleCurrency: item.currencyCode ?? "",
        paymentType: paymentType,
        paymentMethodId: paymentMethodId,
      ),
    );
  }

  void closeBottomSheet() {
    completer(SheetResponse<MainBottomSheetResponse>());
  }

  void setAutoTopupOptIn({required bool value}) {
    autoTopupOptIn = value;
    notifyListeners();
  }

  bool get allBundlesUnlimited =>
      bundleItems.isNotEmpty &&
      bundleItems.every((BundleResponseModel b) => b.unlimited ?? false);

  bool get hasMixedUnlimitedBundles =>
      bundleItems.any((BundleResponseModel b) => b.unlimited ?? false) &&
      bundleItems.any((BundleResponseModel b) => b.unlimited != true);

  /// Check if user has complete billing information.
  /// Required fields for individual: firstName, lastName, country, state, city
  /// Required fields for business (companyName OR vatCode present): above + companyName, vatCode
  /// TODO: Add extra validation if needed
  Future<bool> _hasCompleteBillingInfo() async {
    try {
      final dynamic billingInfoResource = await locator<ApiUserRepository>().getUserBillingInfo();
      final UserGetBillingInfoResponseModel? data = billingInfoResource?.data;
      
      if (data == null) {
        return false;
      }
      
      // Check base required fields for individual
      final bool hasBaseFields = 
        (data.firstName?.trim().isNotEmpty ?? false) &&
        (data.lastName?.trim().isNotEmpty ?? false) &&
        (data.country?.trim().isNotEmpty ?? false) &&
        (data.state?.trim().isNotEmpty ?? false) &&
        (data.city?.trim().isNotEmpty ?? false);
      
      if (!hasBaseFields) {
        return false;
      }
      
      // Check if this is a business account (either companyName or vatCode is present)
      final bool isBusiness = 
        (data.companyName?.trim().isNotEmpty ?? false) || 
        (data.vatCode?.trim().isNotEmpty ?? false);
      
      if (isBusiness) {
        // Business requires both companyName AND vatCode
        return (data.companyName?.trim().isNotEmpty ?? false) && 
               (data.vatCode?.trim().isNotEmpty ?? false);
      }
      
      return true;
    } on Exception catch (e) {
      dev.log("Error checking billing info: $e");
      return false;
    }
  }

  /// Show billing info bottom sheet and return true if user confirmed, false otherwise
  Future<bool> _showBillingInfoBottomSheet() async {
    SheetResponse<EmptyBottomSheetResponse>? billingSheetResponse =
        await bottomSheetService.showCustomSheet(
      isScrollControlled: true,
      variant: BottomSheetType.billingInfo,
      data: PurchaseBundleBottomSheetArgs(
        null,
        null,
        null,
      ),
    );
    return billingSheetResponse?.confirmed ?? false;
  }

  double calculateHeight(double screenHeight) {
    if (bundleItems.isEmpty) {
      return 300;
    }

    double cellHeight = 300;
    double cellsHeight = 120 + (bundleItems.length * cellHeight);

    return min(cellsHeight, screenHeight);
  }

  //#endregion

  //#region Apis
  Future<void> fetchTopUpRelated() async {
    bundleItems
      ..clear()
      ..add(BundleResponseModel(planType: "type", activityPolicy: "policy"))
      ..add(BundleResponseModel(planType: "type", activityPolicy: "policy"));

    applyShimmer = true;
    // await Future<void>.delayed(Duration(seconds: 2));
    //
    // bundleItems
    //   ..clear()
    //   ..add(
    //     BundleResponseModel(
    //       priceDisplay: LocaleKeys.bundleInfo_priceText
    //           .tr(namedArgs: {"price": "\$ 20.00"}),
    //       planType: "5 GB",
    //       bundleCode: "456456",
    //       validityDisplay: "10 days",
    //       bundleName: "Europe",
    //       activityPolicy: "policy",
    //     ),
    //   );

    Resource<List<BundleResponseModel>?> response =
        await GetRelatedTopupUseCase(locator()).execute(
      GetRelatedTopupParam(
        iccID: request.data?.iccID ?? "",
        bundleCode: request.data?.bundleCode ?? "",
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<List<BundleResponseModel>?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        bundleItems
          ..clear()
          ..addAll(result.data ?? <BundleResponseModel>[]);
        applyShimmer = false;

        // Log ViewItemListEvent now that we have actual topup options data
        await _logTopupOptionsListView();

        // Fetch taxes for each bundle
        for (final BundleResponseModel bundle in bundleItems) {
          if (bundle.bundleCode != null && bundle.bundleCode!.isNotEmpty) {
            loadingTaxesBundleCodes.add(bundle.bundleCode!);
          }
        }
        notifyListeners();

        // Now start fetching taxes for each bundle
        for (final BundleResponseModel bundle in bundleItems) {
          if (bundle.bundleCode != null && bundle.bundleCode!.isNotEmpty) {
            await loadTaxesForBundle(bundle.bundleCode!);
          }
        }
        notifyListeners();
      },
      onFailure: (Resource<List<BundleResponseModel>?> result) async {
        await handleError(response);
        closeBottomSheet();
      },
    );
  }

  Future<void> _topUpBundle({
    required String iccId,
    required String bundleCode,
    required String bundlePrice,
    required String bundleCurrency,
    required PaymentType paymentType,
    String? paymentMethodId,
  }) async {
    setViewState(ViewState.busy);
    final Resource<BundleAssignResponseModel?> response =
        await topUpUserBundleUseCase.execute(
      TopUpUserBundleParam(
        iccID: iccId,
        bundleCode: bundleCode,
        paymentType: paymentType.type,
        enableAutoTopup: autoTopupOptIn && !_pendingBundleUnlimited,
        paymentMethodId: paymentMethodId,
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<BundleAssignResponseModel?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        
        // Check if payment was completed immediately (e.g., wallet payment)
        PaymentStatus paymentStatus =
            PaymentStatus.fromString(result.data?.paymentStatus);
        if (paymentStatus == PaymentStatus.completed) {
          if (paymentType == PaymentType.wallet) {
            await _refreshUserInfo();
          }
          _handleSuccessfulPayment(
            result.data?.orderId ?? "",
            bundlePrice,
            bundleCurrency,
          );
          return;
        }
        
        // Proceed with payment flow for non-wallet payments
        initiatePaymentRequest(
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
          bundlePrice: bundlePrice,
          bundleCurrency: bundleCurrency,
          merchantDisplayName: result.data?.merchantDisplayName,
          stripeUrlScheme: result.data?.stripeUrlScheme,
          stripePaymentMethodId: paymentMethodId,
        );
      },
    );
  }

  Future<void> initiatePaymentRequest({
    required PaymentType paymentType,
    required String orderID,
    required String publishableKey,
    required String merchantIdentifier,
    required String paymentIntentClientSecret,
    required String customerId,
    required String customerEphemeralKeySecret,
    required String billingCountryCode,
    required String bundlePrice,
    required String bundleCurrency,
    String? merchantDisplayName,
    String? stripeUrlScheme,
    String? stripePaymentMethodId,
    bool test = false,
  }) async {
    // TODO (GAP 6 — app-kill during 3DS): Same as bundle_detail_bottom_sheet_view_model.
    // Persist (orderID, paymentIntentClientSecret) before entering the 3DS WebView so
    // a recovery screen can be shown on next app launch.
    // See bundle_detail_bottom_sheet_view_model._initiatePaymentRequest for full notes.
    if (_isProcessingPayment) {
      return;
    }
    _isProcessingPayment = true;
    try {
      await paymentService.prepareCheckout(
        paymentType: paymentType,
        publishableKey: publishableKey,
        merchantIdentifier: merchantIdentifier,
        urlScheme: stripeUrlScheme,
      );

      PaymentResult paymentResult = await paymentService.processOrderPayment(
        paymentType: paymentType,
        iccID: request.data?.iccID ?? "",
        orderID: orderID,
        billingCountryCode: billingCountryCode,
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerId: customerId,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
        merchantDisplayName: merchantDisplayName ?? "ChillSIM",
        testEnv: test,
        stripePaymentMethodId: stripePaymentMethodId,
      );

      setViewState(ViewState.idle);

      switch (paymentResult) {
        case PaymentResult.completed:
          _handleSuccessfulPayment(orderID, bundlePrice, bundleCurrency);

        case PaymentResult.canceled:
          cancelOrder(orderID: orderID);

        case PaymentResult.otpRequested:
          //must send api for request otp , not implemented from backend
          bool result = await locator<NavigationService>().navigateTo(
            VerifyPurchaseView.routeName,
            arguments: VerifyPurchaseViewArgs(
              iccid: request.data?.iccID ?? "",
              orderID: orderID,
            ),
            preventDuplicates: false,
          );

          if (result) {
            _handleSuccessfulPayment(orderID, bundlePrice, bundleCurrency);
          } else {
            cancelOrder(orderID: orderID);
          }
      }
    } on Exception catch (e) {
      final String errorMsg = e.toString();
      final bool isNetworkOrTimeoutError =
          errorMsg.toLowerCase().contains("no internet") ||
          errorMsg.toLowerCase().contains("timed out") ||
          errorMsg.toLowerCase().contains("connection");
      if (isNetworkOrTimeoutError) {
        dev.log("⚠️ Network/timeout error — skipping cancelOrder for $orderID (webhook may have already processed payment)");
      } else {
        unawaited(cancelOrder(orderID: orderID));
      }
      closeBottomSheet();
      showToast(
        errorMsg.replaceAll("Exception:", ""),
      );
      hideKeyboard();
      return;
    } finally {
      _isProcessingPayment = false;
    }
  }

  Future<void> _refreshUserInfo() async {
    try {
      final Resource<AuthResponseModel?> response = await GetUserInfoUseCase(locator()).execute(NoParams());
      handleResponse(
        response,
        onSuccess: (Resource<AuthResponseModel?> result) async {},
      );
    } on Exception catch (e) {
      dev.log("Error refreshing user info: $e");
    }
  }

  void _handleSuccessfulPayment(String orderID, String bundlePrice, String bundleCurrency) {
    hideKeyboard();
    String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
    unawaited(analyticsService.logEvent(
      event: AnalyticEvent.buyTopUpSuccess(
        utm: utm,
        platform: Platform.isAndroid ? "Android" : "iOS",
        amount: bundlePrice,
        currency: bundleCurrency,
      ),
    ),);
    completer(
      SheetResponse<MainBottomSheetResponse>(
        data: MainBottomSheetResponse(
          canceled: false,
          tag: orderID,
        ),
      ),
    );
  }
//#endregion
  //#taxes
  Future<void> loadTaxesForBundle(String bundleCode) async {
    loadingTaxesBundleCodes.add(bundleCode);
    notifyListeners();

    final ResponseMain<BundleTaxesResponseModel> response =
      await locator<ApiUser>().getTaxes(bundleCode: bundleCode);

    if (response.status == "success" && response.data != null) {
      bundleTaxes[bundleCode] = response.data;
    } else {
      bundleTaxes[bundleCode] = null;
    }
    loadingTaxesBundleCodes.remove(bundleCode);
    notifyListeners();
  }

  /// Log ViewItemListEvent with actual topup options data when bundles are loaded and displayed
  Future<void> _logTopupOptionsListView() async {
    if (bundleItems.isEmpty) {
      return;
    }

    // Convert topup bundles to EcommerceItem format
    final List<EcommerceItem> items = bundleItems.take(10).map((BundleResponseModel bundle) {
      return EcommerceItem(
        id: bundle.bundleCode ?? bundle.bundleName ?? "",
        name: bundle.displayTitle ?? bundle.bundleName ?? bundle.bundleMarketingName ?? "Unknown Topup",
        category: "topup_options",
        price: bundle.price ?? 0.0,
      );
    }).toList();

    await analyticsService.logEvent(
      event: ViewItemListEvent(
        listType: "topup",
        listId: request.data?.iccID, // The SIM card being topped up
        listName: "Topup Options",
        items: items,
        platform: Platform.isIOS ? "iOS" : "Android",
        currency: bundleItems.first.currencyCode, // Use first bundle's currency
      ),
    );
  }
}
