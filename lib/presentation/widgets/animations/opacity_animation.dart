import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";

class OpacityAnimation extends HookWidget {
  const OpacityAnimation({
    required this.child,
    required this.controller,
    super.key,
    this.delay = 200,
  });
  final Widget child;
  final int delay;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.fastEaseInToSlowEaseOut, // Use any curve you prefer here
    );
    double opacityAnimation = useAnimation(
      Tween<double>(begin: 0, end: 1).animate(curvedAnimation),
    );
    useEffect(
      () {
        Future<void>.delayed(Duration(milliseconds: delay), controller.forward);
        return controller.dispose;
      },
      <dynamic>[],
    );

    return Opacity(
      opacity: opacityAnimation,
      child: child,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty("delay", delay))
      ..add(DiagnosticsProperty<AnimationController>("controller", controller));
  }
}
