import "dart:async";
import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/domain/repository/services/app_configuration_service.dart";
import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/reactive_service/bundles_data_service.dart";
import "package:esim_open_source/presentation/shared/action_helpers.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/home_flow_views/data_plans_view/data_plans_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/my_esim_view/my_esim_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view.dart";
import "package:esim_open_source/presentation/widgets/customized_bottom_navbar.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
import "package:lottie/lottie.dart";

class MainTabPage extends StatefulWidget {
  const MainTabPage({
    required this.viewModel,
    super.key,
  });

  final HomePagerViewModel viewModel;

  @override
  State<MainTabPage> createState() => _MainTabPageState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<HomePagerViewModel>("viewModel", viewModel));
  }
}

class _MainTabPageState extends State<MainTabPage>
    with TickerProviderStateMixin {
  late LockableTabController tabController;
  final MyESimView myEsimView = const MyESimView();
  final ProfileView profileView = const ProfileView();
  final DataPlansView dataPlansView = DataPlansView();

  @override
  void initState() {
    super.initState();
    tabController = LockableTabController(
      length: (widget.viewModel.isUserLoggedIn ? 3 : 2),
      vsync: this,
    );
    widget.viewModel.tabController = tabController;
    tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    // Only rebuild when the tab actually changes
    if (tabController.indexIsChanging) {
      // Safety check: only setState if widget is still mounted
      if (mounted) {
        setState(() {});
      }
      playHapticFeedback(HapticFeedbackType.tabBarSelectionChange);
    }
    
    // Trigger refresh when Data Plans tab becomes active (index 0)
    if (!tabController.indexIsChanging && tabController.index == 0) {
      unawaited(locator<BundlesDataService>().refreshData());
    }
  }

  void openDataPlansPage() {
    tabController.index = 0;
  }

  @override
  void didUpdateWidget(covariant MainTabPage oldWidget) {
    int neededLength = (widget.viewModel.isUserLoggedIn ? 3 : 2);
    int currentIndex = tabController.index;
    if (widget.viewModel.isUserLoggedIn && currentIndex == 1) {
      currentIndex++;
    }
    if (tabController.length != neededLength) {
      // Remove listener before disposing controller
      tabController.removeListener(_handleTabChange);
      tabController.dispose();
      tabController = LockableTabController(
        length: neededLength,
        vsync: this,
      );
      // Re-attach listener to new controller
      tabController.addListener(_handleTabChange);

      tabController.animateTo(
        currentIndex >= neededLength ? neededLength - 1 : currentIndex,
      );
      
      // Update view model reference
      widget.viewModel.tabController = tabController;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    tabController
      ..removeListener(_handleTabChange)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardVisible =
        KeyboardVisibilityProvider.isKeyboardVisible(context);
    return Scaffold(
      floatingActionButton: tabController.index > 1
          ? null
          : GestureDetector(
              onTap: () async {
                openWhatsApp(
                  phoneNumber: await locator<AppConfigurationService>()
                      .getWhatsAppNumber,
                  message: "",
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                  bottom: Platform.isIOS
                      ? AppEnvironment.isFromAppClip
                          ? 20
                          : 60
                      : 80,
                ),
                child: Lottie.asset(
                  "assets/lottie/whatsappLottie.json",
                  width: 90,
                  height: 90,
                ),
              ),
            ),
      backgroundColor: whiteBackGroundColor(context: context),
      body: wrapBodyWithState(
        context: context,
        model: widget.viewModel,
        child: AppEnvironment.isFromAppClip
            ? DataPlansView()
            : buildBottomNavigationBar(
                context: context,
                model: widget.viewModel,
                isKeyboardVisible: isKeyboardVisible,
                tabController: tabController,
              ),
      ),
    );
  }

  Widget buildBottomNavigationBar({
    required BuildContext context,
    required HomePagerViewModel model,
    required bool isKeyboardVisible,
    required LockableTabController tabController,
  }) {
    return SafeArea(
      child: BaseFlutterBottomNavBar(
        height: 90,
        swipeEnabled: false,
        tabController: tabController,
        isKeyboardVisible: isKeyboardVisible,
        selectedColor: bottomNavbarSelectedBackGroundColor(context: context),
        unselectedColor: bottomNavbarUnselectedBackGroundColor(context: context),
        tabsWidgets: generateTabWidgets(
          context: context,
          isLoggedIn: widget.viewModel.isUserLoggedIn,
        ),
        tabsIconData: generateTabIcons(
          context: context,
          isLoggedIn: widget.viewModel.isUserLoggedIn,
        ),
        tabsText: generateTabNames(
          context: context,
          isLoggedIn: widget.viewModel.isUserLoggedIn,
        ),
      ),
    );
  }

  List<String> generateTabIcons({
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    List<String> tabsIcons = <String>[
      EnvironmentImages.tabBarDataPlans.fullImagePath,
    ];

    if (isLoggedIn) {
      tabsIcons.add(
        EnvironmentImages.tabBarMyEsim.fullImagePath,
      );
    }

    tabsIcons.add(
      EnvironmentImages.tabBarProfile.fullImagePath,
    );

    return tabsIcons;
  }

  List<String> generateTabNames({
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    List<String> tabsNames = <String>[
      LocaleKeys.dataPlans_titleText.tr(),
    ];

    if (isLoggedIn) {
      tabsNames.add(LocaleKeys.myEsim_tabName.tr());
    }

    tabsNames.add(
      LocaleKeys.profile_tabName.tr(),
    );

    return tabsNames;
  }

  List<Widget> generateTabWidgets({
    required BuildContext context,
    required bool isLoggedIn,
  }) {
    List<Widget> tabsWidgets = <Widget>[
      dataPlansView,
    ];

    if (isLoggedIn) {
      tabsWidgets.add(myEsimView);
    }

    tabsWidgets.add(profileView);

    return tabsWidgets;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<TabController>("tabController", tabController),
    );
  }
}
