import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_bundle_consumption/consumption_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/animated_circular_progress_indicator.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/top_up_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class ConsumptionBottomSheetView extends StatelessWidget {
  const ConsumptionBottomSheetView({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<BundleConsumptionBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      hideLoader: true,
      viewModel: ConsumptionBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext context,
        ConsumptionBottomSheetViewModel viewModel,
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
                horizontal: 20,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buildTopHeader(context, viewModel),
                    verticalSpaceLarge,
                    buildConsumptionView(
                      context,
                      viewModel,
                    ),
                    verticalSpaceLarge,
                    (viewModel.state.errorMessage == null &&
                            viewModel.state.showTopUP)
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              TopUpButton(
                                onClick: viewModel.onTopUpClick,
                                isLoading: viewModel.isBusy,
                              ),
                            ],
                          )
                        : Container(),
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

  Widget buildTopHeader(
    BuildContext context,
    ConsumptionBottomSheetViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        BottomSheetCloseButton(
          onTap: viewModel.closeBottomSheet,
        ),
        Text(
          LocaleKeys.consumption_details.tr(),
          style: headerThreeMediumTextStyle(
            context: context,
            fontColor: mainDarkTextColor(context: context),
          ),
        ),
      ],
    );
  }

  Widget buildConsumptionView(
    BuildContext context,
    ConsumptionBottomSheetViewModel viewModel,
  ) {
    bool isUnlimitedData = request.data?.isUnlimitedData ?? false;

    return SizedBox(
      width: 230,
      height: isUnlimitedData ? 50 : 230,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          viewModel.state.errorMessage != null
              ? Container()
              : isUnlimitedData
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          LocaleKeys.unlimited.tr(),
                          style: unlimitedBoldTextStyle(
                            context: context,
                            fontColor: mainDarkTextColor(context: context),
                          ),
                        ),
                        Text(
                          LocaleKeys.unlimited_data_bundle.tr(),
                          style: unlimitedDataBundleTextStyle(
                            context: context,
                            fontColor: mainDarkTextColor(context: context),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(
                      width: 230,
                      height: 230,
                      child: AnimatedCircularProgressIndicator(
                        targetValue: viewModel.state.consumption,
                        valueColor: consumptionValueColor(context: context),
                        backgroundColor:
                            consumptionBackgroundColor(context: context),
                        isLoading: viewModel.isBusy,
                      ),
                    ),
          viewModel.state.errorMessage != null
              ? Text(viewModel.state.errorMessage ?? "")
              : isUnlimitedData
                  ? Container()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          viewModel.state.percentageUI,
                          textAlign: TextAlign.center,
                          style: headerOneBoldTextStyle(
                            context: context,
                            fontColor: mainDarkTextColor(context: context),
                          ),
                        ).applyShimmer(
                          context: context,
                          enable: viewModel.isBusy,
                        ),
                        verticalSpaceSmall,
                        Text(
                          viewModel.state.consumptionText,
                          textAlign: TextAlign.center,
                          style: captionTwoNormalTextStyle(
                            context: context,
                            fontColor: contentTextColor(context: context),
                          ),
                        ).applyShimmer(
                          context: context,
                          enable: viewModel.isBusy,
                        ),
                        verticalSpaceTiniest,
                        Text(
                          LocaleKeys.data_consumed.tr(),
                          textAlign: TextAlign.center,
                          style: captionTwoNormalTextStyle(
                            context: context,
                            fontColor: contentTextColor(context: context),
                          ),
                        ).applyShimmer(
                          context: context,
                          enable: viewModel.isBusy,
                        ),
                      ],
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
        DiagnosticsProperty<SheetRequest<BundleConsumptionBottomRequest>>(
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
