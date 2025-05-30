import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class EmptyStateWidget extends StatelessWidget {
  // Constructor
  const EmptyStateWidget({
    super.key,
    this.title,
    this.content,
    this.imagePath,
    this.button,
    this.imageWidth = 80,
    this.imageHeight = 80,
    this.separatorWidget = const SizedBox(
      height: 15,
    ),
  });

  final String? title;
  final String? content;
  final String? imagePath;
  final Widget? button;
  final double imageWidth;
  final double imageHeight;
  final Widget separatorWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          imagePath != null
              ? Column(
                  children: <Widget>[
                    Image.asset(
                      imagePath!,
                      width: imageWidth,
                      height: imageHeight,
                    ),
                    separatorWidget,
                  ],
                )
              : const SizedBox.shrink(),
          title != null
              ? Column(
                  children: <Widget>[
                    Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: headerThreeMediumTextStyle(
                        context: context,
                        fontColor: emptyStateTextColor(context: context),
                      ),
                    ),
                    separatorWidget,
                  ],
                )
              : const SizedBox.shrink(),
          content != null
              ? Column(
                  children: <Widget>[
                    Text(
                      content!,
                      textAlign: TextAlign.center,
                      style: bodyNormalTextStyle(
                        context: context,
                        fontColor: contentTextColor(context: context),
                      ),
                    ),
                    separatorWidget,
                  ],
                )
              : const SizedBox.shrink(),
          button != null
              ? Column(
                  children: <Widget>[
                    button!,
                    separatorWidget,
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty("title", title))
      ..add(StringProperty("content", content))
      ..add(StringProperty("imagePath", imagePath))
      ..add(DoubleProperty("imageWidth", imageWidth))
      ..add(DoubleProperty("imageHeight", imageHeight));
  }
}
