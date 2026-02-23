import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// Auto Top-Up Prompt Widget
///
/// Displays a compact CTA to enable auto top-up after a successful purchase.
/// Similar pattern to MarketingConsentWidget — gradient container with action button.
///
/// This widget should only be shown when:
/// - User is authenticated
/// - The purchased bundle supports top-up
/// - Auto top-up is not already enabled for this eSIM
class AutoTopupPromptWidget extends StatelessWidget {
  const AutoTopupPromptWidget({
    required this.bundleName,
    required this.isEnabling,
    required this.onEnable,
    required this.showWidget,
    this.isEnabled = false,
    this.isDisabling = false,
    this.onDisable,
    super.key,
  });

  final String bundleName;
  final bool isEnabling;
  final VoidCallback onEnable;
  final bool showWidget;
  final bool isEnabled;
  final bool isDisabling;
  final VoidCallback? onDisable;

  @override
  Widget build(BuildContext context) {
    if (!showWidget) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            context.appColors.primary_500!.withOpacity(0.08),
            context.appColors.primary_800!.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.appColors.primary_500!.withOpacity(0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Title row with bolt icon and toggle inline
          Row(
            children: <Widget>[
              Icon(Icons.bolt, size: 18, color: context.appColors.primary_800),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  LocaleKeys.auto_topup_prompt_title.tr(),
                  style: bodyBoldTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ).copyWith(fontSize: 14),
                ),
              ),
              if (isEnabling || isDisabling)
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.appColors.primary_800!,
                    ),
                  ),
                )
              else
                Transform.scale(
                  scale: 0.75,
                  child: Container(
                    height: 32,
                    width: 56,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Switch.adaptive(
                      value: isEnabled,
                      onChanged: (bool v) => v ? onEnable() : onDisable?.call(),
                      activeColor: Colors.white,
                      activeTrackColor: context.appColors.primary_800,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          // Description or confirmation text depending on state
          if (isEnabled)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.check_circle, size: 14, color: context.appColors.primary_800),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    LocaleKeys.auto_topup_enabled_confirmation.tr(
                      namedArgs: <String, String>{"bundle": bundleName},
                    ),
                    style: captionTwoNormalTextStyle(
                      context: context,
                      fontColor: context.appColors.primary_800,
                    ).copyWith(fontSize: 11, height: 1.3),
                  ),
                ),
              ],
            )
          else
            Text(
              LocaleKeys.auto_topup_prompt_description.tr(
                namedArgs: <String, String>{"bundle": bundleName},
              ),
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: contentTextColor(context: context),
              ).copyWith(fontSize: 11, height: 1.3),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty("bundleName", bundleName));
    properties.add(DiagnosticsProperty<bool>("isEnabling", isEnabling));
    properties.add(DiagnosticsProperty<bool>("isDisabling", isDisabling));
    properties.add(ObjectFlagProperty<VoidCallback>.has("onEnable", onEnable));
    properties.add(ObjectFlagProperty<VoidCallback?>.has("onDisable", onDisable));
    properties.add(DiagnosticsProperty<bool>("showWidget", showWidget));
    properties.add(DiagnosticsProperty<bool>("isEnabled", isEnabled));
  }
}
