import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/share_referral_code/share_referral_code_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:stacked_services/stacked_services.dart";

class ShareReferralCodeBottomSheet extends StatelessWidget {
  const ShareReferralCodeBottomSheet({
    required this.requestBase,
    required this.completer,
    super.key,
  });
  final SheetRequest<dynamic> requestBase;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: ShareReferralCodeBottomSheetViewModel(),
      builder: (
        BuildContext context,
        ShareReferralCodeBottomSheetViewModel viewModel,
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
                horizontal: 25,
                child: Column(
                  children: <Widget>[
                    BottomSheetCloseButton(
                      onTap: () => completer(
                        SheetResponse<EmptyBottomSheetResponse>(),
                      ),
                    ),
                    Image.asset(
                      EnvironmentImages.shareIcon.fullImagePath,
                      width: 80,
                      height: 80,
                    ),
                    verticalSpaceMediumLarge,
                    Text(
                      LocaleKeys.shareReferral_titleText.tr(),
                      style: headerThreeMediumTextStyle(
                        context: context,
                        fontColor: titleTextColor(context: context),
                      ),
                    ),
                    verticalSpaceSmall,
                    Text(
                      LocaleKeys.shareReferral_contentText.tr(
                        namedArgs: <String, String>{
                          "amount": viewModel.referAndEarnAmount,
                        },
                      ),
                      textAlign: TextAlign.center,
                      style: bodyNormalTextStyle(
                        context: context,
                        fontColor: secondaryTextColor(context: context),
                      ),
                    ),
                    verticalSpaceMedium,
                    Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            LocaleKeys.shareReferral_hintText.tr(),
                            style: bodyMediumTextStyle(
                              context: context,
                              fontColor: titleTextColor(context: context),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              viewModel.referralCode,
                              style: bodyNormalTextStyle(
                                context: context,
                                fontColor: secondaryTextColor(context: context),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.copy,
                                size: 20,
                                color:
                                    secondaryIconButtonColor(context: context),
                              ),
                              onPressed: () async =>
                                  copyText(viewModel.referralCode),
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalSpaceMediumLarge,
                    Builder(
                      builder: (BuildContext btnContext) {
                        return MainButton(
                          title: LocaleKeys.shareReferral_buttonText.tr(),
                          titleTextStyle: bodyBoldTextStyle(context: context),
                          onPressed: () async {
                            final RenderBox box =
                                btnContext.findRenderObject()! as RenderBox;
                            final Rect origin =
                                box.localToGlobal(Offset.zero) & box.size;
                            await viewModel.shareButtonTapped(
                              sharePositionOrigin: origin,
                            );
                          },
                          themeColor: themeColor,
                          height: 53,
                          hideShadows: true,
                          isEnabled: !viewModel.isBusy,
                          enabledTextColor:
                              enabledMainButtonTextColor(context: context),
                        );
                      },
                    ),
                    verticalSpaceMedium,
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
