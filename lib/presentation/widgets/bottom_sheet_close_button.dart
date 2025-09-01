import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/widgets/my_card_wrap.dart";
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
    return Align(
      alignment: Alignment.centerRight,
      child: closeIcon ??
          MyCardWrap(
            color: Colors.transparent,
            withDelay: true,
            margin: const EdgeInsets.only(top: 10),
            borderRadius: 30,
            enableRipple: true,
            enableBorder: false,
            onTap: onTap,
            child: Image.asset(
              EnvironmentImages.sheetCloseIcon.fullImagePath,
              width: 32,
              height: 32,
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
