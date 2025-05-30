// ignore_for_file: file_names

import "dart:async";

import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/helpers/view_state_utils.dart";
import "package:esim_open_source/presentation/views/base/base_model.dart";
import "package:esim_open_source/presentation/widgets/customized_app_bar.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart";
import "package:stacked/stacked.dart" as stacked;

class BaseView<T extends BaseModel> extends HookWidget {
  const BaseView({
    required this.routeName,
    required this.viewModel,
    required this.builder,
    super.key,
    this.isReactive = true,
    this.customAppBar,
    this.appBarLeading,
    this.fireOnViewModelReadyOnce = false,
    this.disposeViewModel = false,
    this.hideBackButton,
    this.floatingActionButton,
    this.animateWithOpacity = false,
    this.hideLoader = false,
    this.appBarLeadingForAndroid,
    this.backButtonIcon,
    this.hideAppBar = false,
    this.updateStatusBarColor = false,
    this.appBarTitle,
    this.noDataWidget,
    this.appBarActionList,
    this.statusBarColor,
    this.staticChild,
    this.appBarBackgroundColor,
    this.appBarCenterTitle = false,
    this.backgroundColor,
    this.disableInteractionWhileBusy = true,
    this.backGroundImage,
    this.onViewModelReady,
    this.enableBottomSafeArea = true,
    this.isBottomSheetView = false,
  });
  //done

  static BaseView<T> bottomSheetBuilder<T extends BaseModel>({
    required T viewModel,
    required Widget Function(
      BuildContext context,
      T viewModel,
      Widget? staticChild,
      double screenHeight,
    ) builder,
    bool hideLoader = false,
  }) {
    return BaseView<T>(
      routeName: "",
      hideLoader: hideLoader,
      hideAppBar: true,
      disableInteractionWhileBusy: false,
      builder: builder,
      viewModel: viewModel,
      isBottomSheetView: true,
    );
  }

  final T viewModel; //done
  final Widget Function(
    BuildContext context,
    T viewModel,
    Widget? staticChild,
    double screenHeight,
  ) builder; //done
  final bool isReactive; //done
  final PreferredSizeWidget? customAppBar; //done
  final Widget? staticChild; //done
  final Icon? backButtonIcon; //done
  final bool fireOnViewModelReadyOnce; //done
  final bool disposeViewModel; //done
  final bool hideLoader;
  final String routeName;
  final bool updateStatusBarColor;
  final Color? backgroundColor; //done
  final Color? statusBarColor; //done
  final Widget? Function(T)? appBarLeading; //done
  final Widget? Function(T)? noDataWidget; //done
  final double? appBarLeadingForAndroid;
  final bool hideAppBar; //done
  final bool disableInteractionWhileBusy;
  final bool Function(T)? hideBackButton; //done
  final String? Function(T)? appBarTitle; //done
  final FloatingActionButton? Function(T)? floatingActionButton;
  final bool animateWithOpacity;
  final List<Widget> Function(T)? appBarActionList; //done
  final Color? appBarBackgroundColor; //done
  final bool appBarCenterTitle;
  final String? backGroundImage;
  final Function(T)? onViewModelReady;
  final bool enableBottomSafeArea;
  final bool isBottomSheetView;

