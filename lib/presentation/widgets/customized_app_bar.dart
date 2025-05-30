import "dart:io";

import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

PreferredSizeWidget myAppBar(
  BuildContext context, {
  List<Widget>? actionList,
  Widget? leading,
  Icon? backButtonIcon,
  Color? backButtonColor,
  Color? statusBarColor,
  Color? backgroundColor,
  String? title,
  double? leadingWidthAndroid,
  TextStyle? customTitleStyle,
  bool centerTitle = false,
  bool closeFlutterOnBack = false,
  bool removeBackButton = false,
  bool primaryStatusBarColor = false,
  bool isPageVisible = false,
  bool showBorder = false,
  final VoidCallback? onBackPress,
}) {
  if (Platform.isIOS) {
    return CupertinoNavigationBar(
      border: Border(
        bottom: BorderSide(
          color: showBorder
              ? Theme.of(context)
                  .colorScheme
                  .cHintTextColor(context)
                  .withAlpha(50)
              : Colors.transparent,
        ),
      ),
      backgroundColor: backgroundColor ?? context.appColors.baseBlack!,
      middle: centerTitle && title != null
          ? Text(
              title,
              style: customTitleStyle ??
                  headerFourMediumTextStyle(context: context),
            )
          : Container(),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          removeBackButton
              ? Container()
              : Material(
                  color: Colors.transparent,
                  child: IconButton(
                    icon: backButtonIcon ?? const Icon(Icons.arrow_back_ios),
                    color: backButtonColor ?? context.appColors.baseWhite,
                    iconSize: 17,
                    onPressed: () async {
                      if (onBackPress != null) {
                        onBackPress.call();
                        return;
                      }
                      if (closeFlutterOnBack) {
                        SystemNavigator.pop();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
          leading != null
              ? Material(
                  color: Colors.transparent,
                  child: leading,
                )
              : !centerTitle && title != null
                  ? Material(
                      color: Colors.transparent,
                      child: Text(
                        title,
                        style: customTitleStyle ??
                            headerFourMediumTextStyle(context: context),
                      ),
                    )
                  : Container(),
        ],
      ),
      trailing: actionList != null
          ? Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: actionList,
              ),
            )
          : null,
    );
  } else {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: backgroundColor ??
          Theme.of(context).colorScheme.cPrimaryColor(context),
      title: Text(
        title ?? "",
        style: customTitleStyle ?? headerFourMediumTextStyle(context: context),
      ),
      elevation: showBorder ? 1 : 0,
      shadowColor:
          Theme.of(context).colorScheme.cHintTextColor(context).withAlpha(50),
      leadingWidth:
          removeBackButton && leading == null ? 0 : leadingWidthAndroid,
      actions: actionList,
      centerTitle: centerTitle,
      leading: leading ??
          (removeBackButton
              ? Container()
              : IconButton(
                  icon: backButtonIcon ?? const Icon(Icons.arrow_back_ios),
                  color: backButtonColor ??
                      Theme.of(context)
                          .colorScheme
                          .cNavigationActionsColor(context),
                  iconSize: 20,
                  onPressed: () async {
                    if (onBackPress != null) {
                      onBackPress.call();
                      return;
                    }
                    if (closeFlutterOnBack) {
                      SystemNavigator.pop();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                )),
    );
  }
}
