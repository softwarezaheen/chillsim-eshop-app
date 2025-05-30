// import "package:esim_open_source/presentation/shared/shared_styles.dart";
// import "package:esim_open_source/presentation/shared/ui_helpers.dart";
// import "package:esim_open_source/presentation/theme/theme_setup.dart";
// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
//
// /// A button that shows a busy indicator in place of title
// class ShareButton extends StatefulWidget {
//   const ShareButton({
//     required this.onPressed,
//     this.title = "SHARE",
//     this.enabled = true,
//     super.key,
//     this.iconData = const Icon(
//       Icons.share, // add custom icons also
//       color: Colors.white,
//       size: 20,
//     ),
//   });
//   final String title;
//   final Icon iconData;
//   final void Function() onPressed;
//   final bool enabled;
//
//   @override
//   ShareButtonState createState() => ShareButtonState();
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(StringProperty("title", title))
//       ..add(ObjectFlagProperty<void Function()>.has("onPressed", onPressed))
//       ..add(DiagnosticsProperty<bool>("enabled", enabled));
//   }
// }
//
// class ShareButtonState extends State<ShareButton> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onPressed,
//       child: InkWell(
//         child: AnimatedContainer(
//           height: 45,
//           duration: const Duration(milliseconds: 300),
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
//           decoration: BoxDecoration(
//             color: widget.enabled
//                 ? Theme.of(context).colorScheme.cHintTextColor(context)
//                 : Colors.grey[300],
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 widget.title,
//                 textAlign: TextAlign.center,
//                 style: buttonTitleTextStyleDef,
//               ),
//               horizontalSpaceTiny,
//               widget.iconData,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
