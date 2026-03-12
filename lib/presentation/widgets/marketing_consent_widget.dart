import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/extensions/context_extension.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

/// Marketing Consent Widget
///
/// Displays a compact CTA for marketing email consent (opt-out style).
/// Matches the web's PromotionsInline component shown after order success.
///
/// This widget should only be shown when:
/// - User is authenticated
/// - User has `should_notify` set to false or null (not yet opted in)
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
  // ignore: avoid_positional_boolean_parameters
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
            context.appColors.warning_400!.withValues(alpha: 0.08),
            context.appColors.primary_500!.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.appColors.warning_400!.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Title row with mail icon
          Row(
            children: <Widget>[
              Icon(
                Icons.mail_outline,
                size: 18,
                color: context.appColors.primary_500,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  LocaleKeys.marketing_consent_title.tr(),
                  style: bodyBoldTextStyle(
                    context: context,
                    fontColor: mainDarkTextColor(context: context),
                  ).copyWith(fontSize: 14),
                ),
              ),
            ],
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
          // Opt-out checkbox + label (matches web PromotionsInline pattern)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (isUpdating)
                Padding(
                  padding: const EdgeInsets.only(top: 2, right: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        context.appColors.warning_400!,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 22,
                  height: 22,
                  child: Checkbox(
                    value: !shouldNotify,
                    onChanged: (bool? value) {
                      if (value != null) {
                        onToggle(!value);
                      }
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    activeColor: context.appColors.warning_400,
                  ),
                ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: isUpdating ? null : () => onToggle(!shouldNotify),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      LocaleKeys.marketing_consent_opt_out_label.tr(),
                      style: captionTwoNormalTextStyle(
                        context: context,
                        fontColor: contentTextColor(context: context),
                      ).copyWith(fontSize: 10, height: 1.3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<bool>("shouldNotify", shouldNotify))
    ..add(DiagnosticsProperty<bool>("isUpdating", isUpdating))
    // ignore: avoid_positional_boolean_parameters
    ..add(ObjectFlagProperty<Function(bool)>.has("onToggle", onToggle))
    ..add(DiagnosticsProperty<bool>("showWidget", showWidget));
  }
}
