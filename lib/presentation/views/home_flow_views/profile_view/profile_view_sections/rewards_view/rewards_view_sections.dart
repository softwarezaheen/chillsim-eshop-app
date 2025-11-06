import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_history_view/rewards_history_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/stories_view/referal_stories_view.dart";
import "package:esim_open_source/presentation/widgets/stories_view/story_viewer.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/widgets.dart";

enum RewardsViewSections {
  referAndEarn,
  rewardsHistory;

  bool get isSectionHidden => false;

  String get sectionTitle {
    switch (this) {
      case RewardsViewSections.referAndEarn:
        return LocaleKeys.profile_referAndEarn.tr();
      case RewardsViewSections.rewardsHistory:
        return LocaleKeys.myWallet_rewardsSectionText.tr();
    }
  }

  String get sectionImagePath => EnvironmentImages.values
      .firstWhere(
        (EnvironmentImages e) => e.name == _sectionImage,
        orElse: () => EnvironmentImages.wallet,
      )
      .fullImagePath;

  String get _sectionImage {
    switch (this) {
      case RewardsViewSections.referAndEarn:
        return "walletReferEarn";
      case RewardsViewSections.rewardsHistory:
        return "walletRewardHistory";
    }
  }

  Future<void> tapAction(
      BuildContext context, RewardsViewModel viewModel,) async {
    switch (this) {
      case RewardsViewSections.referAndEarn:
        viewModel.navigationService.navigateTo(
          StoryViewer.routeName,
          arguments: ReferalStoriesView(context).storyViewerArgs,
        );
      case RewardsViewSections.rewardsHistory:
        viewModel.navigationService.navigateTo(RewardsHistoryView.routeName);
    }
  }
}
