import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banner_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_model.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/material.dart";
import "package:stacked/stacked.dart" as stacked;

class BannersView extends StatelessWidget {
  const BannersView({super.key});

  @override
  Widget build(BuildContext context) {
    return stacked.ViewModelBuilder<BannersViewModel>.reactive(
      viewModelBuilder: BannersViewModel.new,
      onDispose: (BannersViewModel viewModel) => viewModel.onDispose(),
      onViewModelReady: (BannersViewModel viewModel) =>
          viewModel.startAnimatingView(context),
      builder: (
        BuildContext context,
        BannersViewModel viewModel,
        Widget? childWidget,
      ) =>
          PaddingWidget.applySymmetricPadding(
        vertical: 5,
        child: SizedBox(
          height: screenWidthFraction(context) * 0.43,
          child: PageView.builder(
            padEnds: false,
            controller: viewModel.bannersPageController,
            itemCount: viewModel.banners.length,
            itemBuilder: (BuildContext context, int index) =>
                PaddingWidget.applyPadding(
              start: index == 0 ? 10 : 0,
              end: index == viewModel.banners.length - 1 ? 10 : 0,
              child: SizedBox(
                width: screenWidthFraction(
                  context,
                  dividedBy:
                      1 / viewModel.bannersPageController.viewportFraction,
                ),
                height: screenWidthFraction(
                      context,
                      dividedBy:
                          1 / viewModel.bannersPageController.viewportFraction,
                    ) *
                    0.49,
                child: BannerView(
                  bannersViewModel: viewModel,
                  bannerView: viewModel.banners[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// SizedBox(
//   width: screenWidthFraction(context, dividedBy: 1.12),
//   height: screenWidthFraction(context, dividedBy: 1.12) * 0.49,
//   child: Expanded(
//     child: OverflowBox(
//       maxWidth: MediaQuery.of(context).size.width,
//       child: SizedBox(
//         width: double.infinity,
//         child: ListView.separated(
//           controller: bannersPageController,
//           scrollDirection: Axis.horizontal,
//           itemCount: BannersViewTypes.values.length,
//           separatorBuilder: (BuildContext context, int index) =>
//               horizontalSpaceSmall,
//           itemBuilder: (BuildContext context, int index) => BannerView(
//             bannerView: BannersViewTypes.values[index],
//           ),
//         ),
//       ),
//     ),
//   ),
// );
