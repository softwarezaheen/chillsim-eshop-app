import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model.dart";
import "package:esim_open_source/data/remote/responses/promotion/reward_type.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// A card widget that displays a single reward history item.
///
/// This component shows:
/// - Reward type icon and title
/// - Amount and application type icon
/// - Description (if available)
/// - Promotion code or referral information
/// - Date of the reward
class RewardHistoryCardWidget extends StatelessWidget {
  const RewardHistoryCardWidget({
    required this.rewardHistoryModel,
    super.key,
  });

  final RewardHistoryResponseModel rewardHistoryModel;

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
        vertical: 15,
        horizontal: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Top row: Reward type icon + title on left, amount + application icon on right
            _buildTopRow(context),
            // Description
            if (rewardHistoryModel.displayDescription.isNotEmpty) ...<Widget>[
              verticalSpaceSmall,
              _buildDescription(context),
            ],
            // Promo code or referral info
            if (rewardHistoryModel.promotionCode != null &&
                rewardHistoryModel.promotionCode!.isNotEmpty) ...<Widget>[
              verticalSpaceSmall,
              _buildInfoChip(
                context: context,
                icon: Icons.local_offer_outlined,
                label: rewardHistoryModel.promotionCode!,
              ),
            ] else if (rewardHistoryModel.referralFrom != null &&
                rewardHistoryModel.referralFrom!.isNotEmpty) ...<Widget>[
              verticalSpaceSmall,
              _buildInfoChip(
                context: context,
                icon: Icons.person_outline,
                label: rewardHistoryModel.referralFrom!,
              ),
            ],
            verticalSpaceSmall,
            // Date at bottom
            _buildDate(context),
          ],
        ),
      ),
    );
  }

  /// Builds the top row with reward type icon, title, amount, and application type icon
  Widget _buildTopRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // Left side: reward type icon + title
        Expanded(
          child: Row(
            children: <Widget>[
              _getRewardTypeIcon(context),
              horizontalSpaceTiny,
              Expanded(
                child: Text(
                  rewardHistoryModel.displayTitle,
                  style: captionOneBoldTextStyle(
                    context: context,
                    fontColor: contentTextColor(context: context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        horizontalSpaceSmall,
        // Right side: amount + application type icon
        _buildAmountSection(context),
      ],
    );
  }

  /// Builds the amount and application type icon section
  Widget _buildAmountSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          rewardHistoryModel.amount ?? "",
          style: captionOneBoldTextStyle(
            context: context,
            fontColor: contentTextColor(context: context),
          ),
        ),
        const SizedBox(width: 4),
        _getApplicationTypeIcon(context),
      ],
    );
  }

  /// Builds the description text widget
  Widget _buildDescription(BuildContext context) {
    return Text(
      rewardHistoryModel.displayDescription,
      style: captionTwoNormalTextStyle(
        context: context,
        fontColor: secondaryTextColor(context: context),
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the date text widget
  Widget _buildDate(BuildContext context) {
    return Text(
      rewardHistoryModel.dateDisplayed,
      style: captionTwoNormalTextStyle(
        context: context,
        fontColor: secondaryTextColor(context: context),
      ),
    );
  }

  /// Get icon representing the reward type
  Widget _getRewardTypeIcon(BuildContext context) {
    final RewardType? type = rewardHistoryModel.rewardType;
    IconData iconData;
    Color iconColor = contentTextColor(context: context);

    if (type != null) {
      switch (type) {
        case RewardType.referralCredit:
          iconData = Icons.people_outline;
          iconColor = context.appColors.warning_700!;
        case RewardType.cashback:
          iconData = Icons.account_balance_wallet_outlined;
          iconColor = context.appColors.indigo_700!;
        case RewardType.promoDiscount:
          iconData = Icons.local_offer_outlined;
          iconColor = context.appColors.success_700!;
        case RewardType.discountAmount:
          iconData = Icons.attach_money;
          iconColor = context.appColors.success_700!;
        case RewardType.discountPercentage:
          iconData = Icons.percent;
          iconColor = context.appColors.success_700!;
      }
    } else {
      // Fallback based on is_referral
      iconData = (rewardHistoryModel.isReferral ?? false)
          ? Icons.people_outline
          : Icons.account_balance_wallet_outlined;
    }

    return Icon(
      iconData,
      size: 20,
      color: iconColor,
    );
  }

  /// Get icon representing the application type (wallet or order discount)
  Widget _getApplicationTypeIcon(BuildContext context) {
    final bool isWallet = rewardHistoryModel.isWalletCredit;

    return Icon(
      isWallet
          ? Icons.account_balance_wallet_outlined
          : Icons.shopping_cart_outlined,
      size: 16,
      color: secondaryTextColor(context: context),
    );
  }

  /// Builds an info chip showing promotion code or referral information
  Widget _buildInfoChip({
    required BuildContext context,
    required IconData icon,
    required String label,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.appColors.grey_50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: PaddingWidget.applySymmetricPadding(
        vertical: 4,
        horizontal: 8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 14,
              color: secondaryTextColor(context: context),
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: captionTwoNormalTextStyle(
                  context: context,
                  fontColor: secondaryTextColor(context: context),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<RewardHistoryResponseModel>(
        "rewardHistoryModel",
        rewardHistoryModel,
      ),
    );
  }
}
