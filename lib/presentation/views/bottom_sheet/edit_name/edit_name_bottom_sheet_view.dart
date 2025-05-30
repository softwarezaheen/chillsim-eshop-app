import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/edit_name/edit_name_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/main_input_field.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class EditNameBottomSheetView extends StatelessWidget {
  const EditNameBottomSheetView({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<BundleEditNameRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: EditNameBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext context,
        EditNameBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          PaddingWidget.applySymmetricPadding(
            vertical: 10,
            horizontal: 15,
            child: BottomSheetCloseButton(
              onTap: viewModel.closeBottomSheet,
            ),
          ),
          // Main content as a separate component
          PaddingWidget.applyPadding(
            start: 16,
            end: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title
                Center(
                  child: Text(
                    LocaleKeys.edit_name.tr(),
                    style: headerThreeMediumTextStyle(
                      context: context,
                      fontColor: mainDarkTextColor(context: context),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                MainInputField.formField(
                  themeColor: themeColor,
                  labelTitleText:
                      LocaleKeys.accountInformation_namePlaceHolderText.tr(),
                  hintText: viewModel.request.data?.name ?? "",
                  controller: viewModel.controller,
                  textInputType: TextInputType.text,
                  backGroundColor: context.appColors.baseWhite,
                  labelStyle: bodyNormalTextStyle(
                    context: context,
                    fontColor: secondaryTextColor(context: context),
                  ),
                ),
                const SizedBox(height: 24),

                MainButton(
                  isEnabled: viewModel.isButtonEnabled,
                  title: LocaleKeys.accountInformation_saveText.tr(),
                  onPressed: viewModel.onSaveClick,
                  themeColor: themeColor,
                  hideShadows: true,
                  enabledTextColor: mainWhiteTextColor(context: context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<BundleEditNameRequest>>(
          "request",
          request,
        ),
      )
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<MainBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      );
  }
}
