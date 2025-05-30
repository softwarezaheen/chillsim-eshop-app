import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class DividerLine extends StatelessWidget {
  const DividerLine({
    this.dividerColor,
    this.verticalPadding = 5,
    this.horizontalPadding = 5,
    super.key,
  });

  final Color? dividerColor;
  final double verticalPadding;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return PaddingWidget.applySymmetricPadding(
      vertical: verticalPadding,
      horizontal: horizontalPadding,
      child: Divider(
        color: dividerColor ?? greyBackGroundColor(context: context),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty("verticalPadding", verticalPadding))
      ..add(ColorProperty("dividerColor", dividerColor))
      ..add(DoubleProperty("horizontalPadding", horizontalPadding));
  }
}
