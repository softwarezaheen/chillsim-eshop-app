import "package:esim_open_source/presentation/extensions/helper_extensions.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/widgets/lockable_tab_bar.dart";
import "package:esim_open_source/presentation/widgets/top_indicator.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class BaseFlutterBottomNavBar extends StatefulWidget {
  const BaseFlutterBottomNavBar({
    required this.tabsIconData,
    required this.tabsWidgets,
    required this.tabsText,
    super.key,
    this.indicatorsColor,
    this.indicatorColor,
    this.selectedColor,
    this.unselectedColor,
    this.height = 50,
    this.swipeEnabled = true,
    this.isKeyboardVisible = false,
    this.tabController,
  });
  final List<String> tabsIconData;
  final List<String> tabsText;
  final List<Widget> tabsWidgets;
  final List<Color>? indicatorsColor;
  final Color? indicatorColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double height;
  final bool swipeEnabled;
  final bool isKeyboardVisible;
  final LockableTabController? tabController;
  @override
  State<BaseFlutterBottomNavBar> createState() =>
      _BaseFlutterBottomNavBarState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<String>("tabsIconData", tabsIconData))
      ..add(IterableProperty<String>("tabsText", tabsText))
      ..add(IterableProperty<Color>("indicatorsColor", indicatorsColor))
      ..add(ColorProperty("indicatorColor", indicatorColor))
      ..add(ColorProperty("selectedColor", selectedColor))
      ..add(ColorProperty("unselectedColor", unselectedColor))
      ..add(DoubleProperty("height", height))
      ..add(DiagnosticsProperty<bool>("swipeEnabled", swipeEnabled))
      ..add(DiagnosticsProperty<bool>("isKeyboardVisible", isKeyboardVisible))
      ..add(
        DiagnosticsProperty<TabController?>("tabController", tabController),
      );
  }
}

class _BaseFlutterBottomNavBarState extends State<BaseFlutterBottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Attach listener on initialization
    widget.tabController?.addListener(indexUpdated);
  }

  void indexUpdated() {
    // Prevent setState on disposed widget (critical for iOS background/foreground transitions)
    if (!mounted) {
      return;
    }
    setState(() {
      _currentIndex = widget.tabController?.index ?? _currentIndex;
    });
  }

  @override
  void didUpdateWidget(covariant BaseFlutterBottomNavBar oldWidget) {
    // Remove listener from old controller and add to new one
    if (oldWidget.tabController != widget.tabController) {
      oldWidget.tabController?.removeListener(indexUpdated);
      widget.tabController?.addListener(indexUpdated);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // Critical: Remove listener to prevent memory leaks and crashes on iOS
    widget.tabController?.removeListener(indexUpdated);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabsWidgets.length,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.zero,
              height: double.infinity,
              width: double.infinity,
              // decoration: BoxDecoration(color: Colors.grey,
              //     // borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10), bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.grey.withValues(alpha:0.3),
              //         spreadRadius: 5,
              //         blurRadius: 10,
              //         offset: Offset(0, 10.0), // changes position of shadow
              //       )
              //     ]),
              child: TabBarView(
                controller: widget.tabController,
                physics: widget.swipeEnabled
                    ? null
                    : const NeverScrollableScrollPhysics(),
                children: widget.tabsWidgets,
              ),
            ),
          ),
          // Use AnimatedSwitcher to prevent sudden disappearance on iOS
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: widget.isKeyboardVisible
                ? const SizedBox.shrink(
                    key: ValueKey<String>("hidden"),
                  )
                : Stack(
                    key: const ValueKey<String>("visible"),
                    children: <Widget>[
                      // Positioned.fill(
                      //   child: Align(
                      //       alignment: Alignment.topCenter,
                      //       child: Container(
                      //           height: 0.5,
                      //           decoration: BoxDecoration(
                      //             boxShadow: [
                      //               BoxShadow(
                      //                 color: Colors.grey.withValues(alpha:0.2),
                      //                 blurRadius: 5.0,
                      //                 spreadRadius: 2,
                      //                 offset: Offset(0, -8.0),
                      //               ),
                      //             ],
                      //           ))),
                      // ),
                      DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.15),
                            spreadRadius: 1,
                            blurRadius: 6,
                            offset: const Offset(0, -4),
                          ), // changes position of shadow
                        ],
                      ),
                      child: Container(
                        color: Colors.white,
                        height: widget.height,
                        child: TabBar(
                          controller: widget.tabController,
                          overlayColor: WidgetStateProperty.all(
                            widget.selectedColor?.withValues(alpha: 0.015) ??
                                Colors.transparent,
                          ),
                          onTap: (int index) {
                            if (widget.tabController?.isLocked ?? false) {
                              return;
                            }
                            // if (mounted) {
                            setState(() {
                              _currentIndex = index;
                            });
                            // }
                          },
                          indicatorColor:
                              getColorForIndex(selectedIndex: _currentIndex),
                          indicator: TopIndicator(
                            color: getColorForIndex(
                              selectedIndex: _currentIndex,
                            ),
                            strokeWidth: 2,
                            additionalWidth: 5,
                          ),
                          indicatorWeight: 1,
                          tabs: generateTabs(
                            selectedIndex: _currentIndex,
                            tabsIconData: widget.tabsIconData,
                            tabsText: widget.tabsText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Color getColorForIndex({required int selectedIndex}) {
    if (widget.indicatorsColor != null &&
        (widget.indicatorsColor?.length ?? 0) > selectedIndex) {
      return widget.indicatorsColor![selectedIndex];
    }

    return widget.indicatorColor ?? Colors.transparent;
  }

  List<Widget> generateTabs({
    required List<String> tabsIconData,
    required List<String> tabsText,
    required int selectedIndex,
  }) {
    return tabsIconData
        .mapIndexed(
          (String imageName, int index) => SizedBox(
            height: widget.height,
            // color: Colors.greenAccent,
            child: Padding(
              padding: EdgeInsets.zero,
              child: Tab(
                // icon: Icon(iconData, color: index == selectedIndex ? widget.selectedColor : widget.unselectedColor),
                // text: tabsText.length > index ? tabsText[index] : "",
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      imageName,
                      width: 20,
                      height: 20,
                      color: index == selectedIndex
                          ? widget.selectedColor
                          : widget.unselectedColor,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      tabsText.length > index ? tabsText[index] : "",
                      textAlign: TextAlign.center,
                      style: captionTwoBoldTextStyle(context: context).copyWith(
                        fontSize: 13,
                        color: index == selectedIndex
                            ? bottomNavbarSelectedBackGroundColor(
                                context: context,
                              )
                            : bottomNavbarUnselectedBackGroundColor(
                                context: context,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
