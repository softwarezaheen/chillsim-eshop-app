import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:esim_open_source/data/services/analytics_service_impl.dart';
import 'package:esim_open_source/data/services/consent_initializer.dart';
import 'package:esim_open_source/data/services/consent_manager_service.dart';
import 'package:esim_open_source/presentation/shared/shared_styles.dart';
import 'package:esim_open_source/presentation/shared/ui_helpers.dart';
import 'package:esim_open_source/presentation/widgets/main_button.dart';
import 'package:esim_open_source/translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsentDialog extends StatefulWidget {
  const ConsentDialog({super.key});

  @override
  State<ConsentDialog> createState() => _ConsentDialogState();
}

class _ConsentDialogState extends State<ConsentDialog> {
  bool _analyticsConsent = true;
  bool _advertisingConsent = false;
  bool _personalizationConsent = false;
  bool _isLoading = true;
  
  // ATT guidance dialog state
  bool _isShowingAttGuidance = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentConsentState();
  }

  Future<void> _loadCurrentConsentState() async {
    final ConsentManagerService consentService = ConsentManagerService();
    final Map<ConsentType, bool> currentConsent = await consentService.getConsentStatus();
    
    setState(() {
      _analyticsConsent = currentConsent[ConsentType.analytics] ?? true;
      _advertisingConsent = currentConsent[ConsentType.advertising] ?? false;
      _personalizationConsent = currentConsent[ConsentType.personalization] ?? false;
      _isLoading = false;
    });
  }

  /// Check ATT status before allowing tracking toggle
  /// Returns true if toggle is allowed, false if guidance should be shown
  Future<bool> _checkAttStatusForTracking({
    required bool isEnabling,
    required String trackingType,
  }) async {
    // Only check on iOS and only when ENABLING tracking
    if (!Platform.isIOS || !isEnabling) {
      return true; // Allow toggle
    }

    try {
      final AnalyticsServiceImpl analyticsService = AnalyticsServiceImpl.instance;
      
      // Check if tracking is blocked by ATT
      if (analyticsService.isTrackingBlockedByATT()) {
        // Show guidance dialog
        await _showAttGuidanceDialog();
        return false; // Don't allow toggle
      }

      return true; // Allow toggle
    } catch (e) {
      print('Error checking ATT status: $e');
      return true; // Allow toggle on error
    }
  }

  /// Show ATT guidance dialog with iOS Settings navigation
  Future<void> _showAttGuidanceDialog() async {
    if (_isShowingAttGuidance) return; // Prevent multiple dialogs
    
    setState(() {
      _isShowingAttGuidance = true;
    });

    try {
      final AnalyticsServiceImpl analyticsService = AnalyticsServiceImpl.instance;
      final String messageKey = analyticsService.getAttGuidanceMessageKey();
      
      // Default to general message if no specific key
      final String message = messageKey.isNotEmpty 
          ? messageKey.tr() 
          : LocaleKeys.attGuidance_general_message.tr();

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.privacy_tip_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    LocaleKeys.attGuidance_title.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(LocaleKeys.attGuidance_understood.tr()),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _openIOSSettings();
                },
                child: Text(LocaleKeys.attGuidance_goToSettings.tr()),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isShowingAttGuidance = false;
      });
    }
  }

  /// Open iOS Settings for the app
  Future<void> _openIOSSettings() async {
    try {
      final Uri settingsUri = Uri.parse('app-settings:');
      await launchUrl(settingsUri, mode: LaunchMode.externalApplication);
      print('📱 Opened iOS Settings');
    } catch (e) {
      print('Error opening iOS Settings: $e');
    }
  }

  /// Handle analytics toggle with ATT checking
  Future<void> _handleAnalyticsToggle(bool value) async {
    if (value) {
      // User is enabling analytics - check ATT
      final bool allowed = await _checkAttStatusForTracking(
        isEnabling: true,
        trackingType: 'analytics',
      );
      
      if (!allowed) return; // ATT guidance was shown
    }
    
    setState(() {
      _analyticsConsent = value;
    });
  }

  /// Handle advertising toggle with ATT checking
  Future<void> _handleAdvertisingToggle(bool value) async {
    if (value) {
      // User is enabling advertising - check ATT
      final bool allowed = await _checkAttStatusForTracking(
        isEnabling: true,
        trackingType: 'advertising',
      );
      
      if (!allowed) return; // ATT guidance was shown
    }
    
    setState(() {
      _advertisingConsent = value;
    });
  }

  /// Handle Accept All with ATT checking
  /// REASONING: Accept All should also trigger ATT if tracking is being enabled
  Future<void> _handleAcceptAll() async {
    // Check current consent status
    final ConsentManagerService consentService = ConsentManagerService();
    final Map<ConsentType, bool> currentConsent = await consentService.getConsentStatus();
    
    final bool currentAnalytics = currentConsent[ConsentType.analytics] ?? false;
    final bool currentAdvertising = currentConsent[ConsentType.advertising] ?? false;
    
    // Check if we're enabling any tracking that's currently disabled
    final bool enablingAnalytics = !currentAnalytics; // Accept All enables analytics
    final bool enablingAdvertising = !currentAdvertising; // Accept All enables advertising
    
    if (enablingAnalytics || enablingAdvertising) {
      final bool allowed = await _checkAttStatusForTracking(
        isEnabling: true,
        trackingType: 'all',
      );
      
      if (!allowed) {
        // ATT guidance was shown and user didn't enable ATT
        // Do NOT update UI state - keep current state
        return;
      }
    }

    // ATT check passed or not needed - update UI state and proceed
    setState(() {
      _analyticsConsent = true;
      _advertisingConsent = true;
      _personalizationConsent = true;
    });

    // Save the consent
    await ConsentManagerService().updateConsent(
      analytics: true,
      advertising: true,
      personalization: true,
      functional: true,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  /// Handle Accept Selected with ATT checking
  Future<void> _handleAcceptSelected() async {
    // Check if we're enabling any tracking that's currently disabled
    final ConsentManagerService consentService = ConsentManagerService();
    final Map<ConsentType, bool> currentConsent = await consentService.getConsentStatus();
    
    final bool currentAnalytics = currentConsent[ConsentType.analytics] ?? false;
    final bool currentAdvertising = currentConsent[ConsentType.advertising] ?? false;
    
    final bool enablingAnalytics = _analyticsConsent && !currentAnalytics;
    final bool enablingAdvertising = _advertisingConsent && !currentAdvertising;
    
    if (enablingAnalytics || enablingAdvertising) {
      final bool allowed = await _checkAttStatusForTracking(
        isEnabling: true,
        trackingType: 'selected',
      );
      
      if (!allowed) return; // ATT guidance was shown
    }

    // Proceed with Accept Selected
    await ConsentManagerService().updateConsent(
      analytics: _analyticsConsent,
      advertising: _advertisingConsent,
      personalization: _personalizationConsent,
      functional: true,
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          height: 200,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: screenWidth(context) * 0.92,
          maxHeight: screenHeight(context) * 0.90,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.08),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.privacy_tip_outlined,
                      color: Theme.of(context).primaryColor,
                      size: 22,
                    ),
                  ),
                  horizontalSpaceSmall,
                  Expanded(
                    child: Text(
                      LocaleKeys.consentDialog_title.tr(),
                      style: headerThreeBoldTextStyle(context: context),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.consentDialog_description.tr(),
                      style: captionOneMediumTextStyle(
                        context: context,
                        fontColor: contentTextColor(context: context),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Analytics
                    _buildConsentTile(
                      title: LocaleKeys.consentDialog_analyticsTitle.tr(),
                      description: LocaleKeys.consentDialog_analyticsDescription.tr(),
                      value: _analyticsConsent,
                      onChanged: (value) => _handleAnalyticsToggle(value),
                      icon: Icons.analytics_outlined,
                    ),

                    const SizedBox(height: 10),

                    // Advertising
                    _buildConsentTile(
                      title: LocaleKeys.consentDialog_advertisingTitle.tr(),
                      description: LocaleKeys.consentDialog_advertisingDescription.tr(),
                      value: _advertisingConsent,
                      onChanged: (value) => _handleAdvertisingToggle(value),
                      icon: Icons.ads_click_outlined,
                    ),

                    const SizedBox(height: 10),

                    // Personalization
                    _buildConsentTile(
                      title: LocaleKeys.consentDialog_personalizationTitle.tr(),
                      description: LocaleKeys.consentDialog_personalizationDescription.tr(),
                      value: _personalizationConsent,
                      onChanged: (value) => setState(() => _personalizationConsent = value),
                      icon: Icons.person_outline,
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: lightGreyBackGroundColor(context: context),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        LocaleKeys.consentDialog_footerText.tr(),
                        style: captionTwoNormalTextStyle(
                          context: context,
                          fontColor: secondaryTextColor(context: context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: BoxDecoration(
                color: lightGreyBackGroundColor(context: context).withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Accept Selected
                  MainButton(
                    title: LocaleKeys.consentDialog_acceptSelected.tr(),
                    onPressed: () async {
                      await _handleAcceptSelected();
                    },
                    themeColor: Theme.of(context).primaryColor,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Quick options row
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            // Use ATT-aware Accept All handler
                            // This will handle UI updates only after ATT succeeds
                            await _handleAcceptAll();
                          },
                          child: Text(
                            LocaleKeys.consentDialog_acceptAll.tr(),
                            style: captionOneMediumTextStyle(context: context),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            // Update the dialog state first
                            setState(() {
                              _analyticsConsent = false;
                              _advertisingConsent = false;
                              _personalizationConsent = false;
                            });
                            
                            // Wait a moment to show the updated state
                            await Future.delayed(const Duration(milliseconds: 300));
                            
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
                          child: Text(
                            LocaleKeys.consentDialog_essentialOnly.tr(),
                            style: captionOneMediumTextStyle(context: context),
                          ),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: value 
            ? Theme.of(context).primaryColor.withOpacity(0.3)
            : Theme.of(context).dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: value 
          ? Theme.of(context).primaryColor.withOpacity(0.03)
          : Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: captionOneBoldTextStyle(context: context),
                ),
              ),
              if (required)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    LocaleKeys.consentDialog_required.tr(),
                    style: captionTwoMediumTextStyle(
                      context: context,
                      fontColor: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              else
                Transform.scale(
                  scale: 0.85,
                  child: Switch.adaptive(
                    value: value,
                    onChanged: onChanged,
                    activeColor: Theme.of(context).primaryColor,
                    activeTrackColor: Theme.of(context).primaryColor.withOpacity(0.4),
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.grey.withOpacity(0.3),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              description,
              style: captionTwoNormalTextStyle(
                context: context,
                fontColor: secondaryTextColor(context: context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper function to show consent dialog
Future<void> showConsentDialog(BuildContext context) async {
  try {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const ConsentDialog();
      },
    );
  } catch (e) {
    // Handle error silently
  }
}