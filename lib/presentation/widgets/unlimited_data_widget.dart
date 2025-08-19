import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class UnlimitedDataWidget extends StatelessWidget {
  const UnlimitedDataWidget({
    super.key,
    this.width = 110,
    this.height = 47,
    this.padding = const EdgeInsets.all(1),
    this.borderRadius = 8.0,
    this.isLoading = false,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appColors.unlimited,
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Image.asset(
                EnvironmentImages.unlimitedDataBundle.fullImagePath,
                width: width,
                fit: BoxFit.contain,
                height: height,
              ),
            ),
          ],
        ),
      ),
    ).applyShimmer(enable: isLoading, context: context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("height", height))
      ..add(DoubleProperty("width", width))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry?>("padding", padding))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(DiagnosticsProperty<bool>("isLoading", isLoading));
  }
}
