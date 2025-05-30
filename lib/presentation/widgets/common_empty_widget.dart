// import "package:esim_open_source/presentation/shared/ui_helpers.dart";
// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
//
// class CommonEmptyWidget extends StatelessWidget {
//   const CommonEmptyWidget({
//     required this.image,
//     required this.title,
//     this.imageWidth = 80,
//     this.imageHeight = 80,
//     super.key,
//   });
//   final String image;
//   final String title;
//   final double imageWidth;
//   final double imageHeight;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Image.asset(
//           image,
//           width: imageWidth,
//           height: imageHeight,
//         ),
//         verticalSpaceMedium,
//         Text(
//           title,
//           style: emptyWidgetTextStyle(
//             context: context,
//           ),
//         ),
//       ],
//     );
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(StringProperty("image", image))
//       ..add(StringProperty("title", title))
//       ..add(DoubleProperty("imageWidth", imageWidth))
//       ..add(DoubleProperty("imageHeight", imageHeight));
//   }
// }
