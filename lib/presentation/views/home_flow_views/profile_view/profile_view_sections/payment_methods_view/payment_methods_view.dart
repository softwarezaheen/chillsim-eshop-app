import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/data/remote/responses/user/saved_payment_method_response_model.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/payment_methods_view/payment_methods_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  static const String routeName = "PaymentMethodsView";

  @override
  Widget build(BuildContext context) {
    return BaseView<PaymentMethodsViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: PaymentMethodsViewModel(),
      builder: (
        BuildContext context,
        PaymentMethodsViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applyPadding(
        top: 20,
        child: Column(
          children: <Widget>[
            // Title row with sync button
            Row(
              children: <Widget>[
                Expanded(
                  child: CommonNavigationTitle(
                    navigationTitle:
                        LocaleKeys.payment_methods_title.tr(),
                    textStyle: headerTwoBoldTextStyle(
                      context: context,
                      fontColor: titleTextColor(context: context),
                    ),
                  ),
                ),
                // Sync button
                IconButton(
                  onPressed:
                      viewModel.state.isSyncing ? null : viewModel.onSync,
                  icon: viewModel.state.isSyncing
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.appColors.primary_800!,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.sync,
                          color: context.appColors.primary_800,
                        ),
                ),
              ],
            ),
            verticalSpaceSmall,
            // Subtitle
            PaddingWidget.applySymmetricPadding(
              horizontal: 15,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  LocaleKeys.payment_methods_subtitle.tr(),
                  style: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: contentTextColor(context: context),
                  ),
                ),
              ),
            ),
            verticalSpaceMedium,
            // Auto-topup warning banner
            if (viewModel.state.hasAutoTopupOnDefaultPm)
              PaddingWidget.applySymmetricPadding(
                horizontal: 15,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.appColors.warning_50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.appColors.warning_400 ?? Colors.orange,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: context.appColors.warning_700 ?? Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          LocaleKeys.payment_methods_auto_topup_warning.tr(),
                          style: captionTwoNormalTextStyle(
                            context: context,
                            fontColor: context.appColors.warning_700 ??
                                Colors.orange.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (viewModel.state.hasAutoTopupOnDefaultPm)
              verticalSpaceSmall,
            // Content (BaseView already handles loading state)
            Expanded(
              child: viewModel.state.paymentMethods.isEmpty
                  ? _buildEmptyState(context)
                  : _buildPaymentMethodsList(context, viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: PaddingWidget.applySymmetricPadding(
        horizontal: 30,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.credit_card_off,
              size: 64,
              color: contentTextColor(context: context).withOpacity(0.4),
            ),
            verticalSpaceMedium,
            Text(
              LocaleKeys.payment_methods_no_methods.tr(),
              textAlign: TextAlign.center,
              style: captionOneMediumTextStyle(
                context: context,
                fontColor: contentTextColor(context: context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsList(
    BuildContext context,
    PaymentMethodsViewModel viewModel,
  ) {
    return RefreshIndicator(
      onRefresh: viewModel.refreshPaymentMethods,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: viewModel.state.paymentMethods.length,
        separatorBuilder: (BuildContext context, int index) =>
            verticalSpaceSmall,
        itemBuilder: (BuildContext context, int index) {
          final SavedPaymentMethodResponseModel pm =
              viewModel.state.paymentMethods[index];
          final bool isUpdating =
              viewModel.state.updatingId == pm.id;

          // Prevent deletion of default PM when auto-topup is active
          final bool canDelete = !(pm.isDefault ?? false) || 
                                 !viewModel.state.hasAutoTopupOnDefaultPm;
          
          return _buildPaymentMethodCard(
            context: context,
            pm: pm,
            isUpdating: isUpdating,
            canDelete: canDelete,
            onSetDefault: () => viewModel
                .onSetDefault(pm.id ?? ""),
            onDelete: () async {
              // Show confirmation dialog
              final bool? confirmed = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: Text(LocaleKeys.payment_methods_confirm_delete.tr()),
                  content: Text(LocaleKeys.payment_methods_confirm_delete_description.tr()),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(LocaleKeys.common_cancelButtonText.tr()),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: TextButton.styleFrom(
                        foregroundColor: errorTextColor(context: context),
                      ),
                      child: Text(LocaleKeys.payment_methods_delete.tr()),
                    ),
                  ],
                ),
              );
              
              if (confirmed ?? false) {
                await viewModel.onDelete(pm.id ?? "");
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethodCard({
    required BuildContext context,
    required SavedPaymentMethodResponseModel pm,
    required bool isUpdating,
    required bool canDelete,
    required VoidCallback onSetDefault,
    required VoidCallback onDelete,
  }) {
    final bool isExpired = _isPaymentMethodExpired(pm);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: (pm.isDefault ?? false)
              ? context.appColors.primary_800!
              : mainBorderColor(context: context),
          width: (pm.isDefault ?? false) ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Card brand + last 4 + action buttons
            Row(
              children: <Widget>[
                Icon(
                  _getPaymentMethodIcon(pm.type ?? "card"),
                  size: 24,
                  color: context.appColors.primary_800,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              _getPaymentMethodDisplayName(pm),
                              style: bodyBoldTextStyle(
                                context: context,
                                fontColor: isExpired
                                    ? contentTextColor(context: context)
                                    : const Color(0xFF1F2937), // Dark grey
                              ),
                            ),
                          ),
                          if (isExpired) ...<Widget>[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: context.appColors.error_50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Expired",
                                style: captionTwoNormalTextStyle(
                                  context: context,
                                ).copyWith(
                                  color: context.appColors.error_500,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Show expiry for cards
                      if (pm.expMonth != null && pm.expYear != null)
                        Text(
                          LocaleKeys.payment_methods_expires.tr(
                            namedArgs: <String, String>{
                              "date": "${pm.expMonth}/${pm.expYear}",
                            },
                          ),
                          style: captionTwoNormalTextStyle(
                            context: context,
                            fontColor: isExpired
                                ? context.appColors.error_300
                                : contentTextColor(context: context),
                          ),
                        ),
                      // Show email for Stripe Link
                      if (pm.type == "link" && pm.email != null)
                        Text(
                          pm.email!,
                          style: captionTwoNormalTextStyle(
                            context: context,
                            fontColor: contentTextColor(context: context),
                          ),
                        ),
                    ],
                  ),
                ),
                // Default badge
                if (pm.isDefault ?? false)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: context.appColors.success_50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      LocaleKeys.payment_methods_default.tr(),
                      style: captionTwoNormalTextStyle(
                        context: context,
                      ).copyWith(
                        color: context.appColors.success_700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                // Compact action buttons (icons only)
                if (!isUpdating) ...<Widget>[
                  if (!(pm.isDefault ?? false) && !isExpired)
                    IconButton(
                      onPressed: onSetDefault,
                      icon: const Icon(Icons.star_outline, size: 20),
                      tooltip: LocaleKeys.payment_methods_set_default.tr(),
                      color: context.appColors.primary_800,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  if (canDelete)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline, size: 20),
                      tooltip: LocaleKeys.payment_methods_delete.tr(),
                      color: errorTextColor(context: context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                ],
                // Loading indicator
                if (isUpdating)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Check if a payment method is expired
  bool _isPaymentMethodExpired(SavedPaymentMethodResponseModel pm) {
    final int? expMonth = pm.expMonth;
    final int? expYear = pm.expYear;

    if (expMonth == null || expYear == null) {
      return false;
    }

    final DateTime now = DateTime.now();
    final int currentYear = now.year;
    final int currentMonth = now.month;

    // Card is expired if year is past, or same year but month is past
    return expYear < currentYear ||
        (expYear == currentYear && expMonth < currentMonth);
  }

  /// Get the appropriate icon based on payment method type
  IconData _getPaymentMethodIcon(String type) {
    switch (type.toLowerCase()) {
      case "link":
        return Icons.link; // Stripe Link
      case "us_bank_account":
      case "sepa_debit":
        return Icons.account_balance; // Bank account
      case "wallet":
      case "apple_pay":
      case "google_pay":
        return Icons.account_balance_wallet; // Wallet payments
      case "card":
      default:
        return Icons.credit_card; // Card payments (default)
    }
  }

  /// Get the display name for a payment method
  String _getPaymentMethodDisplayName(SavedPaymentMethodResponseModel pm) {
    switch (pm.type?.toLowerCase()) {
      case "link":
        return "STRIPE LINK";
      case "us_bank_account":
        return pm.last4 != null
            ? "BANK ACCOUNT •••• ${pm.last4}"
            : "BANK ACCOUNT";
      case "sepa_debit":
        return pm.last4 != null
            ? "SEPA DEBIT •••• ${pm.last4}"
            : "SEPA DEBIT";
      case "apple_pay":
        return "APPLE PAY";
      case "google_pay":
        return "GOOGLE PAY";
      case "wallet":
        return "WALLET";
      case "card":
      default:
        return "${(pm.brand ?? "Card").toUpperCase()} •••• ${pm.last4 ?? "****"}";
    }
  }
}
