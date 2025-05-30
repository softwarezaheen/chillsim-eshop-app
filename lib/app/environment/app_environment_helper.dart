import "package:esim_open_source/app/environment/environment_theme.dart";

class AppEnvironmentHelper {
  AppEnvironmentHelper({
    required this.baseApiUrl,
    required this.omniConfigTenant,
    required this.omniConfigBaseUrl,
    required this.omniConfigApiKey,
    required this.omniConfigAppGuid,
    this.websiteUrl = "",
    this.enablePromoCode = true,
    this.enableWalletView = true,
    this.enableBannersView = true,
    this.enableCurrencySelection = true,
    this.environmentTheme = EnvironmentTheme.openSource,
    this.enableLanguageSelection = true,
    this.enableAppleSignIn = true,
    this.enableGoogleSignIn = true,
    this.enableFacebookSignIn = true,
    this.environmentCornerRadius = 25,
    this.environmentFamilyName = "Poppins",
    this.isCruiseEnabled = false,
    this.cruiseIdentifier = "cruise",
    this.supabaseFacebookCallBackScheme = "iosupabaseflutter://login-callback",
  });

  String baseApiUrl;
  bool isCruiseEnabled;
  String cruiseIdentifier;
  double environmentCornerRadius;
  String environmentFamilyName;
  EnvironmentTheme environmentTheme;
  String supabaseFacebookCallBackScheme;
  String omniConfigTenant;
  String omniConfigBaseUrl;
  String omniConfigApiKey;
  String omniConfigAppGuid;
  String websiteUrl;
  //feature flags
  bool enablePromoCode;
  bool enableWalletView;
  bool enableBannersView;
  bool enableCurrencySelection;
  bool enableLanguageSelection;
  //social media flags
  bool enableAppleSignIn;
  bool enableGoogleSignIn;
  bool enableFacebookSignIn;
}
