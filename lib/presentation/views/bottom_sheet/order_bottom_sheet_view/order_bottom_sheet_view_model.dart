import "dart:async";
import "dart:developer";

import "package:esim_open_source/data/remote/responses/user/order_history_response_model.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/use_case/user/get_order_by_id.dart";
import "package:esim_open_source/domain/util/resource.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class OrderBottomSheetViewModel extends BaseModel {
  OrderBottomSheetViewModel({
    required this.initBundleOrderModel,
    required this.completer,
  });

  OrderHistoryResponseModel? bundleOrderModel;
  OrderHistoryResponseModel? initBundleOrderModel;
  final Function(SheetResponse<OrderHistoryResponseModel>) completer;

  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;

  GetOrderByIdUseCase getOrderByIdUseCase = GetOrderByIdUseCase(locator());

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    unawaited(getOrderByID());
  }

  Future<void> getOrderByID() async {
    bundleOrderModel = OrderHistoryResponseModel().mockData().first;

    applyShimmer = true;

    Resource<OrderHistoryResponseModel?> response =
        await getOrderByIdUseCase.execute(
      GetOrderByIdParams(
        orderID: initBundleOrderModel?.orderNumber ?? "",
      ),
    );

    handleResponse(
      response,
      onSuccess: (Resource<OrderHistoryResponseModel?> result) async {
        bundleOrderModel = result.data;
        log(result.data?.toString() ?? "No Data");
        _isButtonEnabled = true;
      },
      onFailure: (Resource<OrderHistoryResponseModel?> result) async {
        bundleOrderModel = null;
        await handleError(response);
        completer(
          SheetResponse<OrderHistoryResponseModel>(),
        );
      },
    );

    applyShimmer = false;
  }
}
