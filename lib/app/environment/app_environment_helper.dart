import "package:esim_open_source/app/environment/environment_theme.dart";
import "package:esim_open_source/presentation/enums/login_type.dart";
import "package:esim_open_source/presentation/enums/payment_type.dart";

class AppEnvironmentHelper {
  AppEnvironmentHelper({
    required this.baseApiUrl,
    required this.omniConfigTenant,
    required this.omniConfigBaseUrl,
    required this.omniConfigApiKey,
    required this.omniConfigAppGuid,
    this.websiteUrl = "",
    this.defaultLoginType = LoginType.email,
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
    this.defaultPaymentTypeList = const <PaymentType>[
      PaymentType.card,
    ],
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
  LoginType defaultLoginType;
  bool enableBranchIO;
  bool enablePromoCode;
  bool enableWalletView;
  bool enableBannersView;
  bool enableCurrencySelection;
  bool enableLanguageSelection;
  bool enableGuestFlowPurchase;
  List<PaymentType> defaultPaymentTypeList;

  //social media flags
  bool enableAppleSignIn;
  bool enableGoogleSignIn;
  bool enableFacebookSignIn;

  //Login type
  LoginType? _apiLoginType;

  set setLoginTypeFromApi(LoginType? apiLoginType) {
    _apiLoginType = apiLoginType;
  }

  LoginType get loginType => _apiLoginType ?? defaultLoginType;

  //Payment type
  List<PaymentType>? _apiPaymentTypeList;

  set setPaymentTypeListFromApi(List<PaymentType>? apiPaymentTypeList) {
    _apiPaymentTypeList = apiPaymentTypeList;
  }

  List<PaymentType> paymentTypeList({required bool isUserLoggedIn}) {
    List<PaymentType> list = _apiPaymentTypeList ?? defaultPaymentTypeList;
    // check if wallet is enabled
    // if not, we should remove it from payment type bottom sheet
    if ((list.contains(PaymentType.wallet) && !enableWalletView) ||
        (list.contains(PaymentType.wallet) && !isUserLoggedIn)) {
      list.remove(PaymentType.wallet);
    }
    return list;
  }
}
