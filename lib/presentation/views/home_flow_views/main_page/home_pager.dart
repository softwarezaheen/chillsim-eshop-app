// ignore_for_file: prefer_const_constructors_in_immutables

import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/shared/in_app_redirection_heper.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/home_pager_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/main_page/main_tab_page.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart";

class HomePager extends StatelessWidget {
  HomePager({super.key, this.redirection});

  static const String routeName = "HomePager";
  final InAppRedirection? redirection;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomePagerViewModel>.reactive(
      viewModelBuilder: () {
        HomePagerViewModel model = locator<HomePagerViewModel>()
          ..routeName = routeName
          ..redirection = redirection;
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<InAppRedirection?>("redirection", redirection),
    );
  }
}