  double safeAreaHeight(BuildContext context) {
    return MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            kToolbarHeight +
            MediaQuery.of(context).padding.bottom);
  }

  @override
  Widget build(BuildContext context) {
    viewModel.routeName = routeName;
    if (isReactive) {
      return stacked.ViewModelBuilder<T>.reactive(
        viewModelBuilder: () => viewModel,
        onDispose: (T viewModel) => viewModel.onDispose(),
        fireOnViewModelReadyOnce: fireOnViewModelReadyOnce,
        disposeViewModel: disposeViewModel,
        onViewModelReady: (T viewModel) {
          if (onViewModelReady != null) {
            onViewModelReady?.call(viewModel);
          } else {
            viewModel.onViewModelReady();
          }
        },
        builder: (BuildContext context, T viewModel, Widget? child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: _getChild(context, viewModel, child),
              ),
              viewModel.isBusy && !hideLoader
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withValues(alpha: 0.3),
                    )
                  : Container(),
            ],
          );
        },
      );
    } else {
      return stacked.ViewModelBuilder<T>.nonReactive(
        viewModelBuilder: () => viewModel,
        fireOnViewModelReadyOnce: fireOnViewModelReadyOnce,
        disposeViewModel: disposeViewModel,
        onDispose: (T viewModel) => viewModel.onDispose(),
        onViewModelReady: (T viewModel) {
          if (onViewModelReady != null) {
            onViewModelReady?.call(viewModel);
          } else {
            viewModel.onViewModelReady();
          }
        },
        builder: (BuildContext context, T viewModel, Widget? child) {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: _getChild(context, viewModel, child),
              ),
              viewModel.isBusy && !hideLoader
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withValues(alpha: 0.3),
                    )
                  : Container(),
            ],
          );
        },
      );
    }
  }

  Widget _getChild(BuildContext context, T viewModel, Widget? child) {
    if (isBottomSheetView) {
      return SafeArea(
        bottom: false,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: appBarBackgroundColor ?? context.appColors.baseWhite!,
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                width: 0,
                color: Colors.transparent,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          child: SafeArea(
            child: wrapBodyWithState(
              context: context,
              hideLoader: hideLoader,
              noDataWidget: noDataWidget?.call(viewModel),
              model: viewModel,
              disableInteractionWhileBusy: disableInteractionWhileBusy,
              child: builder(
                context,
                viewModel,
                staticChild,
                _getScreenHeight(context),
              ),
            ),
          ),
        ),
      );
    }
    _initViews(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: floatingActionButton?.call(viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: backgroundColor ?? context.appColors.baseWhite,
      appBar: hideAppBar
          ? null
          : customAppBar ??
              myAppBar(
                context,
                removeBackButton: hideBackButton?.call(viewModel) ?? false,
                backgroundColor: appBarBackgroundColor,
                leadingWidthAndroid: appBarLeadingForAndroid,
                backButtonIcon: backButtonIcon,
                leading: appBarLeading?.call(viewModel),
                title: appBarTitle?.call(viewModel),
                centerTitle: appBarCenterTitle,
                actionList: appBarActionList?.call(viewModel),
              ),
      body: Stack(
        children: <Widget>[
          backGroundImage == null
              ? const SizedBox.shrink()
              : Image.asset(
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  backGroundImage ?? "",
                ),
          SafeArea(
            top: false,
            bottom: enableBottomSafeArea,
            child: ColoredBox(
              color: backGroundImage != null
                  ? Colors.transparent
                  : statusBarColor ??
                      appBarBackgroundColor ??
                      context.appColors.baseWhite!,
              child: SafeArea(
                bottom: enableBottomSafeArea,
                child: ColoredBox(
                  color: backGroundImage != null
                      ? Colors.transparent
                      : backgroundColor ?? context.appColors.baseWhite!,
                  child: wrapBodyWithState(
                    context: context,
                    hideLoader: hideLoader,
                    noDataWidget: noDataWidget?.call(viewModel),
                    model: viewModel,
                    disableInteractionWhileBusy: disableInteractionWhileBusy,
                    child: builder(
                      context,
                      viewModel,
                      staticChild,
                      _getScreenHeight(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _initViews(BuildContext context) {
    if (updateStatusBarColor) {
      unawaited(
        FlutterStatusbarcolor.setStatusBarColor(
          statusBarColor ??
              appBarBackgroundColor ??
              context.appColors.baseWhite!,
        ),
      );
    }
  }

  double _getScreenHeight(BuildContext context) {
    return safeAreaHeight(context) - (hideAppBar ? kToolbarHeight : 0);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<T>("viewModel", viewModel))
      ..add(
        ObjectFlagProperty<
            Widget Function(
              BuildContext context,
              T viewModel,
              Widget? staticChild,
              double screenHeight,
            )>.has("builder", builder),
      )
      ..add(DiagnosticsProperty<bool>("isReactive", isReactive))
      ..add(
        DiagnosticsProperty<bool>(
          "fireOnViewModelReadyOnce",
          fireOnViewModelReadyOnce,
        ),
      )
      ..add(DiagnosticsProperty<bool>("disposeViewModel", disposeViewModel))
      ..add(DiagnosticsProperty<bool>("hideLoader", hideLoader))
      ..add(
        DiagnosticsProperty<bool>(
          "updateStatusBarColor",
          updateStatusBarColor,
        ),
      )
      ..add(ColorProperty("backgroundColor", backgroundColor))
      ..add(ColorProperty("statusBarColor", statusBarColor))
      ..add(
        ObjectFlagProperty<Widget? Function(T p1)?>.has(
          "appBarLeading",
          appBarLeading,
        ),
      )
      ..add(
        ObjectFlagProperty<Widget? Function(T p1)?>.has(
          "noDataWidget",
          noDataWidget,
        ),
      )
      ..add(
        DoubleProperty("appBarLeadingForAndroid", appBarLeadingForAndroid),
      )
      ..add(DiagnosticsProperty<bool>("hideAppBar", hideAppBar))
      ..add(
        ObjectFlagProperty<bool Function(T p1)?>.has(
          "hideBackButton",
          hideBackButton,
        ),
      )
      ..add(
        ObjectFlagProperty<String? Function(T p1)?>.has(
          "appBarTitle",
          appBarTitle,
        ),
      )
      ..add(
        ObjectFlagProperty<FloatingActionButton? Function(T p1)?>.has(
          "floatingActionButton",
          floatingActionButton,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>("animateWithOpacity", animateWithOpacity),
      )
      ..add(
        ObjectFlagProperty<List<Widget> Function(T p1)?>.has(
          "appBarActionList",
          appBarActionList,
        ),
      )
      ..add(ColorProperty("appBarBackgroundColor", appBarBackgroundColor))
      ..add(DiagnosticsProperty<bool>("appBarCenterTitle", appBarCenterTitle))
      ..add(
        DiagnosticsProperty<bool>(
          "disableInteractionWhileBusy",
          disableInteractionWhileBusy,
        ),
      )
      ..add(StringProperty("routeName", routeName))
      ..add(StringProperty("backGroundImage", backGroundImage))
      ..add(
        ObjectFlagProperty<Function(T p1)?>.has(
          "onViewModelReady",
          onViewModelReady,
        ),
      )
      ..add(
        DiagnosticsProperty<bool>(
          "disableBottomSafeArea",
          enableBottomSafeArea,
        ),
      )
      ..add(DiagnosticsProperty<bool>("isBottomSheetView", isBottomSheetView));
  }
}
