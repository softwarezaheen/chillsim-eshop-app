// import "package:esim_open_source/presentation/shared/shared_styles.dart";
// import "package:esim_open_source/presentation/shared/ui_helpers.dart";
// import "package:esim_open_source/presentation/widgets/animations/opacity_animation.dart";
// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
// import "package:flutter_hooks/flutter_hooks.dart";
//
// class NoDataScreen extends HookWidget {
//   const NoDataScreen({
//     required this.title,
//     required this.subTitle,
//     super.key,
//     this.assetImage,
//   });
//   final String title;
//   final String subTitle;
//   final String? assetImage;
//
//   @override
//   Widget build(BuildContext context) {
//     AnimationController controller =
//         useAnimationController(duration: const Duration(milliseconds: 500));
//     return OpacityAnimation(
//       controller: controller,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Image.asset(
//               "assets/images/image_esim.png",
//               width: double.infinity,
//               height: 330,
//               fit: BoxFit.contain,
//             ),
//             verticalSpaceMediumLarge,
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: headerThreeMediumTextStyle(context: context),
//             ),
//             verticalSpaceSmall,
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Text(
//                 textAlign: TextAlign.center,
//                 subTitle,
//                 style: captionOneNormalTextStyle(context: context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(StringProperty("title", title))
//       ..add(StringProperty("subTitle", subTitle))
//       ..add(StringProperty("assetImage", assetImage));
//   }
// }
