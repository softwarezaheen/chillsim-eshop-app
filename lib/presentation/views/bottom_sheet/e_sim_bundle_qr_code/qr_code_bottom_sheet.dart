import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_qr_code/qr_code_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/circular_icon_button.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:stacked_services/stacked_services.dart";

class ESimQrBottomSheet extends StatelessWidget {
  const ESimQrBottomSheet({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<BundleQrBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      hideLoader: true,
      viewModel:
          QrCodeBottomSheetViewModel(request: request, completer: completer),
      builder: (
        BuildContext context,
        QrCodeBottomSheetViewModel viewModel,
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
                    children: <Widget>[
                      //qr code details title
                      buildTopHeader(context, viewModel),
                      verticalSpaceSmall,
                      buildQrCode(context, viewModel),
                      verticalSpaceSmallMedium,
                      buildActionButtons(context, viewModel),
                      verticalSpaceSmallMedium,
                      buildInfoRow(
                        context: context,
                        label: LocaleKeys.smdp_address.tr(),
                        value: viewModel.smDpAddress ?? "",
                        isLoading: viewModel.isBusy,
                      ),
                      verticalSpaceSmall,
                      buildInfoRow(
                        context: context,
                        label: LocaleKeys.activation_code.tr(),
                        value: viewModel.activationCode ?? "",
                        isLoading: viewModel.isBusy,
                      ),
                      const SizedBox(height: 32),
                      MainButton(
                        isEnabled: !viewModel.isBusy,
                        title: LocaleKeys.goToSettings.tr(),
                        titleTextStyle: bodyBoldTextStyle(context: context),
                        onPressed: viewModel.onOpenSettingsClicked,
                        themeColor: themeColor,
                        height: 53,
                        hideShadows: false,
                        enabledTextColor:
                            enabledMainButtonTextColor(context: context),
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

  Widget buildTopHeader(
    BuildContext context,
    QrCodeBottomSheetViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        BottomSheetCloseButton(
          onTap: () => completer(SheetResponse<MainBottomSheetResponse>()),
        ),

        Text(
          LocaleKeys.qr_code_details.tr(),
          style: headerThreeMediumTextStyle(
            context: context,
            fontColor: titleTextColor(context: context),
          ),
        ),
        verticalSpaceSmallMedium,
        Text(
          LocaleKeys.qrcodeDetails_titleText.tr(),
          textAlign: TextAlign.center,
          style: bodyMediumTextStyle(
            context: context,
            fontColor: contentTextColor(context: context),
          ),
        ),

        verticalSpaceSmallMedium,
        GestureDetector(
          onTap: viewModel.onUserGuideClick,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: Border.all(
                color: userGuideButtonColor(context: context),
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: PaddingWidget.applySymmetricPadding(
              vertical: 10,
              horizontal: 15,
              child: Text(
                LocaleKeys.qrcodeDetails_checkUserGuideText.tr(),
                style: bodyBoldTextStyle(
                  context: context,
                  fontColor: userGuideButtonColor(context: context),
                ),
              ),
            ),
          ),
        ),
        // Column(
        //   children: <Widget>[
        //     Text(
        //       LocaleKeys.qr_code_details.tr(),
        //       style: headerThreeMediumTextStyle(
        //         context: context,
        //         fontColor: mainDarkTextColor(context: context),
        //       ),
        //     ),
        //     verticalSpaceSmall,
        //     Text(
        //       LocaleKeys.qr_code_sent_to_your_email.tr(),
        //       textAlign: TextAlign.center,
        //       style: captionOneMediumTextStyle(
        //         context: context,
        //         fontColor: secondaryTextColor(context: context),
        //       ),
        //     ),
        //     verticalSpaceSmall,
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: <Widget>[
        //         Text(
        //           "Please refer to ",
        //           style: captionOneMediumTextStyle(
        //             context: context,
        //             fontColor: secondaryTextColor(context: context),
        //           ),
        //         ),
        //         MyCardWrap(
        //           color: Colors.transparent,
        //           enableBorder: false,
        //           onTap: viewModel.onUserGuideClick,
        //           enableRipple: true,
        //           child: Text(
        //             "User Guide",
        //             style: captionOneMediumTextStyle(
        //               context: context,
        //               fontColor: hyperLinkColor(context: context),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Text(
        //       "for detailed instructions",
        //       style: captionOneMediumTextStyle(
        //         context: context,
        //         fontColor: secondaryTextColor(context: context),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  Widget buildQrCode(
    BuildContext context,
    QrCodeBottomSheetViewModel viewModel,
  ) {
    return SizedBox(
      height: 120,
      child: viewModel.smDpAddress != null
          ? RepaintBoundary(
              key: viewModel.globalKey,
              child: QrImageView(
                backgroundColor: context.appColors.baseWhite!,
                data: viewModel.qrCodeValue,
                size: 120,
              ).applyShimmer(
                context: context,
                enable: viewModel.isBusy,
              ),
            )
          : Text(LocaleKeys.error_generating_qr_code.tr()),
    );
  }

  Widget buildActionButtons(
    BuildContext context,
    QrCodeBottomSheetViewModel viewModel,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        viewModel.smDpAddress != null
            ? CircularIconButton(
                icon: Icons.share_outlined,
                onPressed: viewModel.onShareClick,
                backgroundColor: myEsimIconButtonColor(context: context),
                iconColor: titleTextColor(context: context),
              ).applyShimmer(
                context: context,
                enable: viewModel.isBusy,
                borderRadius: 30,
              )
            : Container(),
        viewModel.activationCode != null ? horizontalSpaceSmall : Container(),
        viewModel.activationCode != null
            ? CircularIconButton(
                icon: Icons.file_download_outlined,
                onPressed: viewModel.onDownloadClick,
                backgroundColor: myEsimIconButtonColor(context: context),
                iconColor: titleTextColor(context: context),
              ).applyShimmer(
                context: context,
                enable: viewModel.isBusy,
                borderRadius: 30,
              )
            : Container(),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<BundleQrBottomRequest>>(
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

Widget buildInfoRow({
  required BuildContext context,
  required String label,
  required String value,
  required bool isLoading,
  bool showCopy = true,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: captionOneMediumTextStyle(
                context: context,
                fontColor: titleTextColor(context: context),
              ),
            ),
            verticalSpaceTiniest,
            Text(
              value.isEmpty && isLoading ? "------------" : value,
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: contentTextColor(context: context),
              ),
              maxLines: 2,
            ).applyShimmer(context: context, enable: isLoading),
          ],
        ),
      ),
      showCopy
          ? IconButton(
              icon: Icon(
                Icons.copy,
                size: 20,
                color: secondaryIconButtonColor(context: context),
              ).applyShimmer(
                context: context,
                enable: isLoading,
                borderRadius: 30,
              ),
              onPressed: () async {
                if (value.isNotEmpty) {
                  copyText(value);
                }
              },
            )
          : const SizedBox.shrink(),
    ],
  );
}
