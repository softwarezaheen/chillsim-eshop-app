import "package:esim_open_source/app/environment/environment_theme.dart";

class AppEnvironmentHelper {
  AppEnvironmentHelper({
    required this.baseApiUrl,
    required this.omniConfigTenant,
    required this.omniConfigBaseUrl,
    required this.omniConfigApiKey,
    required this.omniConfigAppGuid,
    this.websiteUrl = "",
    this.enableBranchIO = false,
    this.enablePromoCode = false,
    this.enableWalletView = false,
    this.enableBannersView = false,
    this.enableCurrencySelection = false,
    this.environmentTheme = EnvironmentTheme.openSource,
    this.enableLanguageSelection = false,
    this.enableAppleSignIn = true,
    this.enableGoogleSignIn = true,
    this.enableFacebookSignIn = true,
    this.enableGuestFlowPurchase = true,
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
  bool enableBranchIO;
  bool enablePromoCode;
  bool enableWalletView;
  bool enableBannersView;
  bool enableCurrencySelection;
  bool enableLanguageSelection;
  bool enableGuestFlowPurchase;
  //social media flags
  bool enableAppleSignIn;
  bool enableGoogleSignIn;
  bool enableFacebookSignIn;
}
