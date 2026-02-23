import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({
    required this.backgroundColor,
    required this.icon,
    required this.text,
    super.key,
    this.imagePath,
    this.subtitle,
    this.trailingChipLabel,
    this.circleColor = Colors.white,
    this.iconColor = Colors.black,
    this.textStyle,
    this.iconSize = 24.0,
    this.circleSize = 40.0,
    this.padding = const EdgeInsets.all(16),
  });
  final Color backgroundColor;
  final Color circleColor;
  final IconData icon;
  final String? imagePath;
  final String? subtitle;
  final String? trailingChipLabel;
  final Color iconColor;
  final String text;
  final TextStyle? textStyle;
  final double iconSize;
  final double circleSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        color: backgroundColor,
        child: Padding(
          padding: padding,
          child: Row(
            children: <Widget>[
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // Circle background
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  // Icon or image
                  if (imagePath != null)
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: Image.asset(
                        imagePath!,
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    Icon(
                      icon,
                      color: iconColor,
                      size: iconSize.clamp(0.0, 26.0),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Title + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      text,
                      style: textStyle ??
                          bodyNormalTextStyle(
                            context: context,
                            fontColor: context.appColors.grey_900,
                          ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.appColors.grey_600,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Default chip
              if (trailingChipLabel != null) ...<Widget>[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: context.appColors.primary_800!),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    trailingChipLabel!,
                    style: TextStyle(
                      fontSize: 11,
                      color: context.appColors.primary_800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
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
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("circleColor", circleColor))
      ..add(DiagnosticsProperty<IconData>("icon", icon))
      ..add(StringProperty("imagePath", imagePath))
      ..add(StringProperty("subtitle", subtitle))
      ..add(StringProperty("trailingChipLabel", trailingChipLabel))
      ..add(ColorProperty("iconColor", iconColor))
      ..add(StringProperty("text", text))
      ..add(DiagnosticsProperty<TextStyle?>("textStyle", textStyle))
      ..add(DoubleProperty("iconSize", iconSize))
      ..add(DoubleProperty("circleSize", circleSize))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>("padding", padding));
  }
}
