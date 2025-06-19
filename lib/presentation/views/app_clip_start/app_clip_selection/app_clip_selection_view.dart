import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/views/app_clip_start/app_clip_selection/app_clip_selection_view_model.dart";
import "package:esim_open_source/presentation/views/base/base_view.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

class AppClipSelectionView extends StatelessWidget {
  const AppClipSelectionView({super.key});

  static const String routeName = "AppClipSelectionView";
  @override
  Widget build(BuildContext context) {
    return BaseView<AppClipSelectionViewModel>(
      routeName: routeName,
      hideAppBar: true,
      viewModel: AppClipSelectionViewModel(),
      builder: (
        BuildContext context,
        AppClipSelectionViewModel viewModel,
        Widget? childWidget,
        double screenHeight,
      ) =>
          SizedBox(
        height: double.infinity,
        child: PaddingWidget.applyPadding(
          top: 20,
          child: Column(
            children: <Widget>[
              PaddingWidget.applySymmetricPadding(
                horizontal: 15,
                child: Text(
                  viewModel.selectionType.title,
                  style: headerThreeBoldTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ),
                ).textSupportsRTL,
              ),
              verticalSpaceSmall,
              Expanded(
                child: PaddingWidget.applyPadding(
                  top: 20,
                  start: 15,
                  end: 15,
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemCount: viewModel.itemCount(),
                    itemBuilder: (BuildContext context, int index) =>
                        buildChildWidget(
                      index,
                      context,
                      viewModel,
                    ),
                    separatorBuilder: (BuildContext context, int index) =>
                        verticalSpaceSmallMedium,
                  ),
                ),
              ),
              PaddingWidget.applySymmetricPadding(
                vertical: 15,
                horizontal: 15,
                child: MainButton(
                  hideShadows: true,
                  height: 55,
                  title: LocaleKeys.compatibleSheet_buttonText.tr(),
                  onPressed: () => viewModel.onButtonTapped(),
                  isEnabled: viewModel.isButtonEnabled,
                  themeColor: themeColor,
                  enabledBackgroundColor:
                      enabledMainButtonColor(context: context),
                  enabledTextColor:
                      enabledMainButtonTextColor(context: context),
                  disabledTextColor:
                      disabledMainButtonTextColor(context: context),
                  disabledBackgroundColor:
                      disabledMainButtonColor(context: context),
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
    AppClipSelectionViewModel viewModel,
  ) =>
      GestureDetector(
        onTap: () async => viewModel.onSelection(context, index),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: viewModel.isSelected(index)
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
              viewModel.itemValue(index),
              style: bodyMediumTextStyle(
                context: context,
                fontColor: titleTextColor(context: context),
              ),
            ),
          ),
        ),
      );
}
