import "package:easy_localization/easy_localization.dart";
import "package:flutter/material.dart";

import "package:esim_open_source/data/remote/responses/user/wallet_transaction_response.dart";

import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/wallet_transactions_view/wallet_transactions_view_model.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";

class WalletTransactionItemView extends StatelessWidget {
  const WalletTransactionItemView({
    required this.transactionModel,
    super.key,
  });

  final WalletTransactionUiModel transactionModel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: mainBorderColor(context: context),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: PaddingWidget.applySymmetricPadding(
        horizontal: 15,
        vertical: 12,
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getTransactionColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getTransactionIcon(),
                color: _getTransactionColor(),
                size: 24,
              ),
            ),
            horizontalSpaceMedium,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getTransactionTypeTitle(),
                    style: captionOneBoldTextStyle(
                      context: context,
                      fontColor: titleTextColor(context: context),
                    ),
                  ),
                  verticalSpaceSmall,
                  if (transactionModel.description.isNotEmpty)
                    Text(
                      transactionModel.description,
                      style: captionTwoNormalTextStyle(
                        context: context,
                        fontColor: contentTextColor(context: context),
                      ),
                    ),
                  verticalSpaceSmall,
                  Text(
                    transactionModel.date,
                    style: captionThreeNormalTextStyle(
                      context: context,
                      fontColor: secondaryTextColor(context: context),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transactionModel.amount,
                  style: captionOneBoldTextStyle(
                    context: context,
                    fontColor: _getTransactionColor(),
                  ),
                ),
                verticalSpaceSmall,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    transactionModel.status,
                    style: captionThreeNormalTextStyle(
                      context: context,
                      fontColor: _getStatusColor(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getTransactionColor() {
    return transactionModel.isPositive ? Colors.green : Colors.red;
  }

  Color _getStatusColor() {
    if (transactionModel.isSuccess) return Colors.green;
    if (transactionModel.isPending) return Colors.orange;
    if (transactionModel.isFailed) return Colors.red;
    return Colors.grey;
  }

  IconData _getTransactionIcon() {
    switch (transactionModel.transactionType) {
      case WalletTransactionType.topUp:
        // For balance changes, show minus icon if amount is negative, plus if positive
        if (transactionModel.isBalanceChange) {
          return transactionModel.isNegative 
            ? Icons.remove_circle_outline 
            : Icons.add_circle_outline;
        }
        return Icons.add_circle_outline;
      case WalletTransactionType.voucherRedeem:
        return Icons.redeem;
      case WalletTransactionType.referralReward:
        return Icons.card_giftcard;
      case WalletTransactionType.cashback:
        return Icons.savings;
      case WalletTransactionType.purchase:
        return Icons.shopping_cart;
      case WalletTransactionType.refund:
        return Icons.undo;
    }
  }

  String _getTransactionTypeTitle() {
    switch (transactionModel.transactionType) {
      case WalletTransactionType.topUp:
        // If it's a balance change (top_up type), use "Balance Changed" instead
        if (transactionModel.isBalanceChange) {
          return LocaleKeys.walletTransactions_balanceChangedText.tr();
        }
        return LocaleKeys.walletTransactions_topUpText.tr();
      case WalletTransactionType.voucherRedeem:
        return LocaleKeys.walletTransactions_voucherRedeemText.tr();
      case WalletTransactionType.referralReward:
        return LocaleKeys.walletTransactions_referralRewardText.tr();
      case WalletTransactionType.cashback:
        return LocaleKeys.walletTransactions_cashbackText.tr();
      case WalletTransactionType.purchase:
        return LocaleKeys.walletTransactions_purchaseText.tr();
      case WalletTransactionType.refund:
        return LocaleKeys.walletTransactions_refundText.tr();
    }
  }
}