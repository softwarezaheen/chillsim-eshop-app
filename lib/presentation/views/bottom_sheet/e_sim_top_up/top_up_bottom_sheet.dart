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
                  // Auto-topup opt-in checkbox (hidden if already enabled or all unlimited)
                  if (viewModel.isUserLoggedIn &&
                      !viewModel.allBundlesUnlimited &&
                      !(request.data?.isAutoTopupEnabled ?? false))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: themeColor.withValues(alpha: 0.25),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            InkWell(
                              onTap: () => viewModel.setAutoTopupOptIn(
                                value: !viewModel.autoTopupOptIn,
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: Checkbox(
                                      value: viewModel.autoTopupOptIn,
                                      onChanged: (bool? value) =>
                                          viewModel.setAutoTopupOptIn(
                                        value: value ?? false,
                                      ),
                                      activeColor: themeColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      LocaleKeys.auto_topup_enable_button
                                          .tr(),
                                      style: bodyNormalTextStyle(
                                        context: context,
                                        fontColor: contentTextColor(
                                          context: context,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 4,
                                left: 32,
                              ),
                              child: Text(
                                LocaleKeys.auto_topup_checkout_hint.tr(),
                                style: captionTwoNormalTextStyle(
                                  context: context,
                                  fontColor: contentTextColor(
                                    context: context,
                                  ).withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // Stripe disclaimer (only when auto-topup section is NOT shown)
                  if (!viewModel.isUserLoggedIn ||
                      viewModel.allBundlesUnlimited ||
                      (request.data?.isAutoTopupEnabled ?? false))
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 4,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.lock_outline,
                            size: 14,
                            color: contentTextColor(context: context),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              LocaleKeys.paymentSelection_stripeNotice.tr(),
                              style: captionOneNormalTextStyle(
                                context: context,
                                fontColor: contentTextColor(context: context),
                            ),
                          ),
                        ),
                      ],
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
          isTaxesLoading:
              viewModel.loadingTaxesBundleCodes.contains(item.bundleCode),
          priceButtonText: LocaleKeys.bundleInfo_priceText.tr(
            namedArgs: <String, String>{
              "price": item.priceDisplay ?? "",
            },
          ),
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

  /// Builds the tax display text based on taxMode and feeEnabled settings.
  /// - Fee is only shown if feeEnabled is true
  /// - VAT is only shown if taxMode is "exclusive"
  String _buildTaxDisplayText(BundleTaxesResponseModel taxes) {
    final bool hasDifferentCurrency = taxes.currency != taxes.displayCurrency &&
        taxes.exchangeRate != null &&
        taxes.exchangeRate != 0;
    final bool showFee = taxes.feeEnabled ?? true;
    final bool showVat = taxes.taxMode == "exclusive";

    // Build the included items list based on conditions
    final List<String> includedItems = <String>[];

    if (showFee) {
      final String feeAmount = hasDifferentCurrency
          ? ((taxes.fee ?? 0) / (taxes.exchangeRate ?? 1) / 100)
              .toStringAsFixed(2)
          : ((taxes.fee ?? 0) / 100).toStringAsFixed(2);
      final String feeCurrency = hasDifferentCurrency
          ? (taxes.displayCurrency ?? "")
          : (taxes.displayCurrency ?? "");
      includedItems.add(
          "$feeAmount $feeCurrency ${LocaleKeys.bundle_processing_fee.tr()}",);
    }

    if (showVat) {
      final String vatAmount = hasDifferentCurrency
          ? ((taxes.vat ?? 0) / (taxes.exchangeRate ?? 1) / 100)
              .toStringAsFixed(2)
          : ((taxes.vat ?? 0) / 100).toStringAsFixed(2);
      final String vatCurrency = hasDifferentCurrency
          ? (taxes.displayCurrency ?? "")
          : (taxes.displayCurrency ?? "");
      includedItems
          .add("$vatAmount $vatCurrency ${LocaleKeys.bundle_vat_amount.tr()}");
    }

    // Build total amount display
    final String totalAmount = hasDifferentCurrency
        ? ((taxes.total ?? 0) / (taxes.exchangeRate ?? 1) / 100)
            .toStringAsFixed(2)
        : ((taxes.total ?? 0) / 100).toStringAsFixed(2);
    final String totalCurrency = hasDifferentCurrency
        ? (taxes.displayCurrency ?? "")
        : (taxes.displayCurrency ?? "");

    // If there are included items, show them in parentheses
    if (includedItems.isNotEmpty) {
      String result =
          "${LocaleKeys.bundle_total_amount.tr()}: $totalAmount $totalCurrency (incl. ${includedItems.join(", ")}";
      // Add original currency total if different currencies
      if (hasDifferentCurrency) {
        result +=
            ", ${((taxes.total ?? 0) / 100).toStringAsFixed(2)} ${taxes.currency ?? ""} ${LocaleKeys.bundle_total_amount.tr()}";
      }
      result += ")";
      return result;
    } else {
      // No fee or VAT to show - just display the total
      return "${LocaleKeys.bundle_total_amount.tr()}: $totalAmount $totalCurrency";
    }
  }

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
            if (isTaxesLoading) ...<Widget>[
              const SizedBox(height: 8),
              Row(
                children: <Widget>[
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
            ] else if (taxes != null && taxes?.total != null) ...<Widget>[
              Text(
                _buildTaxDisplayText(taxes!),
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
                  title: (taxes?.currency != taxes?.displayCurrency &&
                          taxes?.exchangeRate != null &&
                          taxes?.exchangeRate != 0)
                      ? LocaleKeys.bundleInfo_priceText.tr(namedArgs: <String, String>{
                          "price":
                              "${((taxes?.total! ?? 0) / 100).toStringAsFixed(2)} ${taxes?.currency ?? ""}",
                        },)
                      : ((taxes != null && taxes?.total != null)
                          ? LocaleKeys.bundleInfo_priceText.tr(namedArgs: <String, String>{
                              "price":
                                  "${((taxes?.total! ?? 0) / 100).toStringAsFixed(2)} ${taxes?.displayCurrency ?? ""}",
                            },)
                          : priceButtonText),
                  themeColor: themeColor,
                  onPressed: isTaxesLoading ? () {} : onPriceButtonClick,
                  enabledTextColor:
                      enabledMainButtonTextColor(context: context),
                  enabledBackgroundColor:
                      enabledMainButtonColor(context: context),
                  disabledTextColor: Colors.grey,
                  disabledBackgroundColor: Colors.grey.withValues(alpha: 0.3),
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
      ..add(DiagnosticsProperty<bool>("showUnlimitedData", showUnlimitedData))
      ..add(DiagnosticsProperty<BundleTaxesResponseModel?>("taxes", taxes))
      ..add(DiagnosticsProperty<bool>("isTaxesLoading", isTaxesLoading));
  }
}
