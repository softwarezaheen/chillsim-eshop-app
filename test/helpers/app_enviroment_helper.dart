import "package:esim_open_source/app/environment/app_environment_helper.dart";

AppEnvironmentHelper createTestEnvironmentHelper() {
  return AppEnvironmentHelper(
    baseApiUrl: "https://test.api.com",
    omniConfigTenant: "test_tenant",
    omniConfigBaseUrl: "https://test.omni.com",
    omniConfigApiKey: "test_api_key",
    omniConfigAppGuid: "test_app_guid",
  );
}
