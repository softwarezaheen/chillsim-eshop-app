import "package:esim_open_source/app/environment/environment_images.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BottomSheetCloseButton extends StatelessWidget {
  const BottomSheetCloseButton({
    required this.onTap,
    super.key,
    this.closeIcon,
  });

  final Widget? closeIcon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return closeIcon ??
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: Image.asset(
                EnvironmentImages.sheetCloseIcon.fullImagePath,
                width: 32,
                height: 32,
              ),
            ),
          ),
        );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<VoidCallback>.has("onTap", onTap));
  }
}
