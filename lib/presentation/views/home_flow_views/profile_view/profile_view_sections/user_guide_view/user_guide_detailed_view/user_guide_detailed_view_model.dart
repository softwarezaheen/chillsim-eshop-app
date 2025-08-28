import "dart:async";

import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/android_user_guide_enum.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/user_guide_view/user_guide_data_source/user_guide_view_data_source.dart";
import "package:flutter/material.dart";

class UserGuideDetailedViewModel extends BaseModel {
  late UserGuideViewDataSource userGuideViewDataSource;
  ScrollController scrollController = ScrollController();

  bool isFromAndroidScreen = false;

  @override
  void onViewModelReady() {
    super.onViewModelReady();
    isFromAndroidScreen = userGuideViewDataSource is AndroidUserGuideEnum;
  }

  Future<void> nextStepTapped() async {
    userGuideViewDataSource = userGuideViewDataSource.nextStepTapped();
    await scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );

    notifyListeners();
  }

  Future<void> previousStepTapped() async {
    userGuideViewDataSource = userGuideViewDataSource.previousStepTapped();
    await scrollController.animateTo(
      scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.ease,
    );

    notifyListeners();
  }
}
