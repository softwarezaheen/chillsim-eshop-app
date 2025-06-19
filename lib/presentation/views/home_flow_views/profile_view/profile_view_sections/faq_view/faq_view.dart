import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/views/home_flow_views/profile_view/profile_view_sections/faq_view/faq_view_model.dart";
import "package:esim_open_source/presentation/widgets/common_navigation_title.dart";
import "package:esim_open_source/presentation/widgets/empty_state_list_view.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  static const String routeName = "FaqView";

  @override
  Widget build(BuildContext context) {
    return BaseView<FaqViewModel>(
      hideAppBar: true,
      routeName: routeName,
      viewModel: FaqViewModel(),
      builder: (
        BuildContext context,
        FaqViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          PaddingWidget.applyPadding(
        top: 20,
        child: Column(
          children: <Widget>[
            CommonNavigationTitle(
              navigationTitle: LocaleKeys.profile_faq.tr(),
              textStyle: headerTwoBoldTextStyle(
                context: context,
                fontColor: titleTextColor(context: context),
              ),
            ),
            verticalSpaceMedium,
            Expanded(
              child: PaddingWidget.applySymmetricPadding(
                horizontal: 15,
                child: EmptyStateListView<FaqUiModel>(
                  items: viewModel.state.faqList,
                  onRefresh: () async => viewModel.getFaqs(),
                  separatorBuilder: (BuildContext context, int index) =>
                      verticalSpaceSmallMedium,
                  emptyStateWidget: const SizedBox.shrink(),
                  itemBuilder: (BuildContext context, int index) {
                    return FaqWidget(
                      faqModel: viewModel.state.faqList[index],
                      onFaqTap: () => viewModel.faqTapped(index: index),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FaqWidget extends StatelessWidget {
  const FaqWidget({required this.faqModel, required this.onFaqTap, super.key});

  final FaqUiModel faqModel;
  final Function() onFaqTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: onFaqTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    faqModel.faqQuestion,
                    style: headerFourMediumTextStyle(
                      context: context,
                      fontColor: faqTitleTextColor(context: context),
                    ),
                  ),
                  verticalSpaceSmall,
                  faqModel.isExpanded
                      ? Text(
                          faqModel.faqAnswer,
                          style: bodyNormalTextStyle(
                            context: context,
                            fontColor: contentTextColor(context: context),
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
            Image.asset(
              faqModel.isExpanded
                  ? EnvironmentImages.collapseFaq.fullImagePath
                  : EnvironmentImages.expandFaq.fullImagePath,
              width: 25,
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<FaqUiModel>("faqModel", faqModel))
      ..add(ObjectFlagProperty<Function()>.has("onFaqTap", onFaqTap));
  }
}
