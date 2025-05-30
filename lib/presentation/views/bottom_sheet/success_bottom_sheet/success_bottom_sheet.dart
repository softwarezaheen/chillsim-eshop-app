import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/success_bottom_sheet/success_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/network_image_cached.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class SuccessBottomSheet extends StatelessWidget {
  const SuccessBottomSheet({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<SuccessBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder<SuccessBottomSheetViewModel>(
      viewModel: SuccessBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext context,
        SuccessBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            DecoratedBox(
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 0,
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              child: SizedBox(
                width: screenWidth(context),
                child: PaddingWidget.applySymmetricPadding(
                  vertical: 15,
                  horizontal: 20,
                  child: Column(
                    spacing: 16,
                    children: <Widget>[
                      BottomSheetCloseButton(
                        onTap: () => completer(
                          SheetResponse<EmptyBottomSheetResponse>(),
                        ),
                      ),
                      CachedImage(
                        width: 65,
                        height: 65,
                        imagePath: request.data?.imagePath ?? "",
                        source: ImageSource.local,
                      ),
                      Text(
                        viewModel.request.data?.title ?? "",
                        style: headerThreeMediumTextStyle(context: context),
                      ),
                      Text(
                        viewModel.request.data?.description ?? "",
                        textAlign: TextAlign.center,
                        style: captionOneNormalTextStyle(context: context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<SuccessBottomRequest>>(
          "request",
          request,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
