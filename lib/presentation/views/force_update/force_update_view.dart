import "dart:io";

import "package:esim_open_source/app/environment/environment_images.dart";
import "package:esim_open_source/presentation/shared/shared_styles.dart";
import "package:esim_open_source/presentation/shared/ui_helpers.dart";
import "package:esim_open_source/presentation/widgets/main_button.dart";
import "package:esim_open_source/utils/constants.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

class ForceUpdateView extends StatelessWidget {
  const ForceUpdateView({required this.packageName, super.key});

  final String packageName;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: mainAppBackGroundColor(context: context),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Spacer(flex: 3),

                // Logo
                Image.asset(
                  EnvironmentImages.splashIcon.fullImagePath,
                  height: 140,
                  width: 140,
                ),

                verticalSpaceMedium,

                // "New update" label
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    "✨  New Update Available",
                    style: captionOneBoldTextStyle(
                      context: context,
                      fontColor: Colors.white,
                    ),
                  ),
                ),

                verticalSpaceMedium,

                // Headline
                Text(
                  "We've been busy\nbuilding for you",
                  textAlign: TextAlign.center,
                  style: headerOneBoldTextStyle(
                    context: context,
                    fontColor: mainWhiteTextColor(context: context),
                  ),
                ),

                verticalSpaceSmall,

                // Body
                Text(
                  "This update comes packed with new features, smoother performance, and improvements based on your feedback — all to keep you connected wherever you go.\n\nPlease update ChillSIM to continue.",
                  textAlign: TextAlign.center,
                  style: captionOneMediumTextStyle(
                    context: context,
                    fontColor: mainWhiteTextColor(context: context).withOpacity(0.65),
                  ),
                ),

                const Spacer(flex: 4),

                // CTA button
                MainButton(
                  title: "Update Now",
                  themeColor: enabledMainButtonColor(context: context),
                  enabledBackgroundColor: enabledMainButtonColor(context: context),
                  enabledTextColor: mainWhiteTextColor(context: context),
                  onPressed: () async => _openStore(),
                ),

                verticalSpaceMedium,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openStore() async {
    if (Platform.isIOS) {
      // Try native App Store scheme first (works on real device)
      final Uri nativeUri =
          Uri.parse("itms-apps://itunes.apple.com/app/id$IOS_APP_STORE_ID");
      if (await canLaunchUrl(nativeUri)) {
        await launchUrl(nativeUri, mode: LaunchMode.externalApplication);
        return;
      }
      // Fallback for simulator / edge cases — opens in browser
      await launchUrl(
        Uri.parse("https://apps.apple.com/app/id$IOS_APP_STORE_ID"),
        mode: LaunchMode.externalApplication,
      );
    } else {
      await launchUrl(
        Uri.parse(
          "https://play.google.com/store/apps/details?id=$packageName",
        ),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
