import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/skeleton_view/skeleton_view_model.dart";
import "package:flutter/material.dart";

class SkeletonView extends StatelessWidget {
  const SkeletonView({super.key});
  static const String routeName = "SkeletonViewPage";

  @override
  Widget build(BuildContext context) {
    return BaseView<SkeletonViewModel>(
      viewModel: SkeletonViewModel(),
      appBarTitle: (SkeletonViewModel model) => "Skeleton Views",
      appBarBackgroundColor: Colors.blue,
      routeName: routeName,
      appBarCenterTitle: true,
      builder: (
        BuildContext context,
        SkeletonViewModel viewModel,
        Widget? child,
        double screenHeight,
      ) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  await viewModel.showLoader();
                },
                child: Text(
                  "show loader",
                  style: TextStyle(color: context.appColors.success_700),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.getFacts();
                },
                child: const Text("Get Facts"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.getCoins();
                },
                child: const Text("Get Coins"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.loginUser();
                },
                child: const Text("Login api call"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await viewModel.registerUser();
                },
                child: const Text("register api call"),
              ),
              Text(
                viewModel.projectID,
                style: TextStyle(color: context.appColors.baseWhite),
              ),
            ],
          ),
        );
      },
    );
  }
}
