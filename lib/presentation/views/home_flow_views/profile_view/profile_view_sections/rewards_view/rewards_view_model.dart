import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/rewards_view/rewards_view_sections.dart";

class RewardsViewModel extends BaseModel {
  List<RewardsViewSections> rewardsSections = RewardsViewSections.values
      .where((element) {
        if (element == RewardsViewSections.referAndEarn) {
          return AppEnvironment.appEnvironmentHelper.enableReferral;
        }
        if (element == RewardsViewSections.cashbackRewards) {
          return AppEnvironment.appEnvironmentHelper.enableCashBack;
        }
        if (element == RewardsViewSections.rewardsHistory) {
          return AppEnvironment.appEnvironmentHelper.enableRewardsHistory;
        }
        return true;
      })
      .toList();
}
