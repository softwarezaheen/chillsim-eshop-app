// import "package:base_flutter/presentation/shared/shared_styles.dart";
// import "package:base_flutter/presentation/theme/theme_setup.dart";
// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
//
// class MyCheckBox extends StatelessWidget {
//   const MyCheckBox({
//     required this.selected,
//     required this.onChanged,
//     super.key,
//     this.checkBoxOnRight = true,
//     this.selectedDisplayText,
//     this.unselectedDisplayText,
//     this.checkBoxTextSpacing = 5.0,
//     this.svgSizeHeight = 20,
//     this.svgSizeWidth = 20,
//     this.textStyle,
//     this.checkboxColor,
//     this.disableGesture = false,
//   });
//   final bool selected;
//   final bool checkBoxOnRight;
//   final TextStyle? textStyle;
//   final double checkBoxTextSpacing;
//   final double svgSizeHeight;
//   final double svgSizeWidth;
//   final String? selectedDisplayText;
//   final String? unselectedDisplayText;
//   final ValueChanged<bool> onChanged;
//   final Color? checkboxColor;
//   String get checkMarkPath => "assets/images/checkbox_mark.png";
//   final bool disableGesture;
//
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> childrenWithCheckBox = <Widget>[
//       Text(
//         !selected ? (selectedDisplayText ?? "") : (unselectedDisplayText ?? ""),
//         style: textStyle ??
//             TextStyle(
//               color: Theme.of(context).colorScheme.cForeground(context),
//             ),
//       ),
//       SizedBox(width: checkBoxTextSpacing),
//       Container(
//         height: svgSizeHeight,
//         width: svgSizeWidth,
//         clipBehavior: Clip.hardEdge,
//         decoration: BoxDecoration(
//           color: selected ? (checkboxColor ?? themeColor) : null,
//           borderRadius: BorderRadius.circular(4),
//           border: Border.all(
//             color: Theme.of(context).colorScheme.cHintTextColor(context),
//           ),
//         ),
//         child: selected ? Image.asset(checkMarkPath) : null,
//       ),
//     ];
//
//     if (!checkBoxOnRight) {
//       childrenWithCheckBox = childrenWithCheckBox.reversed.toList();
//     }
//
//     return Container(
//       padding: EdgeInsets.zero,
//       child: Container(
//         child: disableGesture
//             ? Row(
//                 children: childrenWithCheckBox,
//               )
//             : GestureDetector(
//                 behavior: HitTestBehavior.translucent,
//                 onTap: () => <void>{onChanged(!selected)},
//                 child: Container(
//                   padding: const EdgeInsets.all(10),
//                   child: Row(
//                     children: childrenWithCheckBox,
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(DiagnosticsProperty<bool>("selected", selected))
//       ..add(DiagnosticsProperty<bool>("checkBoxOnRight", checkBoxOnRight))
//       ..add(DiagnosticsProperty<TextStyle?>("textStyle", textStyle))
//       ..add(DoubleProperty("checkBoxTextSpacing", checkBoxTextSpacing))
//       ..add(DoubleProperty("svgSizeHeight", svgSizeHeight))
//       ..add(DoubleProperty("svgSizeWidth", svgSizeWidth))
//       ..add(StringProperty("selectedDisplayText", selectedDisplayText))
//       ..add(StringProperty("unselectedDisplayText", unselectedDisplayText))
//       ..add(ObjectFlagProperty<ValueChanged<bool>>.has("onChanged", onChanged))
//       ..add(ColorProperty("checkboxColor", checkboxColor))
//       ..add(StringProperty("checkMarkPath", checkMarkPath))
//       ..add(DiagnosticsProperty<bool>("disableGesture", disableGesture));
//   }
// }
