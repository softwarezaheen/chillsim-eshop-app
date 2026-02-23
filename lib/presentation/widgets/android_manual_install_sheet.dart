import "package:easy_localization/easy_localization.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/translations/locale_keys.g.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";

class AndroidManualInstallSheet extends StatelessWidget {
  const AndroidManualInstallSheet({
    String? activationLink,
    VoidCallback? onCopy,
    this.onOpenSettings,
    super.key,
  })  : activationLink = activationLink ?? "",
        onCopy = onCopy ?? _noop;

  final String activationLink;
  final VoidCallback onCopy;
  final Future<void> Function()? onOpenSettings;

  static void _noop() {}

  static Future<void> show({
    required BuildContext context,
    required String activationLink,
    required VoidCallback onCopy,
    Future<void> Function()? onOpenSettings,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext sheetContext) => AndroidManualInstallSheet(
        activationLink: activationLink,
        onCopy: onCopy,
        onOpenSettings: onOpenSettings,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color titleColor = mainDarkTextColor(context: context);
    final Color subtitleColor = contentTextColor(context: context);
    final Color cardColor = bodyBackGroundColor(context: context);
    final double maxHeight = MediaQuery.of(context).size.height * 0.9;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        LocaleKeys.android_manual_install_title.tr(),
                        style: headerThreeMediumTextStyle(
                          context: context,
                          fontColor: titleColor,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: subtitleColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                verticalSpaceSmall,
                Text(
                  LocaleKeys.android_manual_install_description.tr(),
                  style: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: subtitleColor,
                  ),
                ),
                verticalSpaceMedium,
                _OptionCard(
                  icon: Icons.qr_code_scanner_outlined,
                  backgroundColor: cardColor,
                  title: LocaleKeys.android_manual_install_option_qr_title.tr(),
                  titleStyle: captionOneMediumTextStyle(
                    context: context,
                    fontColor: titleColor,
                  ),
                  description:
                      LocaleKeys.android_manual_install_option_qr_steps.tr(),
                  descriptionStyle: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: subtitleColor,
                  ),
                ),
                verticalSpaceSmall,
                _OptionCard(
                  icon: Icons.link_outlined,
                  backgroundColor: cardColor,
                  title: LocaleKeys.android_manual_install_steps_title.tr(),
                  titleStyle: captionOneMediumTextStyle(
                    context: context,
                    fontColor: titleColor,
                  ),
                  description: "",
                  descriptionStyle: captionTwoNormalTextStyle(
                    context: context,
                    fontColor: subtitleColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      verticalSpaceSmall,
                      Text(
                        LocaleKeys.android_manual_install_link_label.tr(),
                        style: captionTwoMediumTextStyle(
                          context: context,
                          fontColor: titleColor,
                        ),
                      ),
                      verticalSpaceTiny,
                      _ActivationLinkField(
                        activationLink: activationLink,
                        subtitleColor: subtitleColor,
                        onCopy: onCopy,
                      ),
                      verticalSpaceSmall,
                      Text(
                        LocaleKeys.android_manual_install_steps_body.tr(),
                        style: captionTwoNormalTextStyle(
                          context: context,
                          fontColor: subtitleColor,
                        ),
                      ),
                      verticalSpaceTiny,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.info_outline,
                            size: 16,
                            color: subtitleColor,
                          ),
                          horizontalSpaceTiny,
                          Expanded(
                            child: Text(
                              LocaleKeys.android_manual_install_link_tip.tr(),
                              style: captionTwoNormalTextStyle(
                                context: context,
                                fontColor: subtitleColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                MainButton(
                  title: LocaleKeys.android_manual_install_open_settings.tr(),
                  onPressed: () async {
                    await onOpenSettings?.call();
                  },
                  themeColor: themeColor,
                  hideShadows: true,
                ),
                verticalSpaceSmall,
                MainButton.emptyBackground(
                  title: LocaleKeys.android_manual_install_close.tr(),
                  onPressed: () => Navigator.of(context).pop(),
                  hideShadows: true,
                  themeColor: themeColor,
                  borderColor: Colors.transparent,
                  titleTextStyle: captionOneMediumTextStyle(
                    context: context,
                    fontColor: titleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty("activationLink", activationLink))
    ..add(ObjectFlagProperty<VoidCallback>.has("onCopy", onCopy))
    ..add(ObjectFlagProperty<Future<void> Function()?>.has("onOpenSettings", onOpenSettings));
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.backgroundColor,
    required this.title,
    required this.titleStyle,
    required this.description,
    required this.descriptionStyle,
    this.child,
  });

  final IconData icon;
  final Color backgroundColor;
  final String title;
  final TextStyle titleStyle;
  final String description;
  final TextStyle descriptionStyle;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: titleStyle.color ?? Colors.white70),
              horizontalSpaceSmall,
              Expanded(
                child: Text(
                  title,
                  style: titleStyle,
                ),
              ),
            ],
          ),
          if (description.isNotEmpty) ...<Widget>[
            verticalSpaceTiny,
            Text(
              description,
              style: descriptionStyle,
            ),
          ],
          if (child != null) child!,
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty<IconData>("icon", icon))
    ..add(ColorProperty("backgroundColor", backgroundColor))
    ..add(StringProperty("title", title))
    ..add(DiagnosticsProperty<TextStyle>("titleStyle", titleStyle))
    ..add(StringProperty("description", description))
    ..add(DiagnosticsProperty<TextStyle>("descriptionStyle", descriptionStyle));
  }
}

class _ActivationLinkField extends StatelessWidget {
  const _ActivationLinkField({
    required this.activationLink,
    required this.subtitleColor,
    required this.onCopy,
  });

  final String activationLink;
  final Color? subtitleColor;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: SelectableText(
              activationLink,
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: subtitleColor,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy_outlined, color: subtitleColor),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(StringProperty("activationLink", activationLink))
    ..add(ColorProperty("subtitleColor", subtitleColor))
    ..add(ObjectFlagProperty<VoidCallback>.has("onCopy", onCopy));
  }
}
