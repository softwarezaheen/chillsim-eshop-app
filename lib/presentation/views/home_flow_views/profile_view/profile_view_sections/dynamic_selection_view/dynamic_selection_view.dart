import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_selection_view/dynamic_selection_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class DynamicSelectionView extends StatelessWidget {
  const DynamicSelectionView({
    required this.dataSource,
    super.key,
  });

  static const String routeName = "DynamicSelectionView";

  final DynamicSelectionViewDataSource dataSource;
  @override
  Widget build(BuildContext context) {
    return BaseView<DynamicSelectionViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: locator<DynamicSelectionViewModel>()..dataSource = dataSource,
      builder: (
        BuildContext context,
        DynamicSelectionViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        height: double.infinity,
        child: PaddingWidget.applyPadding(
          top: 20,
          child: Column(
            children: <Widget>[
              CommonNavigationTitle(
                navigationTitle: viewModel.dataSource.viewTitle,
                textStyle: headerTwoBoldTextStyle(
                  context: context,
                  fontColor: titleTextColor(context: context),
                ),
              ),
              verticalSpaceSmall,
              Expanded(
                child: PaddingWidget.applyPadding(
                  top: 20,
                  start: 15,
                  end: 15,
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: viewModel.dataSource.data.length,
                    itemBuilder: (BuildContext context, int index) =>
                        buildChildWidget(
                      index,
                      context,
                      viewModel.dataSource.data[index],
                      viewModel,
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        verticalSpaceSmallMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChildWidget(
    int index,
    BuildContext context,
    String text,
    DynamicSelectionViewModel viewModel,
  ) =>
      GestureDetector(
        onTap: () async {
          if (viewModel.dataSource.isSelected(index)) {
            return;
          }
          viewModel.onSelectionTapped(text);
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: viewModel.dataSource.isSelected(index)
                ? greyBackGroundColor(context: context)
                : Colors.white,
            border: Border.all(
              color: mainBorderColor(context: context),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: PaddingWidget.applySymmetricPadding(
            vertical: 20,
            horizontal: 15,
            child: Text(
              text,
              style: bodyMediumTextStyle(
                context: context,
                fontColor: bubbleCountryTextColor(context: context),
              ),
            ),
          ),
        ),
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<DynamicSelectionViewDataSource>(
        "dataSource",
        dataSource,
      ),
    );
  }
}
