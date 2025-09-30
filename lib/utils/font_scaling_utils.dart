import "package:flutter/material.dart";

/// Utility class for managing font scaling and accessibility options
class FontScalingUtils {
  /// Prevents system font scaling to maintain consistent layouts
  static MediaQueryData disableFontScaling(BuildContext context) {
    return MediaQuery.of(context).copyWith(
      textScaler: TextScaler.noScaling,
    );
  }
  
  /// Allows system font scaling with a maximum limit to prevent extreme scaling
  static MediaQueryData limitFontScaling(BuildContext context, {double maxScale = 1.2}) {
    final MediaQueryData data = MediaQuery.of(context);
    final double currentScale = data.textScaler.scale(1.0);
    
    // Limit the scaling factor to prevent layout issues
    final double limitedScale = currentScale > maxScale ? maxScale : currentScale;
    
    return data.copyWith(
      textScaler: TextScaler.linear(limitedScale),
    );
  }
  
  /// Widget wrapper to disable font scaling for specific widgets
  static Widget noScaling({
    required BuildContext context,
    required Widget child,
  }) {
    return MediaQuery(
      data: disableFontScaling(context),
      child: child,
    );
  }
  
  /// Widget wrapper to limit font scaling for specific widgets
  static Widget limitedScaling({
    required BuildContext context,
    required Widget child,
    double maxScale = 1.2,
  }) {
    return MediaQuery(
      data: limitFontScaling(context, maxScale: maxScale),
      child: child,
    );
  }
  
  /// Check if the user has increased font size beyond normal
  static bool isLargeFontSize(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0) > 1.0;
  }
  
  /// Get the current font scale factor
  static double getFontScale(BuildContext context) {
    return MediaQuery.of(context).textScaler.scale(1.0);
  }
}