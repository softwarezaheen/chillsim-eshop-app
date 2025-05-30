import "dart:developer";

import "package:esim_open_source/presentation/setup_dialog_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:stacked_services/stacked_services.dart";

class MainDialogViewModel extends BaseModel {
  void initializeData() {
    log("initializeData ");
  }

  void closeClicked(Function(DialogResponse<MainDialogResponse>) completer) {
    completer(
      DialogResponse<MainDialogResponse>(
        data: const MainDialogResponse(),
      ),
    );
  }

  void cancelClicked(Function(DialogResponse<MainDialogResponse>) completer) {
    completer(
      DialogResponse<MainDialogResponse>(
        data: const MainDialogResponse(),
      ),
    );
  }

  void mainButtonClicked({
    required Function(DialogResponse<MainDialogResponse>) completer,
    required MainDialogRequest request,
  }) {
    completer(
      DialogResponse<MainDialogResponse>(
        data: MainDialogResponse(
          canceled: false,
          tag: request.mainButtonTag ?? "",
        ),
      ),
    );
  }

  void secondaryButtonClicked({
    required Function(DialogResponse<MainDialogResponse>) completer,
    required MainDialogRequest request,
  }) {
    completer(
      DialogResponse<MainDialogResponse>(
        data: MainDialogResponse(
          canceled: false,
          tag: request.secondaryButtonTag ?? "",
        ),
      ),
    );
  }
}
