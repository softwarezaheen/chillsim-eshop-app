// ignore_for_file: prefer_const_constructors_in_immutables

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/main_tab_page.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";

class HomePager extends StatelessWidget {
  HomePager({super.key});

  static const String routeName = "HomePager";

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePagerViewModel>.reactive(
      viewModelBuilder: () {
        HomePagerViewModel model = locator<HomePagerViewModel>()
          ..routeName = routeName;
        return model;
      },
      onViewModelReady: (HomePagerViewModel model) => model.onViewModelReady(),
      disposeViewModel: false,
      fireOnViewModelReadyOnce: true,
      builder: (BuildContext context, HomePagerViewModel model, Widget? child) {
        model.setRelatedListeners(context: context);
        return MainTabPage(
          viewModel: model,
        );
      },
    );
  }
}
