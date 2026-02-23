import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/use_case/base_use_case.dart";
import "package:esim_open_source/domain/use_case/user/get_order_history_pagination_use_case.dart";
import "package:esim_open_source/domain/util/pagination/paginated_data.dart";
import "package:esim_open_source/presentation/enums/bottomsheet_type.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class OrderHistoryViewModel extends BaseModel {
  //#region UseCases
  GetOrderHistoryPaginationUseCase getOrderHistoryUseCase =
      locator<GetOrderHistoryPaginationUseCase>();

  //#endregion

  //#region Variables
  // List<OrderHistoryResponseModel>? bundles;

  PaginationService<OrderHistoryResponseModel> get orderHistoryPaginationService =>
      getOrderHistoryUseCase.paginationService;

  @override
  double? get shimmerHeight => 150;

  //#endregion

  //#region Functions
  @override
  void onViewModelReady() {
    super.onViewModelReady();
    try {
      unawaited(getOrderHistory());
    } on Exception catch (e) {
      log("Error initializing order history: $e");
    }
  }

  Future<void> orderTapped(OrderHistoryResponseModel order) async {
    SheetResponse<OrderHistoryResponseModel>? response =
        await bottomSheetService.showCustomSheet(
      data: order,
      enableDrag: false,
      isScrollControlled: true,
      variant: BottomSheetType.orderHistory,
    );

    if (response?.confirmed ?? false) {
      bottomSheetService.showCustomSheet(
        data: response?.data,
        enableDrag: false,
        isScrollControlled: true,
        variant: BottomSheetType.receiptOrder,
      );
    }
  }

  //#endregion

  //#region Apis

  Future<void> getOrderHistory() async {
    try {
      await getOrderHistoryUseCase.loadNextPage(NoParams());
    } on Exception catch (e) {
      log("Error loading order history: $e");
    }
  }

  Future<void> refreshOrderHistory() async {
    try {
      await getOrderHistoryUseCase.refreshData(NoParams());
    } on Exception catch (e) {
      log("Error refreshing order history: $e");
    }
  }
//#endregion
}
