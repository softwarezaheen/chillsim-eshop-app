import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/material.dart";

/// Marketing Consent Widget
/// 
/// Displays a compact CTA to enable marketing emails (promotional notifications).
/// Similar to the web's PromotionsInline component shown after order success.
/// 
/// This widget should only be shown when:
/// - User is authenticated
/// - User has `should_notify` set to false initially
class MarketingConsentWidget extends StatelessWidget {
  const MarketingConsentWidget({
    required this.shouldNotify,
    required this.isUpdating,
    required this.onToggle,
    required this.showWidget,
    super.key,
  });

  final bool shouldNotify;
  final bool isUpdating;
  final Function(bool) onToggle;
  final bool showWidget;

  @override
  Widget build(BuildContext context) {
    // Don't show if parent says to hide
    if (!showWidget) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            context.appColors.warning_400!.withOpacity(0.08),
            context.appColors.primary_500!.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.appColors.warning_400!.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Title
          Text(
            LocaleKeys.marketing_consent_title.tr(),
            style: bodyBoldTextStyle(
              context: context,
              fontColor: mainDarkTextColor(context: context),
            ).copyWith(fontSize: 14),
          ),
          const SizedBox(height: 6),
          // Description
          Text(
            LocaleKeys.marketing_consent_description.tr(),
            style: captionTwoNormalTextStyle(
              context: context,
              fontColor: contentTextColor(context: context),
            ).copyWith(fontSize: 11, height: 1.3),
          ),
          const SizedBox(height: 8),
          // Toggle Switch Row
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.appColors.baseWhite,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    shouldNotify
                        ? LocaleKeys.marketing_consent_toggle_enabled.tr()
                        : LocaleKeys.marketing_consent_toggle_disabled.tr(),
                    style: captionOneMediumTextStyle(
                      context: context,
                      fontColor: mainDarkTextColor(context: context),
                    ).copyWith(fontSize: 13),
                  ),
                ),
                const SizedBox(width: 12),
                // Show loading spinner when updating, otherwise show switch
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
                            context.appColors.warning_400!,
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
                      value: shouldNotify,
                      onChanged: onToggle,
                      activeColor: context.appColors.warning_400,
                      activeTrackColor: context.appColors.warning_400!.withOpacity(0.5),
                      inactiveThumbColor: Colors.grey.shade400,
                      inactiveTrackColor: Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
