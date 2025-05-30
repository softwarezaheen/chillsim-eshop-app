import "package:esim_open_source/presentation/widgets/country_flag_image.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class CircularFlagIcon extends StatelessWidget {
  const CircularFlagIcon({
    required this.icon,
    required this.size,
    this.borderWidth = 1.5,
    this.borderColor = Colors.white,
    super.key,
  });

  final String icon;
  final double size;
  final double borderWidth;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      position: DecorationPosition.foreground,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: CountryFlagImage(
          icon: icon,
          width: size,
          height: size,
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("icon", icon))
      ..add(DoubleProperty("size", size))
      ..add(DoubleProperty("borderWidth", borderWidth))
      ..add(ColorProperty("borderColor", borderColor));
  }
}
