import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/cashback_reward_bottom_sheet/cashback_reward_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/my_card_wrap.dart";
import "package:esim_open_source/presentation/widgets/network_image_cached.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class CashbackRewardBottomSheet extends StatelessWidget {
  const CashbackRewardBottomSheet({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<CashbackRewardBottomRequest> request;
  final Function(SheetResponse<EmptyBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder<CashbackRewardBottomSheetViewModel>(
      viewModel: CashbackRewardBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext context,
        CashbackRewardBottomSheetViewModel viewModel,
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
                      MyCardWrap(
                        borderRadius: 50,
                        padding: const EdgeInsets.all(20),
                        color: context.appColors.primary_25,
                        enableBorder: false,
                        child: CachedImage(
                          width: 45,
                          height: 45,
                          imagePath: request.data?.imagePath ?? "",
                          source: ImageSource.local,
                        ),
                      ),
                      Text(
                        viewModel.request.data?.title ?? "",
                        style: headerThreeMediumTextStyle(context: context),
                      ),
                      MyCardWrap(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              viewModel.request.data?.percent ?? "",
                              textAlign: TextAlign.center,
                              style:
                                  bodyBoldTextStyle(context: context).copyWith(
                                fontSize: 48,
                              ),
                            ),
                            Text(
                              viewModel.request.data?.description ?? "",
                              textAlign: TextAlign.center,
                              style:
                                  captionOneNormalTextStyle(context: context),
                            ),
                          ],
                        ),
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
        DiagnosticsProperty<SheetRequest<CashbackRewardBottomRequest>>(
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
