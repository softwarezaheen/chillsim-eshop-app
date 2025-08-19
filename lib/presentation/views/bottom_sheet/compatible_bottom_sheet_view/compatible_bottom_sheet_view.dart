import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/compatible_bottom_sheet_view/compatible_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class CompatibleBottomSheetView extends StatelessWidget {
  const CompatibleBottomSheetView({
    required this.completer,
    required this.requestBase,
    super.key,
  });

  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: CompatibleBottomSheetViewModel(),
      builder: (
        BuildContext context,
        CompatibleBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: screenWidth(context),
            child: PaddingWidget.applySymmetricPadding(
              vertical: 15,
              horizontal: 15,
              child: Column(
                children: <Widget>[
                  BottomSheetCloseButton(
                    onTap: () =>
                        completer(SheetResponse<EmptyBottomSheetResponse>()),
                  ),
                  Image.asset(
                    EnvironmentImages.checkCompatibleIcon.fullImagePath,
                    width: 80,
                    height: 80,
                  ),
                  verticalSpaceMediumLarge,
                  Text(
                    LocaleKeys.compatibleSheet_titleText.tr(),
                    style: headerThreeMediumTextStyle(
                      context: context,
                      fontColor: titleTextColor(context: context),
                    ),
                  ),
                  verticalSpaceLarge,
                  PaddingWidget.applySymmetricPadding(
                    horizontal: 10,
                    child: contentText(context),
                  ),
                  verticalSpaceMediumLarge,
                  MainButton(
                    title: LocaleKeys.compatibleSheet_buttonText.tr(),
                    titleTextStyle: bodyBoldTextStyle(context: context),
                    onPressed: () async {
                      completer(
                        SheetResponse<EmptyBottomSheetResponse>(
                          confirmed: true,
                        ),
                      );
                    },
                    themeColor: themeColor,
                    height: 53,
                    hideShadows: true,
                    enabledTextColor:
                        enabledMainButtonTextColor(context: context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget contentText(
    BuildContext context,
  ) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text: LocaleKeys.compatibleSheet_contentText1.tr(),
        style: bodyNormalTextStyle(
          context: context,
          fontColor: contentTextColor(context: context),
        ),
        children: <TextSpan>[
          const TextSpan(text: " "),
          TextSpan(
            text: "*#06#",
            style: bodyNormalTextStyle(
              context: context,
              fontColor: hyperLinkColor(context: context),
            ),
          ),
          const TextSpan(text: " "),
          TextSpan(
            text: LocaleKeys.compatibleSheet_contentText2.tr(),
            style: bodyNormalTextStyle(
              context: context,
              fontColor: contentTextColor(context: context),
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
        DiagnosticsProperty<SheetRequest<dynamic>>(
          "requestBase",
          requestBase,
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
