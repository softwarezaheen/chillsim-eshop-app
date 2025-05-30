import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class SuccessBottomSheetViewModel extends BaseModel {
  SuccessBottomSheetViewModel({required this.request, required this.completer});

  final SheetRequest<SuccessBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;
}
