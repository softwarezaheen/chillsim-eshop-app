import "dart:async";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/logout_bottom_sheet/logout_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class LogoutBottomSheet extends StatelessWidget {
  const LogoutBottomSheet({
    required this.requestBase,
    required this.completer,
    super.key,
  });
  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: LogoutBottomSheetViewModel(),
      builder: (
        BuildContext context,
        LogoutBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          Column(
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
                horizontal: 15,
                child: Column(
                  children: <Widget>[
                    BottomSheetCloseButton(
                      onTap: () => completer(
                        SheetResponse<EmptyBottomSheetResponse>(),
                      ),
                    ),
                    Image.asset(
                      EnvironmentImages.logoutIcon.fullImagePath,
                      width: 80,
                      height: 80,
                    ),
                    verticalSpaceMediumLarge,
                    Text(
                      LocaleKeys.logout_titleText.tr(),
                      style: headerThreeMediumTextStyle(
                        context: context,
                        fontColor: mainDarkTextColor(context: context),
                      ),
                    ),
                    verticalSpaceSmallMedium,
                    Text(
                      LocaleKeys.logout_contentText.tr(),
                      textAlign: TextAlign.center,
                      style: bodyNormalTextStyle(
                        context: context,
                        fontColor: secondaryTextColor(context: context),
                      ),
                    ),
                    verticalSpaceMediumLarge,
                    MainButton(
                      title: LocaleKeys.logout_buttonTitleText.tr(),
                      titleTextStyle: bodyBoldTextStyle(context: context),
                      onPressed: () async {
                        unawaited(viewModel.logoutButtonTapped());
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
                    verticalSpaceSmall,
                    MainButton.onlyText(
                      title: LocaleKeys.common_cancelButtonText.tr(),
                      titleTextStyle: bodyMediumTextStyle(context: context),
                      hideShadows: true,
                      onPressed: () => completer(
                        SheetResponse<EmptyBottomSheetResponse>(),
                      ),
                      themeColor: themeColor,
                      enabledTextColor: mainDarkTextColor(context: context),
                    ),
                  ],
                ),
              ),
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
