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
import "package:esim_open_source/domain/analytics/ecommerce_events.dart";
import "package:esim_open_source/domain/data/api_user.dart";
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

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(_initializeView());
  }

  Future<void> _initializeView() async {
    // Fetch bundle details for analytics
    final bundleResource = await getBundleUseCase.execute(
      BundleParams(code: request.data!.bundleCode),
    );

    if (bundleResource.resourceType == ResourceType.success && bundleResource.data != null) {
      final bundle = bundleResource.data!;
      
      // Log view topup details event
      unawaited(analyticsService.logEvent(
        event: ViewItemEvent(
          item: EcommerceItem(
            id: bundle.bundleCode ?? '',
            name: bundle.displayTitle ?? bundle.bundleName ?? '',
            category: 'topup',
            price: (bundle.price ?? 0).toDouble(),
          ),
          platform: Platform.isIOS ? 'iOS' : 'Android',
          currency: bundle.currencyCode,
        ),
      ));
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
          id: item.bundleCode ?? '',
          name: item.displayTitle ?? item.bundleName ?? '',
          category: 'topup',
          price: (item.price ?? 0).toDouble(),
          quantity: 1,
        ),
        platform: Platform.isIOS ? 'iOS' : 'Android',
        currency: item.currencyCode ?? 'EUR',
      ),
    ));
    
    // Start payment method selection flow
    unawaited(_initializeTopUpFlow(item));
  }

  Future<void> _initializeTopUpFlow(BundleResponseModel item) async {
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
            _triggerTopUpFlow(item: item, paymentType: paymentType);
          } else {
            //case not valid
            showToast(LocaleKeys.no_payment_method_available.tr());
          }
        case PaymentType.dcb:
        case PaymentType.card:
        case PaymentType.applePay:
          _triggerTopUpFlow(item: item, paymentType: paymentType);
      }
    } else {
      _choosePaymentMethod(paymentTypeList, item);
    }
  }

  Future<void> _choosePaymentMethod(
    List<PaymentType> paymentTypeList,
    BundleResponseModel item,
  ) async {
    final double price = item.price ?? 0;
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
      _triggerTopUpFlow(
        item: item,
        paymentType: response?.data ?? PaymentType.card,
      );
    }
  }

  Future<void> _triggerTopUpFlow({
    required BundleResponseModel item,
    required PaymentType paymentType,
  }) async {
    unawaited(
      _topUpBundle(
        iccId: request.data?.iccID ?? "",
        bundleCode: item.bundleCode ?? "",
        bundlePrice: item.priceDisplay ?? "",
        bundleCurrency: item.currencyCode ?? "",
        paymentType: paymentType,
      ),
    );
  }

  void closeBottomSheet() {
    completer(SheetResponse<MainBottomSheetResponse>());
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
        for (final bundle in bundleItems) {
          if (bundle.bundleCode != null && bundle.bundleCode!.isNotEmpty) {
            loadingTaxesBundleCodes.add(bundle.bundleCode!);
          }
        }
        notifyListeners();

        // Now start fetching taxes for each bundle
        for (final bundle in bundleItems) {
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
  }) async {
    setViewState(ViewState.busy);
    Resource<BundleAssignResponseModel?> response = await topUpUserBundleUseCase
        .execute(TopUpUserBundleParam(
          iccID: iccId, 
          bundleCode: bundleCode,
          paymentType: paymentType.type,
        ));
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
        iccID: request.data?.iccID ?? "",
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
      unawaited(cancelOrder(orderID: orderID));
      closeBottomSheet();
      showToast(
        e.toString().replaceAll("Exception:", ""),
      );
      hideKeyboard();
      return;
    }
  }

  Future<void> _refreshUserInfo() async {
    try {
      final Resource<AuthResponseModel?> response = await GetUserInfoUseCase(locator()).execute(NoParams());
      handleResponse(
        response,
        onSuccess: (Resource<AuthResponseModel?> result) async {},
      );
    } catch (e) {
      dev.log("Error refreshing user info: $e");
    }
  }

  void _handleSuccessfulPayment(String orderID, String bundlePrice, String bundleCurrency) {
    hideKeyboard();
    String utm = localStorageService.getString(LocalStorageKeys.utm) ?? "";
    analyticsService.logEvent(
      event: AnalyticEvent.buyTopUpSuccess(
        utm: utm,
        platform: Platform.isAndroid ? "Android" : "iOS",
        amount: bundlePrice,
        currency: bundleCurrency,
      ),
    );
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
    if (bundleItems.isEmpty) return;

    // Convert topup bundles to EcommerceItem format
    final List<EcommerceItem> items = bundleItems.take(10).map((BundleResponseModel bundle) {
      return EcommerceItem(
        id: bundle.bundleCode ?? bundle.bundleName ?? '',
        name: bundle.displayTitle ?? bundle.bundleName ?? bundle.bundleMarketingName ?? 'Unknown Topup',
        category: 'topup_options',
        price: bundle.price ?? 0.0,
      );
    }).toList();

    await analyticsService.logEvent(
      event: ViewItemListEvent(
        listType: 'topup',
        listId: request.data?.iccID, // The SIM card being topped up
        listName: 'Topup Options',
        items: items,
        platform: Platform.isIOS ? 'iOS' : 'Android',
        currency: bundleItems.first.currencyCode, // Use first bundle's currency
      ),
    );
  }
}
