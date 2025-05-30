import "package:flutter/material.dart";

class LockableTabController extends TabController {
  // Lock state

  LockableTabController({
    required super.length,
    required super.vsync,
  });

  bool isLocked = false;

  @override
  void animateTo(int value, {Duration? duration, Curve curve = Curves.ease}) {
    if (!isLocked) {
      super.animateTo(value, duration: duration, curve: curve);
    }
  }
}
