import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/theme/my_theme_builder.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/material.dart";

Widget createTestableWidget(Widget child) {
  return EasyLocalization(
    supportedLocales: const <Locale>[Locale("en")],
    path: "assets/translations/open_source",
    fallbackLocale: const Locale("en"),
    child: MyThemeBuilder(
      // statusBarColorBuilder: (theme) => model.getColor(),
      // defaultThemeMode: ThemeMode.light,
      themes: getThemes(),
      builder: (
        BuildContext context,
        ThemeData? regularTheme,
        ThemeData? darkTheme,
        ThemeMode? themeMode,
      ) =>
          MaterialApp(
        theme: regularTheme,
        darkTheme: darkTheme,
        home: child,
      ),
    ),
  );
}
