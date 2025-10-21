import "package:esim_open_source/data/remote/responses/promotion/reward_history_response_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/widgets/reward_history_card_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// View that displays a list of reward history items.
///
/// This is a simple wrapper around [RewardHistoryCardWidget] that maintains
/// the existing interface for backward compatibility.
class RewardHistoryView extends StatelessWidget {
  const RewardHistoryView({
    required this.rewardHistoryModel,
    super.key,
  });

  final RewardHistoryResponseModel rewardHistoryModel;

  @override
  Widget build(BuildContext context) {
    return RewardHistoryCardWidget(rewardHistoryModel: rewardHistoryModel);
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
