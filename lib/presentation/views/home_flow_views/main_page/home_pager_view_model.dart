import "dart:developer";

import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/base/main_base_model.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:flutter/material.dart";

class HomePagerViewModel extends MainBaseModel {
  FocusScopeNode? _currentFocus;
  LockableTabController? _tabController;
  InAppRedirection? redirection;

  @override
  void onViewModelReady() {
    super.onViewModelReady();

    if (redirection != null) {
      redirectionsHandlerService.redirectToRoute(redirection: redirection!);
    }
  }

  set tabController(LockableTabController controller) {
    _tabController = controller;
  }

  LockableTabController get tabController => _tabController!;

  set lockTabBar(bool lock) {
    _tabController?.isLocked = lock;
  }

  void changeSelectedTabIndex({required int index}) {
    playHapticFeedback(HapticFeedbackType.tabBarSelectionChange);
    _tabController?.animateTo(index);
  }

  int? getSelectedTabIndex() {
    return _tabController?.index;
  }

  void setRelatedListeners({required BuildContext context}) {
    _currentFocus = FocusScope.of(context);
    if (_currentFocus?.hasListeners ?? false) {
      _currentFocus?.removeListener(_onFocusChange);
    }
    _currentFocus?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    log("Focus: ${_currentFocus?.hasFocus}");
    if (_currentFocus != null) {
      notifyListeners();
    }
  }
}
