import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_response_model.dart";
import "package:esim_open_source/data/remote/responses/bundles/bundle_taxes_response_model.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/e_sim_top_up/top_up_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/widgets/bundle_divider_view.dart";
import "package:esim_open_source/presentation/widgets/bottom_sheet_close_button.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/presentation/widgets/unlimited_data_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class TopUpBottomSheet extends StatelessWidget {
  const TopUpBottomSheet({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<BundleTopUpBottomRequest> request;
  final Function(SheetResponse<MainBottomSheetResponse>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: TopUpBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext context,
        TopUpBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(
            width: screenWidth(context),
            height: viewModel.calculateHeight(screenHeight),
            child: PaddingWidget.applySymmetricPadding(
              vertical: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  PaddingWidget.applySymmetricPadding(
                    horizontal: 20,
                    child: buildTopHeader(context, viewModel),
                  ),
                  verticalSpaceSmall,
                  viewModel.bundleItems.isEmpty
                      ? SizedBox(
                          height: 150,
                          child: Center(
                            child: Text(
                              LocaleKeys.noDataAvailableYet.tr(),
                              style: bodyNormalTextStyle(
                                context: context,
                                fontColor: contentTextColor(context: context),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: PaddingWidget.applySymmetricPadding(
                            horizontal: 15,
                            child: buildTopUpList(context, viewModel),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopHeader(
    BuildContext context,
    TopUpBottomSheetViewModel viewModel,
  ) {
    return Column(
      children: <Widget>[
        BottomSheetCloseButton(
          onTap: viewModel.closeBottomSheet,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            LocaleKeys.top_up_plan.tr(),
            style: headerThreeMediumTextStyle(
              context: context,
              fontColor: titleTextColor(context: context),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTopUpList(
    BuildContext context,
    TopUpBottomSheetViewModel viewModel,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: viewModel.bundleItems.length,
      itemBuilder: (BuildContext context, int index) {
        BundleResponseModel item = viewModel.bundleItems[index];
        return EsimBundleTopUpWidget(
          taxes: viewModel.bundleTaxes[item.bundleCode],
          isTaxesLoading: viewModel.loadingTaxesBundleCodes.contains(item.bundleCode),
          priceButtonText: "${item.priceDisplay} - Buy Now",
          title: item.bundleName ?? "",
          data: item.gprsLimitDisplay ?? "",
          showUnlimitedData: item.unlimited ?? false,
          validFor: item.validityDisplay ?? "",
          onPriceButtonClick: () {
            viewModel.onBuyClick(index: index);
          },
          isLoading: viewModel.applyShimmer,
          icon: item.icon ?? "",
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<SheetRequest<BundleTopUpBottomRequest>>(
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

class EsimBundleTopUpWidget extends StatelessWidget {
  const EsimBundleTopUpWidget({
    required this.priceButtonText,
    required this.title,
    required this.data,
    required this.validFor,
    required this.onPriceButtonClick,
    required this.isLoading,
    required this.icon,
    required this.showUnlimitedData,
    this.taxes,
    this.isTaxesLoading = false,
    super.key,
  });

  final BundleTaxesResponseModel? taxes;
  final bool isTaxesLoading;
  final String priceButtonText;
  final String title;
  final String data;
  final String validFor;
  final bool isLoading;
  final bool showUnlimitedData;
  final String icon;
  final VoidCallback onPriceButtonClick;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: mainBorderColor(context: context),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CountryFlagImage(icon: icon)
                    .applyShimmer(context: context, enable: isLoading),
                horizontalSpaceSmall,
                Expanded(
                  child: Text(
                    title,
                    style: captionOneMediumTextStyle(
                      context: context,
                      fontColor:
                          regionCountryBundleTitleTextColor(context: context),
                    ),
                  ).applyShimmer(
                    context: context,
                    enable: isLoading,
                    width: 50,
                  ),
                ),
                showUnlimitedData
                    ? const UnlimitedDataWidget()
                    : Text(
                        data,
                        style: headerOneBoldTextStyle(
                          context: context,
                          fontColor: bundleDataPriceTextColor(context: context),
                        ),
                      ).applyShimmer(context: context, enable: isLoading),
              ],
            ),
            const BundleDivider(),
            Text(
              "${LocaleKeys.validity.tr()} $validFor",
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: contentTextColor(context: context),
              ),
            ).applyShimmer(context: context, enable: isLoading),
            const BundleDivider(),
            if (isTaxesLoading) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  horizontalSpaceSmall,
                  Text(
                    "loading...",
                    style: captionTwoNormalTextStyle(
                      context: context,
                      fontColor: contentTextColor(context: context),
                    ),
                  ),
                ],
              ),
            ] else if (taxes != null && taxes?.total != null) ...[
              Text(
                (taxes?.currency != taxes?.displayCurrency && 
                  taxes?.exchangeRate != null &&
                  taxes?.exchangeRate != 0)
                    ? "${LocaleKeys.bundle_total_amount.tr()}: ${((taxes?.total! ?? 0) / (taxes?.exchangeRate! ?? 1)/ 100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""} (incl. ${((taxes?.fee! ?? 0) / (taxes?.exchangeRate! ?? 1) / 100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""} ${LocaleKeys.bundle_processing_fee.tr()}, ${((taxes?.vat! ?? 0) / (taxes?.exchangeRate! ?? 1) / 100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""} ${LocaleKeys.bundle_vat_amount.tr()}, ${((taxes?.total! ?? 0) / 100).toStringAsFixed(2)} ${taxes?.currency ?? ""} ${LocaleKeys.bundle_total_amount.tr()})"
                    : "${LocaleKeys.bundle_total_amount.tr()}: ${((taxes?.total! ?? 0)/100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""} (incl. ${((taxes?.fee ?? 0)/100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""} ${LocaleKeys.bundle_processing_fee.tr()}, ${((taxes?.vat ?? 0)/100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""} ${LocaleKeys.bundle_vat_amount.tr()})",
                style: captionTwoNormalTextStyle(
                  context: context,
                  fontColor: contentTextColor(context: context),
                ),
              ).applyShimmer(context: context, enable: isLoading),
            ],
            verticalSpaceMedium,
            // Price Button
            Row(
              children: <Widget>[
                MainButton(
                  hideShadows: true,
                  horizontalPadding: 12,
                  title:
                    (taxes?.currency != taxes?.displayCurrency && 
                    taxes?.exchangeRate != null &&
                    taxes?.exchangeRate != 0) ?
                      LocaleKeys.bundleInfo_priceText.tr(namedArgs: {
                        "price": "${((taxes?.total! ?? 0) / 100).toStringAsFixed(2)} ${taxes?.currency ?? ""}",
                      })
                      : (( taxes != null && taxes?.total != null) ?
                        LocaleKeys.bundleInfo_priceText.tr(namedArgs: {
                          "price": "${((taxes?.total! ?? 0) / 100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""}",
                        })
                        : priceButtonText),
                  themeColor: themeColor,
                  onPressed: onPriceButtonClick,
                  enabledTextColor:
                      enabledMainButtonTextColor(context: context),
                  enabledBackgroundColor:
                      enabledMainButtonColor(context: context),
                  titleTextStyle: captionOneMediumTextStyle(
                    context: context,
                  ),
                ).applyShimmer(context: context, enable: isLoading),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("priceButtonText", priceButtonText))
      ..add(StringProperty("title", title))
      ..add(StringProperty("data", data))
      ..add(StringProperty("validFor", validFor))
      ..add(
        ObjectFlagProperty<VoidCallback>.has(
          "onPriceButtonClick",
          onPriceButtonClick,
        ),
      )
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading))
      ..add(StringProperty("icon", icon))
      ..add(DiagnosticsProperty<bool>("showUnlimitedData", showUnlimitedData));
  }
}
