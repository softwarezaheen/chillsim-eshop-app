import "dart:async";
import "dart:io";
import "dart:math";
import 'dart:developer' as dev;

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/base_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_assign_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_taxes_response_model.dart";
import "package:esim_open_source/domain/data/api_user.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/repository/services/local_storage_service.dart";
import "package:esim_open_source/domain/use_case/user/get_related_topup_use_case.dart";
import "package:esim_open_source/domain/use_case/user/top_up_user_bundle_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/esim_base_model.dart";
import "package:stacked_services/stacked_services.dart";

class TopUpBottomSheetViewModel extends EsimBaseModel {
  TopUpBottomSheetViewModel({required this.request, required this.completer});

  final Map<String, BundleTaxesResponseModel?> bundleTaxes = <String, BundleTaxesResponseModel?>{};
  final Set<String> loadingTaxesBundleCodes = <String>{};

  //#region UseCases
  final TopUpUserBundleUseCase topUpUserBundleUseCase =
      TopUpUserBundleUseCase(locator());
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
    unawaited(fetchTopUpRelated());
  }

  void onBuyClick({required int index}) {
    BundleResponseModel item = bundleItems[index];
    dev.log("Top up bundle code: ${item.bundleCode??""}");
    unawaited(
      _topUpBundle(
        iccId: request.data?.iccID ?? "",
        bundleCode: item.bundleCode ?? "",
        bundlePrice: item.priceDisplay ?? "",
        bundleCurrency: item.currencyCode ?? "",
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
  }) async {
    setViewState(ViewState.busy);
    Resource<BundleAssignResponseModel?> response = await topUpUserBundleUseCase
        .execute(TopUpUserBundleParam(iccID: iccId, bundleCode: bundleCode));
    handleResponse(
      response,
      onSuccess: (Resource<BundleAssignResponseModel?> result) async {
        if (result.data == null) {
          handleError(response);
          return;
        }
        initiatePaymentRequest(
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
        paymentType: PaymentType.card,
        publishableKey: publishableKey,
        merchantIdentifier: merchantIdentifier,
      );

      await paymentService.processOrderPayment(
        paymentType: PaymentType.card,
        iccID: request.data?.iccID ?? "",
        orderID: orderID,
        billingCountryCode: billingCountryCode,
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerId: customerId,
        customerEphemeralKeySecret: customerEphemeralKeySecret,
        testEnv: test,
      );
    } on Exception catch (e) {
      unawaited(cancelOrder(orderID: orderID));
      closeBottomSheet();
      showToast(
        e.toString().replaceAll("Exception:", ""),
      );
      hideKeyboard();
      return;
    }

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
}
