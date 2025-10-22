import "dart:io";

import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/enums/view_state.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/theme/color_templates/open_source_color_template.dart";
import "package:esim_open_source/presentation/theme/color_templates/template_app_colors.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";

Widget wrapBodyWithState({
  required BuildContext context,
  required BaseModel model,
  required Widget child,
  Widget? noDataWidget,
  VoidCallback? onBackPressed,
  Color? backgroundColor,
  Color? loaderColor,
  bool hideLoader = false,
  bool disableInteractionWhileBusy = true,
}) {
  switch (model.viewState) {
    case ViewState.busy:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          onBackPressed?.call();
        },
        child: _getLoadingUi(
          context,
          child,
          loaderColor,
          hideLoader,
          disableInteractionWhileBusy,
        ),
      );
    case ViewState.noDataAvailable:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          onBackPressed?.call();
        },
        child: noDataWidget ?? _noDataUi(context, model),
      );
    case ViewState.error:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          onBackPressed?.call();
        },
        child: _errorUi(context, model),
      );
    case ViewState.dataFetched:
    case ViewState.idle:
    default:
      return PopScope(
        // Returning true allows the pop to happen, returning false prevents it.
        onPopInvokedWithResult: (bool didPop, Object? result) async {
          onBackPressed?.call();
        },
        child: child,
      );
  }
}

Widget _getLoadingUi(
  BuildContext context,
  Widget child,
  Color? loaderColor,
  bool hideLoader,
  bool disableInteractionWhileBusy,
) {
  // https://stackoverflow.com/questions/55430842/flutter-absorbpointer-vs-ignorepointer-difference
  return Stack(
    fit: StackFit.passthrough, // Makes Stack size to the first child
    clipBehavior: Clip.none, // Allows _LoadingView to overflow if needed
    children: <Widget>[
      // The first child defines the Stack size
      disableInteractionWhileBusy ? IgnorePointer(child: child) : child,

      // The loader is positioned over the first child without affecting size
      if (!hideLoader)
        Positioned.fill(
          child: Container(
            alignment: Alignment.center,
            child: const _LoadingView(),
          ),
        ),
    ],
  );
}

Widget _noDataUi(BuildContext context, BaseModel model) {
  return _getCenteredViewMessage(
    context,
    LocaleKeys.noDataAvailableYet.tr(),
    model,
  );
}

Widget _errorUi(BuildContext context, BaseModel model) {
  return _getCenteredViewMessage(
    context,
    LocaleKeys.errorRetrievingYourData.tr(),
    model,
    error: true,
  );
}

Widget _getCenteredViewMessage(
  BuildContext context,
  String message,
  BaseModel model, {
  bool error = false,
}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            message,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          error
              ? const Icon(
                  // WWrap in gesture detector and call you refresh future here
                  Icons.refresh,
                  color: Colors.white,
                  size: 45,
                )
              : Container(),
        ],
      ),
    ),
  );
}

class _LoadingView extends HookWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    // final animationController = useAnimationController();

    return Center(
      child: SizedBox(
        width: 35,
        height: 35,
        child: getNativeIndicator(context),
      ),
    );
  }
}

Widget getNativeIndicator(BuildContext context) {
  if (Platform.isIOS) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        context.appColors.primary_900!,
        BlendMode.srcATop,
      ),
      child: const CupertinoActivityIndicator(
        radius: 15,
      ),
    );
  }
  return CircularProgressIndicator(
    strokeWidth: 3,
    color: context.appColors.primary_900,
  );
}

void setDefaultStatusBarColor() {
  TemplateAppColors templateAppColors = OpenSourceColorTemplate();

  // switch (AppEnvironment.appEnvironmentHelper.environmentTheme) {
  //   case EnvironmentTheme.openSource:
  //     templateAppColors = OpenSourceColorTemplate();
  // }
  // check in xcode info.plist (View controller-based status bar appearance) should be YES
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: templateAppColors.defPrimary_900,
      statusBarIconBrightness: Brightness.light, // for Android
      statusBarBrightness: Brightness.light, // for iOS (this is the inverse)
      // Android navigation bar configuration
      systemNavigationBarColor: Colors.white, // Match bottom nav background
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );
}
