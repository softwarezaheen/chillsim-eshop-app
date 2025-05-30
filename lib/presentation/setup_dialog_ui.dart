import "package:esim_open_source/di/locator.dart" as loc;
import "package:esim_open_source/presentation/enums/dialog_icon_type.dart";
import "package:esim_open_source/presentation/enums/dialog_type.dart";
import "package:esim_open_source/presentation/views/dialog/main_dialog_view.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

void setupDialogUi() {
  DialogService dialogService = loc.locator<DialogService>();

  final Map<
      DialogType,
      _MainDialog Function(
        dynamic context,
        dynamic sheetRequest,
        Function(DialogResponse<MainDialogResponse> p1) completer,
      )> builders = <DialogType,
      _MainDialog Function(
    dynamic context,
    dynamic sheetRequest,
    Function(DialogResponse<MainDialogResponse> p1) completer,
  )>{
    DialogType.basic: (
      dynamic context,
      dynamic sheetRequest,
      Function(DialogResponse<MainDialogResponse>) completer,
    ) =>
        _MainDialog(
          request: sheetRequest,
          completer: completer,
        ),
  };

  dialogService.registerCustomDialogBuilders(builders);
}

class _MainDialog extends StatelessWidget {
  const _MainDialog({
    required this.request,
    required this.completer,
  });
  final DialogRequest<MainDialogRequest> request;
  final Function(DialogResponse<MainDialogResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: request.data?.dismissibleDialog ?? false,
      // Returning true allows the pop to happen, returning false prevents it.
      child: Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        child: MainBasicDialog(
          requestBase: request,
          completer: completer,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<DialogRequest<MainDialogRequest>>(
          "request",
          request,
        ),
      )
      ..add(
        ObjectFlagProperty<Function(DialogResponse<MainDialogResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}

class MainDialogRequest {
  const MainDialogRequest({
    this.iconType = DialogIconType.warning,
    this.title,
    this.description,
    this.showCancelButton = true,
    this.hideXButton = true,
    this.dismissibleDialog = false,
    this.cancelText,
    this.informativeOnly = false,
    this.mainButtonColor,
    this.mainButtonTitle,
    this.mainButtonTag,
    this.secondaryButtonColor,
    this.secondaryButtonTitle,
    this.secondaryButtonTag,
    this.descriptionTextStyle,
  });

  final DialogIconType iconType;
  final String? title;
  final String? description;
  final String? cancelText;
  final String? mainButtonTitle;
  final String? mainButtonTag;
  final String? secondaryButtonTitle;
  final String? secondaryButtonTag;
  final bool showCancelButton;
  final bool hideXButton;
  final bool informativeOnly;
  final bool dismissibleDialog;
  final Color? mainButtonColor;
  final Color? secondaryButtonColor;
  final TextStyle? descriptionTextStyle;
}

class MainDialogResponse {
  const MainDialogResponse({
    this.tag = "",
    this.canceled = true,
  });

  final String tag;
  final bool canceled;
}
