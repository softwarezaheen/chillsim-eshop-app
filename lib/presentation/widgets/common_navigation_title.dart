import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/di/locator.dart";
import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/padding_widget.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:stacked_services/stacked_services.dart";

class CommonNavigationTitle extends StatelessWidget {
  CommonNavigationTitle({
    required this.navigationTitle,
    required this.textStyle,
    super.key,
  });

  final TextStyle textStyle;
  final String navigationTitle;

  final NavigationService navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: PaddingWidget.applySymmetricPadding(
        horizontal: 10,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: navigationService.back,
              child: Image.asset(
                EnvironmentImages.navBackIcon.fullImagePath,
                width: 25,
                height: 25,
              ).imageSupportsRTL(context),
            ),
            horizontalSpaceSmall,
            Text(
              navigationTitle,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("navigationTitle", navigationTitle))
      ..add(DiagnosticsProperty<TextStyle>("textStyle", textStyle))
      ..add(
        DiagnosticsProperty<NavigationService>(
          "navigationService",
          navigationService,
        ),
      );
  }
}
