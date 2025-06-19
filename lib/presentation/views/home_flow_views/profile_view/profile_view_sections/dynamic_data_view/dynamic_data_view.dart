import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/dynamic_data_view/dynamic_data_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_html/flutter_html.dart";

class DynamicDataView extends StatelessWidget {
  const DynamicDataView({
    required this.viewType,
    super.key,
  });
  final DynamicDataViewType viewType;
  static const String routeName = "DynamicDataView";

  @override
  Widget build(BuildContext context) {
    return BaseView<DynamicDataViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: DynamicDataViewModel(viewType: viewType),
      builder: (
        BuildContext context,
        DynamicDataViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applySymmetricPadding(
        vertical: 20,
        child: Column(
          children: <Widget>[
            CommonNavigationTitle(
              navigationTitle: viewModel.viewType.viewTitle,
              textStyle: headerTwoBoldTextStyle(
                context: context,
                fontColor: titleTextColor(context: context),
              ),
            ),
            verticalSpaceSmallMedium,
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  child: PaddingWidget.applyPadding(
                    end: 10,
                    start: 10,
                    bottom: 20,
                    child: Html(
                      data: viewModel.getHtmlContent,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<DynamicDataViewType>("viewType", viewType));
  }
}
