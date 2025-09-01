import "dart:developer";

import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/main_base_model.dart";
import "package:stacked_services/stacked_services.dart";

class ServicesBottomViewModel extends MainBaseModel {
  void initializeData() {
    log("initializeData ");
  }

  void actionButtonClicked({
    required String tag,
    required Function(SheetResponse<MainBottomSheetResponse>) completer,
    required ServicesBottomRequest request,
  }) {
    completer(
      SheetResponse<MainBottomSheetResponse>(
        data: MainBottomSheetResponse(tag: tag, canceled: false),
      ),
    );
  }
}
