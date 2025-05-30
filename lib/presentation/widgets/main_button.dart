import "package:esim_open_source/app/environment/app_environment.dart";
import "package:esim_open_source/presentation/shared/haptic_feedback.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MainButton extends StatelessWidget {
  const MainButton({
    required this.title,
    required this.onPressed,
    required this.themeColor,
    super.key,
    this.isEnabled = true,
    this.width,
    this.height = 50,
    this.enabledBackgroundColor,
    this.disabledBackgroundColor,
    this.enabledTextColor,
    this.disabledTextColor,
    this.titleTextStyle,
    this.borderRadius,
    this.borderColor,
    this.leadingWidget,
    this.containerPadding = EdgeInsets.zero,
    this.hideShadows,
    this.textAlignment,
    this.trailingWidget,
    this.verticalPadding = 0,
    this.horizontalPadding = 0,
    this.rowMainAxisSize,
    this.titleHorizontalPadding = 0,
  });
  final String title;
  final bool isEnabled;
  final VoidCallback onPressed;
  final double? width;
  final double height;
  final Color? enabledBackgroundColor;
  final Color? disabledBackgroundColor;
  final Color? enabledTextColor;
  final Color? disabledTextColor;
  final TextStyle? titleTextStyle;
  final double? borderRadius;
  final Color themeColor;
  final Color? borderColor;
  final Widget? leadingWidget;
  final EdgeInsets containerPadding;
  final bool? hideShadows;
  final MainAxisAlignment? textAlignment;
  final Widget? trailingWidget;
  final double verticalPadding;
  final double horizontalPadding;
  final MainAxisSize? rowMainAxisSize;
  final double titleHorizontalPadding;

  static MainButton onlyText({
    required String title,
    required VoidCallback onPressed,
    required Color themeColor,
    Key? key,
    bool isEnabled = true,
    Color? enabledBackgroundColor = Colors.white,
    Color? disabledBackgroundColor = Colors.transparent,
    Color? enabledTextColor,
    Color? disabledTextColor,
    Color? borderColor,
    double? width,
    bool? hideShadows,
    EdgeInsets? containerPadding,
    TextStyle? titleTextStyle,
  }) {
    return MainButton(
      title: title,
      onPressed: onPressed,
      themeColor: themeColor,
      isEnabled: isEnabled,
      titleTextStyle: titleTextStyle,
      enabledBackgroundColor: enabledBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      enabledTextColor: enabledTextColor ?? themeColor,
      disabledTextColor: disabledTextColor ?? themeColor,
      borderColor: borderColor ?? Colors.transparent,
      containerPadding: containerPadding ?? EdgeInsets.zero,
      width: width ?? double.infinity,
      hideShadows: hideShadows ?? true,
    );
  }

  static MainButton emptyBackground({
    required String title,
    required VoidCallback onPressed,
    required Color themeColor,
    Key? key,
    bool isEnabled = true,
    Color? enabledBackgroundColor = Colors.white,
    Color? disabledBackgroundColor = Colors.transparent,
    Color? enabledTextColor,
    Color? disabledTextColor,
    Color? borderColor,
    double? width,
    double? height,
    bool? hideShadows,
    EdgeInsets? containerPadding,
    TextStyle? titleTextStyle,
  }) {
    return MainButton(
      title: title,
      onPressed: onPressed,
      themeColor: themeColor,
      isEnabled: isEnabled,
      enabledBackgroundColor: enabledBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      enabledTextColor: enabledTextColor ?? themeColor,
      disabledTextColor: disabledTextColor ?? themeColor,
      borderColor: borderColor ?? themeColor,
      containerPadding: containerPadding ?? EdgeInsets.zero,
      width: width ?? double.infinity,
      hideShadows: hideShadows,
      height: height ?? 50,
      titleTextStyle: titleTextStyle,
    );
  }

  static MainButton continueWith({
    required String image,
    required String title,
    required Color themeColor,
    required Color textColor,
    required Color buttonColor,
    required VoidCallback action,
    EdgeInsets containerPadding = EdgeInsets.zero,
    TextStyle? titleTextStyle,
    double leadingImageWidth = 25,
    double leadingImageHeight = 25,
  }) {
    return MainButton(
      title: title,
      borderRadius: 25,
      hideShadows: true,
      onPressed: action,
      themeColor: themeColor,
      enabledBackgroundColor: buttonColor,
      enabledTextColor: textColor,
      height: 53,
      leadingWidget: Image.asset(
        image,
        width: leadingImageWidth,
        height: leadingImageHeight,
      ),
      horizontalPadding: 20,
      textAlignment: MainAxisAlignment.spaceBetween,
      titleTextStyle: titleTextStyle,
      containerPadding: containerPadding,
    );
  }

  static MainButton bannerButton({
    required String title,
    required VoidCallback action,
    required Color themeColor,
    required Color? textColor,
    required Color? buttonColor,
    required TextStyle titleTextStyle,
    double height = 38,
    double titleHorizontalPadding = 20,
    bool hideShadows = true,
  }) {
    return MainButton(
      height: height,
      title: title,
      onPressed: action,
      themeColor: themeColor,
      hideShadows: hideShadows,
      enabledTextColor: textColor,
      enabledBackgroundColor: buttonColor,
      titleTextStyle: titleTextStyle,
      rowMainAxisSize: MainAxisSize.min,
      titleHorizontalPadding: titleHorizontalPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: containerPadding,
      child: GestureDetector(
        onTap: isEnabled
            ? () {
                playHapticFeedback(HapticFeedbackType.mainButtonTapped);
                onPressed();
              }
            : null,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              borderRadius ??
                  AppEnvironment.appEnvironmentHelper.environmentCornerRadius,
            ),
            border:
                borderColor != null ? Border.all(color: borderColor!) : null,
            color: isEnabled
                ? (enabledBackgroundColor ??
                    enabledMainButtonColor(context: context))
                : (disabledBackgroundColor ??
                    disabledMainButtonColor(context: context)),
            boxShadow: (hideShadows ?? false)
                ? null
                : <BoxShadow>[
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .cHintTextColor(context)
                          .withAlpha(20),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .cHintTextColor(context)
                          .withAlpha(20),
                      spreadRadius: 2,
                      blurRadius: 1,
                      offset: const Offset(0, -1),
                    ),
                  ],
          ),
          height: height,
          width: width,
          child: PaddingWidget.applySymmetricPadding(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
            child: Row(
              mainAxisAlignment: textAlignment ?? MainAxisAlignment.center,
              mainAxisSize: rowMainAxisSize ?? MainAxisSize.max,
              children: <Widget>[
                leadingWidget ?? Container(),
                PaddingWidget.applySymmetricPadding(
                  horizontal: titleHorizontalPadding,
                  child: Text(
                    title,
                    textAlign: TextAlign.left,
                    style: titleTextStyle?.copyWith(
                          color: isEnabled
                              ? (enabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context))
                              : (disabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context)),
                        ) ??
                        TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isEnabled
                              ? (enabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context))
                              : (disabledTextColor ??
                                  Theme.of(context)
                                      .colorScheme
                                      .cBackground(context)),
                        ),
                  ),
                ),
                trailingWidget ?? Container(),
              ],
            ),
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
      ..add(DiagnosticsProperty<bool>("isEnabled", isEnabled))
      ..add(ObjectFlagProperty<VoidCallback>.has("onPressed", onPressed))
      ..add(DoubleProperty("width", width))
      ..add(DoubleProperty("height", height))
      ..add(ColorProperty("enabledBackgroundColor", enabledBackgroundColor))
      ..add(ColorProperty("disabledBackgroundColor", disabledBackgroundColor))
      ..add(ColorProperty("enabledTextColor", enabledTextColor))
      ..add(ColorProperty("disabledTextColor", disabledTextColor))
      ..add(DiagnosticsProperty<TextStyle?>("titleTextStyle", titleTextStyle))
      ..add(DoubleProperty("borderRadius", borderRadius))
      ..add(ColorProperty("themeColor", themeColor))
      ..add(ColorProperty("borderColor", borderColor))
      ..add(
        DiagnosticsProperty<EdgeInsets>("containerPadding", containerPadding),
      )
      ..add(DiagnosticsProperty<bool?>("hideShadows", hideShadows))
      ..add(EnumProperty<MainAxisAlignment?>("textAlignment", textAlignment))
      ..add(DoubleProperty("verticalPadding", verticalPadding))
      ..add(DoubleProperty("horizontalPadding", horizontalPadding))
      ..add(EnumProperty<MainAxisSize?>("rowMainAxisSize", rowMainAxisSize))
      ..add(DoubleProperty("titleHorizontalPadding", titleHorizontalPadding));
  }
}
