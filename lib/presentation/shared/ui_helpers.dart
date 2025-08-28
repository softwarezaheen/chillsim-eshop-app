import "dart:async";

import "package:esim_open_source/presentation/extensions/color_extension.dart";
import "package:esim_open_source/presentation/theme/theme_setup.dart";
import "package:flutter/material.dart";
import "package:fluttertoast/fluttertoast.dart";

const Widget horizontalSpaceTiniest = SizedBox(width: 2);
const Widget horizontalSpaceTiny = SizedBox(width: 5);
const Widget horizontalSpaceSmall = SizedBox(width: 10);
const Widget horizontalSpaceSmallMedium = SizedBox(width: 15);
const Widget horizontalSpaceMedium = SizedBox(width: 25);
const Widget horizontalSpaceMediumLarge = SizedBox(width: 30);
const Widget horizontalSpaceLarge = SizedBox(width: 50);
const Widget horizontalSpaceMassive = SizedBox(width: 120);

const Widget verticalSpaceTiniest = SizedBox(height: 2);
const Widget verticalSpaceTiny = SizedBox(height: 5);
const Widget verticalSpaceSmall = SizedBox(height: 10);
const Widget verticalSpaceSmallMedium = SizedBox(height: 15);
const Widget verticalSpaceMedium = SizedBox(height: 25);
const Widget verticalSpaceMediumLarge = SizedBox(height: 30);
const Widget verticalSpaceLarge = SizedBox(height: 50);
const Widget verticalSpaceMassive = SizedBox(height: 120);

Color deactivationButtonColor() => HexColor.fromHex("D02424");

Widget verticalSpaceSmallGrey(
  BuildContext context, {
  bool withoutSpace = false,
}) =>
    Column(
      children: <Widget>[
        withoutSpace ? Container() : verticalSpaceTiny,
        Divider(
          color:
              Theme.of(context).colorScheme.cBackground(context).withAlpha(150),
          height: 4,
        ),
        withoutSpace ? Container() : verticalSpaceTiny,
      ],
    );

Widget spacedDivider = const Column(
  children: <Widget>[
    verticalSpaceMedium,
    Divider(color: Colors.blueGrey, height: 4),
    verticalSpaceMedium,
  ],
);

Widget horizontalSpace(double width) => SizedBox(width: width);
Widget verticalSpace(double height) => SizedBox(height: height);

double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;

double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

double screenHeightFraction(
  BuildContext context, {
  double dividedBy = 1,
  double offsetBy = 0,
}) =>
    (screenHeight(context) - offsetBy) / dividedBy;

double screenWidthFraction(
  BuildContext context, {
  double dividedBy = 1,
  double offsetBy = 0,
}) =>
    (screenWidth(context) - offsetBy) / dividedBy;

double halfScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 2);

double thirdScreenWidth(BuildContext context) =>
    screenWidthFraction(context, dividedBy: 3);

double getWidthBasedOnRatio({required double height, required double ratio}) =>
    height * ratio;

double getHeightBasedOnRatio({required double width, required double ratio}) =>
    width / ratio;

const EdgeInsets charKeyboardInsets =
    EdgeInsets.symmetric(vertical: 5, horizontal: 2);

const EdgeInsets charDisplayInsets =
    EdgeInsets.symmetric(vertical: 2, horizontal: 2);

const EdgeInsets charKeyboardRowInsets =
    EdgeInsets.only(left: 4, right: 4, top: 4, bottom: 4);
const EdgeInsets charArKeyboardRowInsets =
    EdgeInsets.only(left: 4, right: 4, top: 2, bottom: 2);

const BorderRadius charKeyboardItemBorderRadius =
    BorderRadius.all(Radius.circular(6));

Future<void> showToast(
  String message, {
  Toast toastLength = Toast.LENGTH_LONG,
  int timeInSecForIosWeb = 1,
  double? fontSize = 16.0,
  ToastGravity? gravity = ToastGravity.BOTTOM,
  Color backgroundColor = Colors.grey,
  Color textColor = Colors.white,
  bool webShowClose = false,
}) async {
  unawaited(
    Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: timeInSecForIosWeb,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
      webShowClose: webShowClose,
    ),
  );
}
