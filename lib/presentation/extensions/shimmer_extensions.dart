import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/material.dart";
import "package:shimmer/shimmer.dart";

/// Shimmer Extensions
extension ShimmerEffect on Widget {
  Widget applyShimmer({
    required BuildContext context,
    required bool enable,
    bool disabled = true,
    double borderRadius = 12,
    Color? baseColor,
    Color? highlightColor,
    double? height,
    double? width,
  }) {
    if (enable) {
      return Shimmer.fromColors(
        baseColor: baseColor ?? greyBackGroundColor(context: context),
        highlightColor: highlightColor ?? mainShimmerColor(context: context),
        enabled: enable,
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: this,
        ),
      ).disabled(disabled: disabled);
    } else {
      return this;
    }
  }

  Widget disabled({bool disabled = true}) {
    return IgnorePointer(ignoring: disabled, child: this);
  }
}
