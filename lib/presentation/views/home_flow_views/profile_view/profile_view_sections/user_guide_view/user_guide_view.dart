import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/android_user_guide_view/android_user_guide_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/ios_user_guide_enum.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_detailed_view/user_guide_detailed_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_view_type.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/custom_tab_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class UserGuideView extends StatelessWidget {
  const UserGuideView({super.key});

  static const String routeName = "UserGuideView";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          child: PaddingWidget.applySymmetricPadding(
            vertical: 20,
            child: Column(
              children: <Widget>[
                CommonNavigationTitle(
                  navigationTitle: LocaleKeys.userGuideView_titleText.tr(),
                  textStyle: headerTwoBoldTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ),
                ),
                verticalSpaceSmallMedium,
                DataPlansTabView(
                  tabs: getUserGuideTabs(),
                  tabViewsChildren: getUserGuideTabsContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getUserGuideTabsContent() {
    final List<Widget> content = <Widget>[
      const UserGuideDetailedView(
        userGuideViewDataSource: IOSUserGuideEnum.step1,
      ),
      const AndroidUserGuideView(),
    ];

    return Platform.isIOS ? content : content.reversed.toList();
  }

  List<Tab> getUserGuideTabs() {
    final List<UserGuideViewType> tabOrder = Platform.isIOS
        ? UserGuideViewType.values
        : UserGuideViewType.values.reversed.toList();

    return tabOrder
        .map((UserGuideViewType type) => Tab(text: type.titleHeader))
        .toList();
  }
}
