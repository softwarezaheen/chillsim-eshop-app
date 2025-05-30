import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class WarningWidget extends StatelessWidget {
  const WarningWidget({required this.warningTextContent, super.key});

  final String warningTextContent;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      color: myEsimSecondaryBackGroundColor(context: context),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              spacing: 12,
              children: <Widget>[
                Icon(
                  size: 18,
                  Icons.info_outline,
                  color: context.appColors.baseWhite,
                ),
                Text(
                  "Warning",
                  style: captionTwoBoldTextStyle(context: context)
                      .copyWith(color: context.appColors.baseWhite),
                ),
              ],
            ),
            Text(
              warningTextContent,
              style: captionTwoBoldTextStyle(context: context)
                  .copyWith(color: context.appColors.baseWhite),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty("warningTextContent", warningTextContent));
  }
}
