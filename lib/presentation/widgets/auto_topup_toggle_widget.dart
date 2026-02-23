import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// Auto Top-Up Toggle Widget
///
/// Displays a card with auto top-up status and a toggle switch.
/// Used in the eSIM detail bottom sheet to enable/disable auto top-up.
class AutoTopupToggleWidget extends StatelessWidget {
  const AutoTopupToggleWidget({
    required this.isEnabled,
    required this.isUpdating,
    required this.bundleName,
    required this.onToggle,
    required this.showWidget,
    super.key,
  });

  final bool isEnabled;
  final bool isUpdating;
  final String bundleName;
  final Function(bool) onToggle;
  final bool showWidget;

  @override
  Widget build(BuildContext context) {
    if (!showWidget) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: EdgeInsets.zero,
      color: lightGreyBackGroundColor(context: context),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Title row
            Row(
              children: <Widget>[
                Icon(
                  Icons.bolt,
                  size: 16,
                  color: context.appColors.primary_800,
                ),
                const SizedBox(width: 6),
                Text(
                  LocaleKeys.auto_topup_settings_title.tr(),
                  style: captionOneMediumTextStyle(
                    context: context,
                    fontColor: titleTextColor(context: context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Description
            Text(
              LocaleKeys.auto_topup_settings_description.tr(),
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: contentTextColor(context: context),
              ).copyWith(fontSize: 11, height: 1.3),
            ),
            const SizedBox(height: 8),
            // Toggle row — only shown when enabled; hint shown when disabled
            if (isEnabled)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: context.appColors.baseWhite,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            LocaleKeys.auto_topup_enabled.tr(),
                            style: captionOneMediumTextStyle(
                              context: context,
                              fontColor: mainDarkTextColor(context: context),
                            ).copyWith(fontSize: 13),
                          ),
                          if (bundleName.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 2),
                            Text(
                              "${LocaleKeys.auto_topup_bundle.tr()}: $bundleName",
                              style: captionTwoNormalTextStyle(
                                context: context,
                                fontColor: contentTextColor(context: context),
                              ).copyWith(fontSize: 11),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (isUpdating)
                      SizedBox(
                        width: 56,
                        height: 32,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.appColors.primary_800!,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Container(
                        height: 32,
                        width: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Switch.adaptive(
                          value: isEnabled,
                          onChanged: onToggle,
                          activeColor: context.appColors.primary_800,
                          activeTrackColor:
                              context.appColors.primary_800!.withOpacity(0.5),
                          inactiveThumbColor: Colors.grey.shade400,
                          inactiveTrackColor: Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),
              )
            else
              Text(
                LocaleKeys.auto_topup_enable_hint.tr(),
                style: captionTwoNormalTextStyle(
                  context: context,
                  fontColor: contentTextColor(context: context),
                ).copyWith(fontSize: 12, height: 1.4),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>("isEnabled", isEnabled));
    properties.add(DiagnosticsProperty<bool>("isUpdating", isUpdating));
    properties.add(StringProperty("bundleName", bundleName));
    properties.add(ObjectFlagProperty<Function(bool)>.has("onToggle", onToggle));
    properties.add(DiagnosticsProperty<bool>("showWidget", showWidget));
  }
}
