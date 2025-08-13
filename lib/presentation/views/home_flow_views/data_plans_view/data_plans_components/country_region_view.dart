import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/core/presentation/util/flag_util.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class CountryRegionView extends StatelessWidget {
  const CountryRegionView({
    required this.title,
    required this.type,
    required this.code,
    required this.onTap,
    required this.showShimmer,
    required this.icon,
    super.key,
  });

  final String title;
  final BundleType type;
  final String code;
  final VoidCallback onTap;
  final bool showShimmer;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: whiteBackGroundColor(context: context),
          border: Border.all(
            width: 0.5,
            color: mainBorderColor(context: context),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: PaddingWidget.applySymmetricPadding(
          vertical: 15,
          horizontal: 15,
          child: Row(
            children: <Widget>[
              // Leading Icon
              CountryFlagImage(
                icon: icon,
              ).applyShimmer(
                context: context,
                enable: showShimmer,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: captionOneMediumTextStyle(
                    context: context,
                    fontColor:
                        regionCountryBundleTitleTextColor(context: context),
                  ),
                ).applyShimmer(
                  context: context,
                  enable: showShimmer,
                ),
              ),
              // Trailing arrow icon
              showShimmer
                  ? const SizedBox.shrink()
                  : Image.asset(
                      EnvironmentImages.darkArrowRight.fullImagePath,
                      height: 15,
                      fit: BoxFit.fitHeight,
                    ).imageSupportsRTL(context),
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
      ..add(StringProperty("title", title))
      ..add(EnumProperty<BundleType>("type", type))
      ..add(StringProperty("code", code))
      ..add(ObjectFlagProperty<VoidCallback>.has("onTap", onTap))
      ..add(DiagnosticsProperty<bool>("showShimmer", showShimmer))
      ..add(StringProperty("icon", icon));
  }
}
