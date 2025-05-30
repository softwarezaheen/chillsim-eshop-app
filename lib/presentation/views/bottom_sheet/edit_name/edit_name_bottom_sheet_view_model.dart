import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:flutter/cupertino.dart";
import "package:stacked_services/stacked_services.dart";

class EditNameBottomSheetViewModel extends BaseModel {
  EditNameBottomSheetViewModel({
    required this.request,
    required this.completer,
  });

  final TextEditingController controller = TextEditingController();
  bool _isButtonEnabled = false;
  bool get isButtonEnabled => _isButtonEnabled;
  final SheetRequest<BundleEditNameRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  void onViewModelReady() {
    controller
      ..addListener(_inputTextListener)
      ..text = request.data?.name ?? "";
  }

  void closeBottomSheet() {
    completer(SheetResponse<MainBottomSheetResponse>());
  }

  void _inputTextListener() {
    _isButtonEnabled = controller.text.isNotEmpty;
    notifyListeners();
  }

  void onSaveClick() {
    completer(
      SheetResponse<MainBottomSheetResponse>(
        data: MainBottomSheetResponse(tag: controller.text, canceled: false),
      ),
    );
  }
}
