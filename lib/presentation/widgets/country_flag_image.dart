import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/extensions/shimmer_extensions.dart";
import "package:esim_open_source/presentation/widgets/network_image_cached.dart";
import "package:flutter/foundation.dart";
import "package:flutter/widgets.dart";

class CountryFlagImage extends StatelessWidget {
  const CountryFlagImage({
    required this.icon,
    super.key,
    this.width,
    this.height,
  });
  final String icon;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    // Local asset path — render directly without network request
    if (icon.startsWith("assets/")) {
      return Image.asset(
        icon,
        width: width ?? 30,
        height: height ?? 30,
      );
    }

    return CachedImage.network(
      imagePath: icon,
      width: width ?? 30,
      height: height ?? 30,
      errorWidget: CachedImage.local(
        imagePath: EnvironmentImages.globalFlag.fullImagePath,
        width: width ?? 30,
        height: height ?? 30,
      ),
      placeholder: SizedBox(
        width: width ?? 30,
        height: height ?? 30,
      ).applyShimmer(
        enable: true,
        context: context,
        borderRadius: 30,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("icon", icon))
      ..add(DoubleProperty("width", width))
      ..add(DoubleProperty("height", height));
  }
}
