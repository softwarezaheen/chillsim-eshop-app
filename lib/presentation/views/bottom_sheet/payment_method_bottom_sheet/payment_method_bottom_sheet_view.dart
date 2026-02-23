import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/user/saved_payment_method_response_model.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/setup_bottom_sheet_ui.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/bottom_sheet/payment_method_bottom_sheet/payment_method_bottom_sheet_view_model.dart";
import "package:esim_open_source/presentation/widgets/payment_methods_card.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class PaymentMethodBottomSheetView extends StatelessWidget {
  const PaymentMethodBottomSheetView({
    required this.request,
    required this.completer,
    super.key,
  });

  final SheetRequest<SavedPaymentMethodSheetRequest> request;
  final Function(SheetResponse<SavedPaymentMethodSheetResult>) completer;

  @override
  Widget build(BuildContext context) {
    return BaseView.bottomSheetBuilder(
      viewModel: PaymentMethodBottomSheetViewModel(
        request: request,
        completer: completer,
      ),
      builder: (
        BuildContext context,
        PaymentMethodBottomSheetViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Close button
            Container(
              alignment: Alignment.bottomRight,
              child: CloseButton(
                onPressed: viewModel.onDismiss,
              ),
            ),
            // Title + items
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    LocaleKeys.paymentSelection_titleText.tr(),
                    style: headerThreeMediumTextStyle(
                      context: context,
                      fontColor: context.appColors.secondary_600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 1. Wallet option
                  if (viewModel.showWallet)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: viewModel.onSelectWallet,
                        child: PaymentMethodCard(
                          backgroundColor: viewModel.hasSufficientWalletBalance
                              ? greyBackGroundColor(context: context)
                              : Colors.grey.withValues(alpha: 0.5),
                          icon: Icons.account_balance_wallet_outlined,
                          imagePath: PaymentType.wallet.sectionImagePath,
                          iconColor: viewModel.hasSufficientWalletBalance
                              ? Colors.black
                              : Colors.grey,
                          iconSize: 50,
                          circleSize: 50,
                          text:
                              "${LocaleKeys.paymentSelection_walletText.tr()} (${viewModel.walletBalance.toStringAsFixed(2)} ${viewModel.currency})",
                          textStyle: bodyNormalTextStyle(
                            context: context,
                            fontColor: viewModel.hasSufficientWalletBalance
                                ? bubbleCountryTextColor(context: context)
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  // 2. Saved payment methods (default first, expired filtered out)
                  if (viewModel.isLoadingPaymentMethods)
                    ...List<Widget>.generate(
                      2,
                      (int _) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PaymentMethodCard(
                          backgroundColor: greyBackGroundColor(context: context),
                          imagePath: PaymentType.card.sectionImagePath,
                          icon: Icons.credit_card,
                          iconSize: 50,
                          circleSize: 50,
                          text: "\u2022\u2022\u2022\u2022",
                          textStyle: bodyNormalTextStyle(
                            context: context,
                            fontColor: bubbleCountryTextColor(context: context),
                          ),
                        ),
                      ),
                    ),
                  ...viewModel.visiblePaymentMethods.map(
                    (SavedPaymentMethodResponseModel pm) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () => viewModel.onSelectSavedPm(pm),
                        child: PaymentMethodCard(
                          backgroundColor: greyBackGroundColor(context: context),
                          icon: _getPaymentMethodIcon(pm.type ?? "card"),
                          imagePath: _getPaymentMethodImagePath(pm.type ?? "card"),
                          iconColor: bubbleCountryTextColor(context: context),
                          iconSize: 50,
                          circleSize: 50,
                          text: _buildPmDisplayText(pm),
                          subtitle: _buildPmSubtitle(pm),
                          trailingChipLabel: (pm.isDefault ?? false)
                              ? LocaleKeys.paymentSelection_defaultBadge.tr()
                              : null,
                          textStyle: bodyNormalTextStyle(
                            context: context,
                            fontColor: bubbleCountryTextColor(context: context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Load more
                  if (viewModel.hasMore)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: viewModel.onLoadMore,
                        child: Text(
                          LocaleKeys.paymentSelection_showMoreCards.tr(
                            namedArgs: <String, String>{
                              "count":
                                  viewModel.hiddenCount.toString(),
                            },
                          ),
                          style: captionTwoNormalTextStyle(
                            context: context,
                            fontColor: context.appColors.primary_800,
                          ),
                        ),
                      ),
                    ),
                  // Hide saved cards
                  if (viewModel.isShowingAll &&
                      viewModel.totalPaymentMethods > 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: viewModel.onHideCards,
                        child: Text(
                          LocaleKeys.paymentSelection_hideCards.tr(),
                          style: captionTwoNormalTextStyle(
                            context: context,
                            fontColor: context.appColors.primary_800,
                          ),
                        ),
                      ),
                    ),
                  // 3. New Credit/Debit Card option
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: viewModel.onSelectNewCard,
                      child: PaymentMethodCard(
                        backgroundColor: greyBackGroundColor(context: context),
                        icon: Icons.credit_card,
                        imagePath: PaymentType.card.sectionImagePath,
                        iconSize: 50,
                        circleSize: 50,
                        text: LocaleKeys.paymentSelection_newCardText.tr(),
                        textStyle: bodyNormalTextStyle(
                          context: context,
                          fontColor: bubbleCountryTextColor(context: context),
                        ),
                      ),
                    ),
                  ),
                  // Stripe disclaimer
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      border: Border.all(color: Colors.blue.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            LocaleKeys.paymentSelection_stripeNotice.tr(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade900,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build main display text for a saved payment method (name only).
  String _buildPmDisplayText(SavedPaymentMethodResponseModel pm) {
    return _getPaymentMethodDisplayName(pm);
  }

  /// Build optional subtitle (expiry for cards, email for Stripe Link).
  String? _buildPmSubtitle(SavedPaymentMethodResponseModel pm) {
    if (pm.expMonth != null && pm.expYear != null) {
      return LocaleKeys.payment_methods_expires.tr(
        namedArgs: <String, String>{
          "date": "${pm.expMonth}/${pm.expYear}",
        },
      );
    }
    if (pm.type?.toLowerCase() == "link" && pm.email != null) {
      return pm.email;
    }
    return null;
  }

  /// Get the asset image path for a payment method type (null = use icon fallback).
  String? _getPaymentMethodImagePath(String type) {
    switch (type.toLowerCase()) {
      case "card":
        return PaymentType.card.sectionImagePath;
      case "link":
      case "us_bank_account":
      case "sepa_debit":
      case "apple_pay":
      case "google_pay":
      default:
        return null;
    }
  }

  /// Get the appropriate icon based on payment method type.
  IconData _getPaymentMethodIcon(String type) {
    switch (type.toLowerCase()) {
      case "link":
        return Icons.link;
      case "us_bank_account":
      case "sepa_debit":
        return Icons.account_balance;
      case "apple_pay":
      case "google_pay":
        return Icons.account_balance_wallet;
      case "card":
      default:
        return Icons.credit_card;
    }
  }

  /// Get the display name for a payment method.
  String _getPaymentMethodDisplayName(SavedPaymentMethodResponseModel pm) {
    switch (pm.type?.toLowerCase()) {
      case "link":
        return "Stripe Link";
      case "us_bank_account":
        return pm.last4 != null
            ? "Bank Account \u2022\u2022\u2022\u2022 ${pm.last4}"
            : "Bank Account";
      case "sepa_debit":
        return pm.last4 != null
            ? "SEPA Debit \u2022\u2022\u2022\u2022 ${pm.last4}"
            : "SEPA Debit";
      case "apple_pay":
        return "Apple Pay";
      case "google_pay":
        return "Google Pay";
      case "card":
      default:
        final String brand = (pm.brand ?? "card").toLowerCase();
        final String brandLabel = _capitalizeBrand(brand);
        return pm.last4 != null
            ? "$brandLabel \u2022\u2022\u2022\u2022 ${pm.last4}"
            : brandLabel;
    }
  }

  /// Capitalize brand name for display.
  String _capitalizeBrand(String brand) {
    if (brand.isEmpty) {
      return "Card";
    }
    return brand[0].toUpperCase() + brand.substring(1);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            Function(
          SheetResponse<SavedPaymentMethodSheetResult> p1,
        )>.has(
          "completer",
          completer,
        ),
      )
      ..add(
        DiagnosticsProperty<SheetRequest<SavedPaymentMethodSheetRequest>>(
          "request",
          request,
        ),
      );
  }
}
