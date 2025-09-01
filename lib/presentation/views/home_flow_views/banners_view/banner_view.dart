import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_model.dart";
import "package:esim_open_source/presentation/views/home_flow_views/banners_view/banners_view_types.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BannerView extends StatelessWidget {
  const BannerView({
    required this.bannerView,
    required this.bannersViewModel,
    super.key,
  });
  final BannersViewTypes bannerView;
  final BannersViewModel bannersViewModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bannerView.onTapGesture,
      child: PaddingWidget.applySymmetricPadding(
        horizontal: 5,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(bannerView.backGroundImage),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: PaddingWidget.applyPadding(
                  top: 10,
                  start: 20,
                  bottom: 5,
                  end: bannerView == BannersViewTypes.liveChat ? 0 : 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        bannerView.titleText,
                        style: bodyBoldTextStyle(
                          context: context,
                          fontColor: mainWhiteTextColor(context: context),
                        ),
                      ),
                      Text(
                        bannerView.contentText,
                        style: captionOneNormalTextStyle(
                          context: context,
                          fontColor: mainWhiteTextColor(context: context),
                        ),
                      ),
                      MainButton.bannerButton(
                        action: () => bannerView.onTapGesture,
                        themeColor: themeColor,
                        title: bannerView.buttonText,
                        textColor: bannerView == BannersViewTypes.liveChat
                            ? bannersViewModel.textColor ??
                                context.appColors.primary_800
                            : context.appColors.primary_800,
                        buttonColor: bannerView == BannersViewTypes.liveChat
                            ? bannersViewModel.buttonColor ??
                                context.appColors.baseWhite
                            : context.appColors.baseWhite,
                        titleTextStyle:
                            captionTwoBoldTextStyle(context: context),
                      ),
                    ],
                  ),
                ),
              ),
              bannerView == BannersViewTypes.liveChat
                  ? Align(
                      alignment: Alignment.bottomRight,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          EnvironmentImages
                              .bannersChatWithUsPerson.fullImagePath,
                          width: 160,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<BannersViewTypes>("bannerView", bannerView))
      ..add(
        DiagnosticsProperty<BannersViewModel>(
          "bannersViewModel",
          bannersViewModel,
        ),
      );
  }
}
