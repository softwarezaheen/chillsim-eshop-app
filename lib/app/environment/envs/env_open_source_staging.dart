import "package:esim_open_source/app/environment/app_environment_helper.dart";

AppEnvironmentHelper openSourceStagingEnvInstance = AppEnvironmentHelper(
  baseApiUrl: "https://chillsim-eshop-api.onrender.com",
  websiteUrl: "chillsim-eshop-web.onrender.com",
  enableBannersView: false,
  enableWalletView: false,
  enablePromoCode: false,
  omniConfigBaseUrl: "",
  omniConfigTenant: "",
  omniConfigApiKey: "",
  omniConfigAppGuid: "",
);
