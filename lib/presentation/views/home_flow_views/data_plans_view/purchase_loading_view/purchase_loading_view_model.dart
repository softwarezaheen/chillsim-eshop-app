import "dart:async";

import "package:esim_open_source/app/app.locator.dart";
import "package:esim_open_source/data/remote/responses/bundles/purchase_esim_bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/domain/repository/services/analytics_service.dart";
import "package:esim_open_source/domain/use_case/user/get_order_by_id.dart";
import "package:esim_open_source/domain/use_case/user/get_user_purchased_esim_by_order_id_use_case.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/purchase_order_success/purchase_order_success_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view_model.dart";

class PurchaseLoadingViewModel extends BaseModel {
  String? orderID;
  String? bearerToken;

  bool isApiFetched = false;

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    unawaited(startTimer());
  }

  Future<void> startTimer() async {
    await Future<void>.delayed(const Duration(seconds: 10));
    // navigationService.back();
    unawaited(getOrderDetails());
  }

  Future<void> getOrderDetails() async {
    if (isApiFetched) {
      return;
    }
    Resource<PurchaseEsimBundleResponseModel?> response =
        await GetUserPurchasedEsimByOrderIdUseCase(locator()).execute(
      GetUserPurchasedEsimByOrderIdParam(
        orderID: orderID ?? "",
        bearerToken: bearerToken,
      ),
    );
    handleResponse(
      response,
      onSuccess: (Resource<PurchaseEsimBundleResponseModel?> result) async {
        if (result.data == null) {
          navigationService.back();
          locator.resetLazySingleton(
            instance: locator<PurchaseLoadingViewModel>(),
          );
          return;
        }

        // Get order details for ecommerce data
        Resource<OrderHistoryResponseModel?> orderResponse =
            await GetOrderByIdUseCase(locator()).execute(
          GetOrderByIdParams(orderID: result.data?.orderNumber ?? ""),
        );

        if (orderResponse.resourceType == ResourceType.success &&
            orderResponse.data != null) {
          final OrderHistoryResponseModel orderData = orderResponse.data!;
          final double amount = ((orderData.orderAmount ?? 0)).toDouble();
          final double fee = ((orderData.orderFee ?? 0)).toDouble();
          final double tax = ((orderData.orderVat ?? 0)).toDouble();
          final double total = amount + fee + tax;
          final String discount = "0"; // TODO: Add discount field if available
          await analyticsService.logEvent(
            event: AnalyticEvent.purchasedBundleApp(
              orderId: orderData.orderNumber ?? "",
              productId: orderData.bundleDetails?.bundleCode ?? "",
              productName: orderData.bundleDetails?.displayTitle ?? "",
              amount: (amount / 100).toStringAsFixed(2),
              currency: orderData.orderCurrency ?? "",
              fee: (fee / 100).toStringAsFixed(2),
              tax: (tax / 100).toStringAsFixed(2),
              total: (total / 100).toStringAsFixed(2),
              paymentType: orderData.paymentType ?? "",
              promoCode: "", // TODO: Add promoCode field if available
              discount: discount,
            ),
          );
        }

        locator<MyESimViewModel>().refreshScreen();

        navigationService.replaceWith(
          PurchaseOrderSuccessView.routeName,
          arguments: result.data,
        );
        locator.resetLazySingleton(
          instance: locator<PurchaseLoadingViewModel>(),
        );
      },
      onFailure: (Resource<PurchaseEsimBundleResponseModel?> result) async {
        await handleError(result);
        locator.resetLazySingleton(
          instance: locator<PurchaseLoadingViewModel>(),
        );
        navigationService.back();
      },
    );

    isApiFetched = true;
  }
}
