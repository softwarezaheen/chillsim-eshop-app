// import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
// import "package:esim_open_source/presentation/theme/theme_setup.dart";
// import "package:flutter/foundation.dart";
// import "package:flutter/material.dart";
//
// class MyPager extends StatefulWidget {
//   const MyPager({
//     required this.tabsTitle,
//     required this.tabsWidgets,
//     required this.themeColor,
//     super.key,
//     this.tabController,
//     this.initialValue = 0,
//     this.selectedBackgroundColor,
//     this.unSelectedBackgroundColor,
//     this.selectedTextStyle,
//     this.unSelectedTextStyle,
//     this.selectedBorder,
//     this.unSelectedBorder,
//     this.isScrollable = false,
//   });
//   final List<String> tabsTitle;
//   final List<Widget> tabsWidgets;
//   final Color themeColor;
//   final TabController? tabController;
//   final Color? selectedBackgroundColor;
//   final Color? unSelectedBackgroundColor;
//   final TextStyle? selectedTextStyle;
//   final TextStyle? unSelectedTextStyle;
//   final Border? selectedBorder;
//   final Border? unSelectedBorder;
//   final bool isScrollable;
//   final int initialValue;
//
//   @override
//   State<MyPager> createState() => _MyPagerState();
//
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(IterableProperty<String>("tabsTitle", tabsTitle))
//       ..add(ColorProperty("themeColor", themeColor))
//       ..add(DiagnosticsProperty<TabController?>("tabController", tabController))
//       ..add(ColorProperty("selectedBackgroundColor", selectedBackgroundColor))
//       ..add(
//         ColorProperty("unSelectedBackgroundColor", unSelectedBackgroundColor),
//       )
//       ..add(
//         DiagnosticsProperty<TextStyle?>(
//           "selectedTextStyle",
//           selectedTextStyle,
//         ),
//       )
//       ..add(
//         DiagnosticsProperty<TextStyle?>(
//           "unSelectedTextStyle",
//           unSelectedTextStyle,
//         ),
//       )
//       ..add(DiagnosticsProperty<Border?>("selectedBorder", selectedBorder))
//       ..add(DiagnosticsProperty<Border?>("unSelectedBorder", unSelectedBorder))
//       ..add(DiagnosticsProperty<bool>("isScrollable", isScrollable))
//       ..add(IntProperty("initialValue", initialValue));
//   }
// }
//
// class _MyPagerState extends State<MyPager> {
//   int _currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.initialValue;
//     widget.tabController?.addListener(() {
//       setState(() {
//         _currentIndex = widget.tabController?.index ?? _currentIndex;
//       });
//       // log("Selected Index: ${widget.tabController?.index}");
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // log("Selected  build Index: ${widget.tabController?.index}   build initialValue: ${widget.initialValue}");
//     return DefaultTabController(
//       length: widget.tabsWidgets.length,
//       child: Column(
//         children: <Widget>[
//           ColoredBox(
//             color: widget.themeColor,
//             child: Stack(
//               children: <Widget>[
//                 // Positioned.fill(
//                 //   child: Align(
//                 //       alignment: Alignment.bottomCenter,
//                 //       child: Container(
//                 //           height: 1.0,
//                 //           decoration: const BoxDecoration(boxShadow: [BoxShadow(blurRadius: 4.0, spreadRadius: 4, offset: Offset(0, 8.0))]))),
//                 // ),
//                 Column(
//                   children: <Widget>[
//                     TabBar(
//                       tabAlignment:
//                           widget.isScrollable ? TabAlignment.start : null,
//                       labelPadding: widget.isScrollable
//                           ? const EdgeInsets.only(left: 16)
//                           : null,
//                       indicatorPadding: widget.isScrollable
//                           ? const EdgeInsets.only(left: 16)
//                           : EdgeInsets.zero,
//                       isScrollable: widget.isScrollable,
//                       controller: widget.tabController,
//                       onTap: (int index) {
//                         setState(() {
//                           _currentIndex = index;
//                         });
//                       },
//                       indicatorColor: Colors.transparent,
//                       tabs: generateTabs(
//                         selectedIndex: _currentIndex,
//                         tabsTitle: widget.tabsTitle,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Container(
//               margin: EdgeInsets.zero,
//               height: double.infinity,
//               width: double.infinity,
//               // decoration: BoxDecoration(
//               //     color: Colors.grey,
//               //     // borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
//               //     boxShadow: [
//               //       BoxShadow(
//               //         color: Colors.grey.withValues(alpha:0.3),
//               //         spreadRadius: 5,
//               //         blurRadius: 10,
//               //         offset: Offset(0, 10.0), // changes position of shadow
//               //       )
//               //     ]),
//               child: TabBarView(
//                 controller: widget.tabController,
//                 children: widget.tabsWidgets,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> generateTabs({
//     required List<String> tabsTitle,
//     required int selectedIndex,
//   }) {
//     // log("generateTabs");
//     return tabsTitle
//         .mapIndexed(
//           (String title, int index) => Tab(
//             height: 50,
//             child: Align(
//               alignment: Alignment.topCenter,
//               child: DecoratedBox(
//                 decoration: BoxDecoration(
//                   color: index == selectedIndex
//                       ? widget.selectedBackgroundColor ?? Colors.white
//                       : widget.unSelectedBackgroundColor ?? Colors.transparent,
//                   borderRadius: BorderRadius.circular(25),
//                   border: index == selectedIndex
//                       ? widget.selectedBorder
//                       : widget.unSelectedBorder,
//                 ),
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: Text(
//                     title,
//                     style: index == selectedIndex
//                         ? widget.selectedTextStyle ??
//                             tabBarTitleTextStyle(
//                               context,
//                               Theme.of(context).colorScheme.cError(context),
//                             )
//                         : widget.unSelectedTextStyle ??
//                             tabBarUnselectedTitleTextStyle(context),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         )
//         .toList();
//   }
// }
