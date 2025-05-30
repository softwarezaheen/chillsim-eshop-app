import "package:flutter/material.dart";

class StoryItem {
  StoryItem({
    required this.content,
    required this.buttons,
    required this.duration,
    this.useSplitTransition = false,
  });

  final Widget content;
  final Widget buttons;
  final Duration duration;
  final bool useSplitTransition;
}

class StoryViewerArgs {
  StoryViewerArgs({
    required this.stories,
    this.onComplete,
    this.autoClose = true,
    this.indicatorHeight = 6,
    this.indicatorBorderRadius = 16,
    this.indicatorColor = Colors.white,
    this.indicatorBackgroundColor = Colors.white30,
  });

  final bool autoClose;
  final List<StoryItem> stories;
  final Function()? onComplete;
  final double indicatorHeight;
  final double indicatorBorderRadius;
  final Color indicatorColor;
  final Color indicatorBackgroundColor;
}
