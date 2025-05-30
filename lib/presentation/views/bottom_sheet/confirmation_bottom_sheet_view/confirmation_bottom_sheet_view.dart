import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class ConfirmationBottomSheetView extends StatelessWidget {
  const ConfirmationBottomSheetView({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<ConfirmationSheetRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
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
              horizontal: 25,
              child: Column(
                children: <Widget>[
                  BottomSheetCloseButton(
                    onTap: () => completer(
                      SheetResponse<EmptyBottomSheetResponse>(),
                    ),
                  ),
                  verticalSpaceMediumLarge,
                  Text(
                    request.data?.titleText ?? "",
                    style: headerThreeMediumTextStyle(
                      context: context,
                      fontColor: mainDarkTextColor(context: context),
                    ),
                  ),
                  verticalSpaceSmallMedium,
                  Text(
                    "${request.data?.contentText ?? ""} ${request.data?.selectedText ?? ""} ?",
                    textAlign: TextAlign.center,
                    style: bodyNormalTextStyle(
                      context: context,
                      fontColor: secondaryTextColor(context: context),
                    ),
                  ),
                  verticalSpaceMediumLarge,
                  MainButton(
                    title: LocaleKeys.confirmation_confirmationButtonText.tr(),
                    titleTextStyle: bodyBoldTextStyle(context: context),
                    onPressed: () => completer(
                      SheetResponse<EmptyBottomSheetResponse>(confirmed: true),
                    ),
                    themeColor: themeColor,
                    height: 53,
                    hideShadows: true,
                    enabledTextColor:
                        enabledMainButtonTextColor(context: context),
                  ),
                  verticalSpaceSmall,
                  MainButton.onlyText(
                    title: LocaleKeys.confirmation_cancellationButtonText.tr(),
                    titleTextStyle: bodyMediumTextStyle(context: context),
                    hideShadows: true,
                    onPressed: () => completer(
                      SheetResponse<EmptyBottomSheetResponse>(),
                    ),
                    themeColor: themeColor,
                    enabledTextColor: mainDarkTextColor(context: context),
                  ),
                  verticalSpaceMedium,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            Function(SheetResponse<EmptyBottomSheetResponse> p1)>.has(
          "completer",
          completer,
        ),
      )
      ..add(
        DiagnosticsProperty<SheetRequest<dynamic>>(
          "requestBase",
          request,
        ),
      );
  }
}
