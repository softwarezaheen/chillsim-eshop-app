import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:stacked_themes/stacked_themes.dart";

/// A widget that rebuilds itself with a new theme
class MyThemeBuilder extends StatefulWidget {
  const MyThemeBuilder({
    required this.builder,
    super.key,
    this.themes,
    this.lightTheme,
    this.darkTheme,
    this.statusBarColorBuilder,
    this.navigationBarColorBuilder,
    this.defaultThemeMode = ThemeMode.system,
  });
  final Widget Function(BuildContext, ThemeData?, ThemeData?, ThemeMode?)
      builder;
  final List<ThemeData>? themes;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final Color? Function(ThemeData?)? statusBarColorBuilder;
  final Color? Function(ThemeData?)? navigationBarColorBuilder;
  final ThemeMode defaultThemeMode;

  @override
  State<MyThemeBuilder> createState() => _MyThemeBuilderState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        ObjectFlagProperty<
            Widget Function(
              BuildContext p1,
              ThemeData? p2,
              ThemeData? p3,
              ThemeMode? p4,
            )>.has("builder", builder),
      )
      ..add(
        IterableProperty<ThemeData>(
          "themes",
          themes,
        ),
      )
      ..add(
        DiagnosticsProperty<ThemeData?>(
          "lightTheme",
          lightTheme,
        ),
      )
      ..add(
        DiagnosticsProperty<ThemeData?>(
          "darkTheme",
          darkTheme,
        ),
      )
      ..add(
        ObjectFlagProperty<Color? Function(ThemeData? p1)?>.has(
          "statusBarColorBuilder",
          statusBarColorBuilder,
        ),
      )
      ..add(
        ObjectFlagProperty<Color? Function(ThemeData? p1)?>.has(
          "navigationBarColorBuilder",
          navigationBarColorBuilder,
        ),
      )
      ..add(
        EnumProperty<ThemeMode>(
          "defaultThemeMode",
          defaultThemeMode,
        ),
      );
  }
}

class _MyThemeBuilderState extends State<MyThemeBuilder>
    with WidgetsBindingObserver {
  late ThemeManager themeManager;

  @override
  void initState() {
    super.initState();
    themeManager = ThemeManager(
      themes: widget.themes,
      statusBarColorBuilder: widget.statusBarColorBuilder,
      navigationBarColorBuilder: widget.navigationBarColorBuilder,
      darkTheme: widget.darkTheme,
      lightTheme: widget.lightTheme,
      defaultTheme: widget.defaultThemeMode,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ThemeManager>.value(
      value: themeManager,
      builder: (BuildContext context, Widget? child) =>
          StreamProvider<ThemeModel>(
        lazy: false,
        initialData: themeManager.initialTheme,
        create: (BuildContext context) => themeManager.themesStream,
        builder: (BuildContext context, Widget? child) => Consumer<ThemeModel>(
          child: child,
          builder:
              (BuildContext context, ThemeModel themeModel, Widget? child) =>
                  widget.builder(
            context,
            themeModel.selectedTheme,
            themeModel.darkTheme,
            themeModel.themeMode,
          ),
        ),
      ),
    );
  }

  // Get all services
  // final themeService = locator<ThemeService>();
  // @override
  // Widget build(BuildContext context) {
  //   return widget.child;
  // }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        adjustSystemThemeIfNecessary();
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  // Should update theme whenever platform brightness changes.
  // This makes sure that theme changes even if the brightness changes from notification bar.
  @override
  Future<void> didChangePlatformBrightness() async {
    super.didChangePlatformBrightness();
    adjustSystemThemeIfNecessary();
  }

  //NOTE: re-apply the appropriate theme when the application gets back into the foreground
  Future<void> adjustSystemThemeIfNecessary() async {
    // switch (themeManager.selectedThemeMode) {
    //   // When app becomes inactive the overlay colors might change.
    //   // Therefore when the app is resumed we also need to update
    //   // overlay colors back to their original state. In case
    //   // selected theme mode is system the overlay colors will be
    //   // automatically updated.
    //   case ThemeMode.light:
    //   case ThemeMode.dark:
    //     final selectedTheme = themeManager.getSelectedTheme().selectedTheme;
    //     themeManager.updateOverlayColors(selectedTheme);
    //     break;
    //   //reapply theme
    //   case ThemeMode.system:
    //     themeManager.setThemeMode(ThemeMode.system);
    //     break;
    //   default:
    // }
    Brightness brightness =
        View.of(context).platformDispatcher.platformBrightness;
    switch (brightness) {
      case Brightness.dark:
        themeManager.selectThemeAtIndex(1);
        final ThemeData? selectedTheme =
            themeManager.getSelectedTheme().selectedTheme;
        themeManager.updateOverlayColors(selectedTheme);
      case Brightness.light:
        themeManager.selectThemeAtIndex(0);
        final ThemeData? selectedTheme =
            themeManager.getSelectedTheme().selectedTheme;
        themeManager.updateOverlayColors(selectedTheme);
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<ThemeManager>("themeManager", themeManager));
  }
}
