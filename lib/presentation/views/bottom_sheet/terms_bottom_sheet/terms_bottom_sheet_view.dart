import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/terms_bottom_sheet/terms_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";
import "package:stacked_services/stacked_services.dart";

class TermsBottomSheetView extends StatelessWidget {
  const TermsBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });

  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: TermsBottomSheetViewModel(completer),
      builder: (
        BuildContext context,
        TermsBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        width: screenWidth(context),
        child: PaddingWidget.applySymmetricPadding(
          vertical: 15,
          horizontal: 15,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              BottomSheetCloseButton(
                onTap: () => completer(
                  SheetResponse<EmptyBottomSheetResponse>(),
                ),
              ),
              verticalSpaceSmallMedium,
              SizedBox(
                height: screenHeight / 2,
                child: SingleChildScrollView(
                  child: Html(
                    data: viewModel.getHtmlContent,
                  ),
                ),
              ),
              verticalSpaceMedium,
              MainButton(
                title: LocaleKeys.common_iAgreeText.tr(),
                onPressed: () => completer(
                  SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
                ),
                themeColor: themeColor,
                height: 53,
                hideShadows: true,
                enabledTextColor: enabledMainButtonTextColor(context: context),
                enabledBackgroundColor:
                    enabledMainButtonColor(context: context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<dynamic>>("requestBase", requestBase),
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
