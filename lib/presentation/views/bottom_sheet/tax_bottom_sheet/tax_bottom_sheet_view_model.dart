import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class TaxBottomSheetViewModel extends BaseModel {
  TaxBottomSheetViewModel({required this.request, required this.completer});

  final SheetRequest<TaxBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;
}
