import 'package:esim_open_source/data/services/consent_initializer.dart';
import 'package:esim_open_source/data/services/consent_manager_service.dart';
import 'package:esim_open_source/presentation/shared/shared_styles.dart';
import 'package:esim_open_source/presentation/shared/ui_helpers.dart';
import 'package:esim_open_source/presentation/widgets/main_button.dart';
import 'package:esim_open_source/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConsentDialog extends StatefulWidget {
  const ConsentDialog({super.key});

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _analyticsConsent = true;
  bool _advertisingConsent = false;
  bool _personalizationConsent = false;
  final bool _functionalConsent = true; // Always required

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth(context) * 0.9,
          maxHeight: screenHeight(context) * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    color: Theme.of(context).primaryColor,
                    size: 28,
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    child: Text(
                      LocaleKeys.consentDialog_title.tr(),
                      style: headerTwoBoldTextStyle(context: context),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.consentDialog_description.tr(),
                      style: bodyNormalTextStyle(context: context),
                    ),
                    verticalSpaceMedium,

                    // Essential/Functional (Always required)
                    _buildConsentTile(
                      title: LocaleKeys.consentDialog_essentialTitle.tr(),
                      description: LocaleKeys.consentDialog_essentialDescription.tr(),
                      value: _functionalConsent,
                      onChanged: null, // Can't be disabled
                      required: true,
                      icon: Icons.security,
                    ),

                    verticalSpaceSmall,

                    // Analytics
                    _buildConsentTile(
                      title: LocaleKeys.consentDialog_analyticsTitle.tr(),
                      description: LocaleKeys.consentDialog_analyticsDescription.tr(),
                      value: _analyticsConsent,
                      onChanged: (value) => setState(() => _analyticsConsent = value),
                      icon: Icons.analytics_outlined,
                    ),

                    verticalSpaceSmall,

                    // Advertising
                    _buildConsentTile(
                      title: LocaleKeys.consentDialog_advertisingTitle.tr(),
                      description: LocaleKeys.consentDialog_advertisingDescription.tr(),
                      value: _advertisingConsent,
                      onChanged: (value) => setState(() => _advertisingConsent = value),
                      icon: Icons.ads_click_outlined,
                    ),

                    verticalSpaceSmall,

                    // Personalization
                    _buildConsentTile(
                      title: LocaleKeys.consentDialog_personalizationTitle.tr(),
                      description: LocaleKeys.consentDialog_personalizationDescription.tr(),
                      value: _personalizationConsent,
                      onChanged: (value) => setState(() => _personalizationConsent = value),
                      icon: Icons.person_outline,
                    ),

                    verticalSpaceMedium,

                    Text(
                      LocaleKeys.consentDialog_footerText.tr(),
                      style: captionOneNormalTextStyle(
                        context: context,
                        fontColor: Theme.of(context).hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Accept Selected
                  MainButton(
                    title: LocaleKeys.consentDialog_acceptSelected.tr(),
                    onPressed: () async {
                      await ConsentManagerService().updateConsent(
                        analytics: _analyticsConsent,
                        advertising: _advertisingConsent,
                        personalization: _personalizationConsent,
                        functional: _functionalConsent,
                      );
                      await ConsentInitializer.markConsentDialogShown();
                      if (context.mounted && Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      }
                    },
                    themeColor: Theme.of(context).primaryColor,
                  ),
                  
                  verticalSpaceSmall,
                  
                  // Quick options row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            // Accept all
                            await ConsentManagerService().updateConsent(
                              analytics: true,
                              advertising: true,
                              personalization: true,
                              functional: true,
                            );
                            await ConsentInitializer.markConsentDialogShown();
                            if (context.mounted && Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(LocaleKeys.consentDialog_acceptAll.tr()),
                        ),
                      ),
                      horizontalSpaceSmall,
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            // Essential only
                            await ConsentManagerService().updateConsent(
                              analytics: false,
                              advertising: false,
                              personalization: false,
                              functional: true,
                            );
                            await ConsentInitializer.markConsentDialogShown();
                            if (context.mounted && Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(LocaleKeys.consentDialog_essentialOnly.tr()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsentTile({
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool>? onChanged,
    bool required = false,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
              horizontalSpaceSmall,
              Expanded(
                child: Text(
                  title,
                  style: bodyMediumTextStyle(context: context),
                ),
              ),
              if (required)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    LocaleKeys.consentDialog_required.tr(),
                    style: captionTwoNormalTextStyle(
                      context: context,
                      fontColor: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value ? LocaleKeys.consentDialog_switchOn.tr() : LocaleKeys.consentDialog_switchOff.tr(),
                      style: captionTwoNormalTextStyle(
                        context: context,
                        fontColor: value ? Theme.of(context).primaryColor : Colors.grey,
                      ),
                    ),
                    horizontalSpaceSmall,
                    Transform.scale(
                      scale: 1.3, // Make switches even larger
                      child: Switch.adaptive(
                        value: value,
                        onChanged: onChanged,
                        activeColor: Theme.of(context).primaryColor,
                        activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.5),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.3),
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          verticalSpaceSmall,
          Text(
            description,
            style: captionOneNormalTextStyle(context: context),
          ),
        ],
      ),
    );
  }
}

// Helper function to show consent dialog
Future<void> showConsentDialog(BuildContext context) async {
  print('showConsentDialog: About to show dialog');
  try {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        print('showConsentDialog: Building ConsentDialog widget');
        return const ConsentDialog();
      },
    );
    print('showConsentDialog: Dialog completed');
  } catch (e) {
    print('showConsentDialog: Error showing dialog: $e');
  }
}