// import "package:esim_open_source/presentation/shared/shared_styles.dart";
// import "package:esim_open_source/presentation/shared/ui_helpers.dart";
// import "package:esim_open_source/presentation/theme/theme_setup.dart";
// import "package:esim_open_source/presentation/widgets/main_button.dart";
// import "package:esim_open_source/presentation/widgets/otp_text_field.dart";
// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
// import "package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart";
// import "package:timer_count_down/timer_controller.dart";
// import "package:timer_count_down/timer_count_down.dart";
//
// class OTPMainPage extends StatelessWidget {
//   const OTPMainPage({
//     required this.height,
//     required this.isArabic,
//     required this.numberOfSeconds,
//     required this.countdownController,
//     required this.counterFinished,
//     required this.enableResend,
//     required this.resendPressed,
//     required this.themeColor,
//     required this.otpController,
//     required this.enableSendButton,
//     required this.validateCodeOTP,
//     required this.mobileNumber,
//     required this.isKeyboardVisible,
//     super.key,
//     this.buttonTitle,
//     this.leadingWidget,
//     this.termsPressed,
//     this.privacyPressed,
//     this.child,
//   });
//
//   final double height;
//   final bool isArabic;
//   final int numberOfSeconds;
//   final CountdownController? countdownController;
//   final Function? counterFinished;
//   final bool enableResend;
//   final bool enableSendButton;
//   final void Function()? resendPressed;
//   final void Function()? termsPressed;
//   final void Function()? privacyPressed;
//   final void Function()? validateCodeOTP;
//   final bool Function(BuildContext) isKeyboardVisible;
//   final Color themeColor;
//   final TextEditingController otpController;
//   final String mobileNumber;
//   final String? buttonTitle;
//   final Widget? leadingWidget;
//   final Widget? child;
//
//   @override
//   Widget build(BuildContext context) {
//     return KeyboardDismissOnTap(
//       dismissOnCapturedTaps: true,
//       child: SingleChildScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         reverse: true,
//         child: SizedBox(
//           height: height,
//           //onlyPositive(height - MediaQuery.of(context).viewInsets.bottom + (model.isKeyboardVisible(context) ? 30.0 : 0)),
//           child: Column(
//             children: <Widget>[
//               verticalSpaceSmall,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: isArabic
//                           ? const BorderRadius.only(
//                               topLeft: Radius.circular(20),
//                               bottomLeft: Radius.circular(20),
//                             )
//                           : const BorderRadius.only(
//                               topRight: Radius.circular(20),
//                               bottomRight: Radius.circular(20),
//                             ),
//                       color: themeColor,
//                       boxShadow: <BoxShadow>[
//                         BoxShadow(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .cPrimaryColor(context)
//                               .withAlpha(20),
//                           spreadRadius: 2,
//                           blurRadius: 1,
//                           offset: const Offset(0, 2),
//                         ),
//                         BoxShadow(
//                           color: Theme.of(context)
//                               .colorScheme
//                               .cPrimaryColor(context)
//                               .withAlpha(20),
//                           spreadRadius: 2,
//                           blurRadius: 1,
//                           offset: const Offset(0, -1),
//                         ),
//                       ],
//                     ),
//                     height: 60,
//                     width: 250,
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: <Widget>[
//                             const Text(
//                               "Resend otp in",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w300,
//                                 color: Colors.white,
//                               ),
//                             ),
//                             Row(
//                               children: <Widget>[
//                                 Countdown(
//                                   seconds: numberOfSeconds,
//                                   build: (BuildContext context, double time) =>
//                                       Text(
//                                     time.toInt().toString(),
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   onFinished: counterFinished,
//                                   controller: countdownController,
//                                 ),
//                                 horizontalSpaceTiny,
//                                 const Text(
//                                   /*model.numberOfSeconds.toString() + " " +*/
//                                   "seconds",
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Center(
//                       child: GestureDetector(
//                         onTap: enableResend ? resendPressed : null,
//                         child: Text(
//                           "Resend",
//                           style: TextStyle(
//                             fontSize: 21,
//                             fontWeight: FontWeight.w600,
//                             color: enableResend
//                                 ? themeColor
//                                 : Theme.of(context)
//                                     .colorScheme
//                                     .cHintTextColor(context),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               verticalSpaceMedium,
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
//                 child: Column(
//                   children: <Widget>[
//                     verticalSpaceSmall,
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "OTP :",
//                           style: normalText(context: context),
//                         ),
//                         verticalSpaceSmall,
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: OtpTextField(
//                             numberOfFields: 6,
//                             autoFocus: true,
//                             // enabledBorderColor: Colors.red,
//                             focusedBorderColor: Colors.black,
//                             cursorColor: Colors.transparent,
//                             // exposes the list of textEditingControllers to control the textFields. This can be set to a local variable for manipulation
//                             // handleControllers: ,
//                             borderColor: Colors.black,
//                             //set to true to show as box or false to show as dash
//                             showFieldAsBox: true,
//                             //runs when a code is typed in
//                             onCodeChanged: (String code) {
//                               //handle validation or checks here
//                             },
//                             //runs when every textField is filled
//                             onSubmit: (String verificationCode) {
//                               otpController.text = verificationCode;
//                               // if (enableSendButton) {
//                               //   validateCodeOTP?.call();
//                               // }
//                               FocusManager.instance.primaryFocus?.unfocus();
//                             }, // end onSubmit
//                           ),
//                         ),
//                         verticalSpaceSmallMedium,
//                       ],
//                     ),
//                     verticalSpaceSmall,
//                     child ?? Container(),
//                   ],
//                 ),
//               ),
//               !isKeyboardVisible(context) ? const Spacer() : Container(),
//               !isKeyboardVisible(context)
//                   ? Column(
//                       children: <Widget>[
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
//                           child: Column(
//                             children: <Widget>[
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   GestureDetector(
//                                     onTap: () => termsPressed?.call(),
//                                     child: Text(
//                                       "Terms & Conditions",
//                                       style: smallTextLight(context: context)
//                                           .copyWith(
//                                         fontSize: 12,
//                                         decoration: TextDecoration.underline,
//                                         decorationColor: cHintTextColor,
//                                       ),
//                                     ),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () => privacyPressed?.call(),
//                                     child: Text(
//                                       "Privacy Policy",
//                                       style: smallTextLight(context: context)
//                                           .copyWith(
//                                         fontSize: 12,
//                                         decoration: TextDecoration.underline,
//                                         decorationColor: cHintTextColor,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               verticalSpaceMedium,
//                               MainButton(
//                                 isEnabled: enableSendButton,
//                                 title: buttonTitle ?? "Confirm",
//                                 onPressed: () => validateCodeOTP?.call(),
//                                 themeColor: themeColor,
//                                 leadingWidget: leadingWidget,
//                               ),
//                             ],
//                           ),
//                         ),
//                         verticalSpaceSmallMedium,
//                         Text(
//                           "© 2023 Monty Mobile Ltd",
//                           style: smallTextLight(context: context),
//                         ),
//                         verticalSpaceSmall,
//                       ],
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(DoubleProperty("height", height))
//       ..add(DiagnosticsProperty<bool>("isArabic", isArabic))
//       ..add(IntProperty("numberOfSeconds", numberOfSeconds))
//       ..add(
//         DiagnosticsProperty<CountdownController?>(
//           "countdownController",
//           countdownController,
//         ),
//       )
//       ..add(DiagnosticsProperty<Function?>("counterFinished", counterFinished))
//       ..add(DiagnosticsProperty<bool>("enableResend", enableResend))
//       ..add(DiagnosticsProperty<bool>("enableSendButton", enableSendButton))
//       ..add(
//         ObjectFlagProperty<void Function()?>.has(
//           "resendPressed",
//           resendPressed,
//         ),
//       )
//       ..add(
//         ObjectFlagProperty<void Function()?>.has(
//           "termsPressed",
//           termsPressed,
//         ),
//       )
//       ..add(
//         ObjectFlagProperty<void Function()?>.has(
//           "privacyPressed",
//           privacyPressed,
//         ),
//       )
//       ..add(
//         ObjectFlagProperty<void Function()?>.has(
//           "validateCodeOTP",
//           validateCodeOTP,
//         ),
//       )
//       ..add(
//         ObjectFlagProperty<bool Function(BuildContext p1)>.has(
//           "isKeyboardVisible",
//           isKeyboardVisible,
//         ),
//       )
//       ..add(ColorProperty("themeColor", themeColor))
//       ..add(
//         DiagnosticsProperty<TextEditingController>(
//           "otpController",
//           otpController,
//         ),
//       )
//       ..add(StringProperty("mobileNumber", mobileNumber))
//       ..add(StringProperty("buttonTitle", buttonTitle));
//   }
// }
