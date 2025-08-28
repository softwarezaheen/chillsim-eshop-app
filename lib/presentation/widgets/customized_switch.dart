import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class MySwitch extends StatelessWidget {
  const MySwitch({
    required this.value,
    required this.onChanged,
    required this.activeColor,
    required this.trackColor,
    required this.thumbColor,
    super.key,
  });
  final bool value;
  final void Function({required bool value}) onChanged;
  final Color activeColor;
  final Color trackColor;
  final Color thumbColor;

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoSwitch(
        value: value,
        onChanged: (bool value) => onChanged(value: value),
        activeTrackColor: activeColor,
        thumbColor: thumbColor,
        inactiveTrackColor: trackColor,
      );
    } else {
      return Switch(
        value: value,
        onChanged: (bool value) => onChanged(value: value),
        activeThumbColor: activeColor,
        activeTrackColor: activeColor,
        inactiveTrackColor: trackColor,
        thumbColor: WidgetStateProperty.all(thumbColor),
      );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>("value", value))
      ..add(
        ObjectFlagProperty<void Function({required bool value})>.has(
          "onChanged",
          onChanged,
        ),
      )
      ..add(ColorProperty("activeColor", activeColor))
      ..add(ColorProperty("trackColor", trackColor))
      ..add(ColorProperty("thumbColor", thumbColor));
  }
}
